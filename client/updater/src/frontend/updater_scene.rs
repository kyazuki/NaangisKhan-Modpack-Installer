use std::any::Any;
use std::sync::mpsc::{self, Receiver};

use iced::futures::{self, stream};
use iced::widget::{button, column, progress_bar, text, Container, Space};
use iced::{subscription, Alignment, Command, Length, Subscription};

use super::app::{Message, Updater};
use super::scene::Scene;
use crate::backend::updater::update;
use crate::localizer::Key;
use crate::panic_with_log;
use crate::version::Version;

#[derive(Debug, Clone)]
struct State {
    message_key: Option<Key>,
    message_params: Vec<String>,
    sub_message_key: Option<Result<Key, Key>>,
    mod_name: Option<String>,
    progress: Option<f32>,
}

#[derive(Debug, Clone)]
pub enum UpdaterMessage {
    Progressed(Option<State>),
    Finished,
    Error,
}

pub struct UpdaterScene {
    current_version: Option<Version>,
    message_key: Key,
    message_params: Vec<String>,
    sub_message_key: Key,
    is_sub_message_error: bool,
    mod_name: String,
    progress: f32,
    is_finished: bool,
    is_error_exit: bool,
}

impl UpdaterScene {
    pub fn new(version: Option<Version>) -> Self {
        Self {
            current_version: version,
            message_key: Key::UpdaterSceneUpdateStart,
            message_params: vec![],
            sub_message_key: Key::Empty,
            is_sub_message_error: false,
            mod_name: String::from(""),
            progress: 0.,
            is_finished: false,
            is_error_exit: false,
        }
    }

    async fn wait_for_update(rx: Receiver<State>) -> Option<(Message, Receiver<State>)> {
        match rx.recv() {
            Ok(state) => Some((
                Message::Updater(UpdaterMessage::Progressed(Some(state))),
                rx,
            )),
            Err(e) => {
                warn!("Receiver is disconnected: {:?}", e);
                None
            }
        }
    }
}

impl Scene for UpdaterScene {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::StartScene => Command::none(),
            Message::Updater(m) => match m {
                UpdaterMessage::Progressed(state) => {
                    if let Some(state) = state {
                        if let Some(message) = state.message_key {
                            self.message_key = message;
                            self.message_params = state.message_params;
                        }
                        if let Some(sub_message) = state.sub_message_key {
                            match sub_message {
                                Ok(key) => {
                                    self.sub_message_key = key;
                                    self.is_sub_message_error = false;
                                }
                                Err(key) => {
                                    self.sub_message_key = key;
                                    self.is_sub_message_error = true;
                                }
                            }
                        }
                        if let Some(name) = state.mod_name {
                            self.mod_name = name;
                        }
                        if let Some(progress) = state.progress {
                            self.progress = progress;
                        }
                    }
                    Command::none()
                }
                UpdaterMessage::Finished => {
                    self.message_key = Key::UpdaterSceneUpdateFinished;
                    self.sub_message_key = Key::Empty;
                    self.mod_name = "".to_string();
                    self.progress = 100.;
                    self.is_finished = true;
                    Command::none()
                }
                UpdaterMessage::Error => {
                    self.message_key = Key::UpdaterSceneUpdateError;
                    self.mod_name = "".to_string();
                    self.progress = 100.;
                    self.is_error_exit = true;
                    Command::none()
                }
            },
            _ => {
                panic_with_log!("Unknown message: {:?}", message);
            }
        }
    }

    fn view<'a>(&'a self, app: &'a Updater) -> Container<Message> {
        Container::new((|| {
            let mut columns = column![
                text(app.localize_with_params(&self.message_key, &self.message_params)).size(20),
                Space::with_height(10),
                (|| {
                    let mut sub_text = text(app.localize(&self.sub_message_key)).size(15);
                    if self.is_sub_message_error {
                        sub_text = sub_text.style(iced::Color::from_rgb8(255, 255, 0));
                    }
                    sub_text
                })(),
                Space::with_height(5),
                text(&self.mod_name).size(15),
                Space::with_height(10),
                Container::new(progress_bar(0.0..=100.0, self.progress)).max_width(500),
            ]
            .align_items(Alignment::Center);
            const MARGIN: u16 = 10;
            const BUTTON_WIDTH: u16 = 60;
            const BUTTON_HEIGHT: u16 = 35;
            if !self.is_finished {
                // 完了時にズレないよう、ボタンの高さ分の余白を確保
                columns = columns.push(Space::with_height(MARGIN + BUTTON_HEIGHT));
            } else {
                columns = columns.push(Space::with_height(MARGIN));
                columns = columns.push(
                    button(
                        Container::new(app.localize(&Key::Exit))
                            .width(Length::Fill)
                            .height(Length::Fill)
                            .center_x()
                            .center_y(),
                    )
                    .width(BUTTON_WIDTH)
                    .height(BUTTON_HEIGHT)
                    .on_press(if !self.is_error_exit {
                        Message::NextScene
                    } else {
                        Message::ErrorExit
                    }),
                );
            }
            columns
        })())
        .padding(20)
        .center_x()
        .center_y()
    }

    fn subscription<'a>(&'a self, _app: &'a Updater) -> Subscription<Message> {
        let current_version = self.current_version.clone();
        let (sender, receiver) = mpsc::channel();
        Subscription::batch(vec![
            subscription::run_with_id(
                0,
                futures::stream::unfold(receiver, |rx| Self::wait_for_update(rx)),
            ),
            subscription::run_with_id(
                1,
                stream::once(async move {
                    match update(
                        current_version,
                        move |message_key,
                              message_params,
                              sub_message_key,
                              resource_name,
                              progress| {
                            if let Err(e) = sender.send(State {
                                message_key: message_key,
                                message_params: message_params,
                                sub_message_key: sub_message_key,
                                mod_name: resource_name,
                                progress,
                            }) {
                                warn!("Failed to send message: {:?}", e);
                            }
                        },
                    )
                    .await
                    {
                        Ok(_) => Message::Updater(UpdaterMessage::Finished),
                        Err(e) => {
                            error!("Failed to update: {:?}", e);
                            Message::Updater(UpdaterMessage::Error)
                        }
                    }
                }),
            ),
        ])
    }
}
