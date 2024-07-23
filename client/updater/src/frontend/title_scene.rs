use std::any::Any;

use iced::widget::{button, column, text, Container, Space};
use iced::{Alignment, Command, Length};

use super::app::{Message, Updater};
use super::scene::Scene;
use crate::localizer::Key;
use crate::panic_with_log;

#[derive(Debug, Clone)]
pub enum TitleMessage {}

pub struct TitleScene;

impl TitleScene {
    pub fn new() -> Self {
        Self {}
    }
}

impl Scene for TitleScene {
    fn as_any(&self) -> &dyn Any {
        self
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::StartScene => Command::none(),
            Message::Title(m) => match m {
                _ => Command::none(),
            },
            _ => {
                panic_with_log!("Unknown message: {:?}", message);
            }
        }
    }

    fn view<'a>(&'a self, app: &'a Updater) -> Container<Message> {
        const BUTTON_WIDTH: u16 = 60;
        const BUTTON_HEIGHT: u16 = 35;
        Container::new(
            column![
                text(app.localize(&Key::GuiUpdaterTitle)).size(40),
                Space::with_height(20),
                button(
                    Container::new(app.localize(&Key::Start))
                        .width(Length::Fill)
                        .height(Length::Fill)
                        .center_x()
                        .center_y(),
                )
                .width(BUTTON_WIDTH)
                .height(BUTTON_HEIGHT)
                .on_press(Message::NextScene),
            ]
            .align_items(Alignment::Center),
        )
        .padding(20)
        .center_x()
        .center_y()
    }
}
