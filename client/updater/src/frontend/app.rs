use std::any::TypeId;
use std::process;

use iced::futures::future;
use iced::widget::{self, column, container, row, Container};
use iced::{
    executor, font, window, Application, Command, Element, Font, Length, Settings, Subscription,
    Theme,
};

use super::scene::Scene;
use super::title_scene::{TitleMessage, TitleScene};
use super::updater_scene::{UpdaterMessage, UpdaterScene};
use crate::localizer::{Key, Language, Localizer};
use crate::panic_with_log;
use crate::version::Version;

#[derive(Debug, Clone)]
pub enum Message {
    LanguageSelected(Language),
    StartScene,
    NextScene,
    ErrorExit,
    Title(TitleMessage),
    Updater(UpdaterMessage),
}

pub struct Updater {
    current_version: Option<Version>,
    language: Language,
    scene: Box<dyn Scene>,
}

impl Updater {
    pub fn start(current_version: Option<Version>, is_auto_start: bool) -> iced::Result {
        let mut setting = Settings::with_flags((current_version, is_auto_start));
        setting.window.icon = window::icon::from_file_data(crate::PACK_IMAGE, None)
            .inspect_err(|e| error!("An error occurred when loading icon data. {}", e))
            .ok();
        setting.default_font = Font {
            family: font::Family::Name("Meiryo UI"),
            ..Font::default()
        };
        Updater::run(setting)
    }

    pub fn localize(&self, key: &Key) -> &str {
        Localizer::get_by_lang(key, &self.language)
    }

    pub fn localize_with_params(&self, key: &Key, params: &Vec<String>) -> String {
        Localizer::get_with_params_by_lang(key, params, &self.language)
    }
}

impl Application for Updater {
    type Executor = executor::Default;
    type Message = Message;
    type Theme = Theme;
    type Flags = (Option<Version>, bool);

    fn new(flags: Self::Flags) -> (Self, Command<Message>) {
        (
            Self {
                current_version: flags.0,
                language: Localizer::get_language(),
                scene: if !flags.1 {
                    Box::new(TitleScene::new())
                } else {
                    Box::new(UpdaterScene::new(flags.0))
                },
            },
            Command::perform(future::ready(()), |_| Message::StartScene),
        )
    }

    fn title(&self) -> String {
        self.localize(&Key::GuiUpdaterTitle).to_string()
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::LanguageSelected(lang) => {
                self.language = lang;
                Command::none()
            }
            Message::NextScene => {
                if self.scene.as_any().type_id() == TypeId::of::<TitleScene>() {
                    self.scene = Box::new(UpdaterScene::new(self.current_version));
                    self.update(Message::StartScene)
                } else if self.scene.as_any().type_id() == TypeId::of::<UpdaterScene>() {
                    // TODO: インストーラを取り込むまでの一時措置
                    // window::close(window::Id::MAIN)
                    info!("GUI Updater finished successfully.");
                    process::exit(0);
                } else {
                    panic_with_log!("Unknown scene.");
                }
            }
            Message::ErrorExit => process::exit(1),
            _ => self.scene.update(message),
        }
    }

    fn view(&self) -> Element<Message> {
        const MENU_HEIGHT: u16 = 30;
        const LANGUAGE_DROP_DOWN_WIDTH: u16 = 120;
        let menu = (|| {
            let drop_down = widget::pick_list(Language::list(), Some(self.language), |choose| {
                Message::LanguageSelected(choose)
            })
            .width(LANGUAGE_DROP_DOWN_WIDTH);
            let content = row![widget::horizontal_space(), drop_down]
                .width(Length::Fill)
                .height(Length::Fill);
            Container::new(content)
                .width(Length::Fill)
                .height(MENU_HEIGHT)
                .style(
                    container::Appearance::default()
                        .with_background(iced::Color::from_rgb8(255, 255, 255)),
                )
        })();
        let pane = self
            .scene
            .view(self)
            .width(Length::Fill)
            .height(Length::Fill);
        let content = column![menu, pane];
        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .center_x()
            .center_y()
            .into()
    }

    fn theme(&self) -> Self::Theme {
        Theme::Dark
    }

    fn subscription(&self) -> Subscription<Message> {
        self.scene.subscription(self)
    }
}
