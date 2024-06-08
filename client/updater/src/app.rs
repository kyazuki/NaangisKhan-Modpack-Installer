use iced::widget::{button, column, progress_bar, text};
use iced::{executor, Alignment, Application, Element, Settings};
use iced::{Command, Theme};

pub struct Updater {
    value: i32,
}

#[derive(Debug, Clone, Copy)]
pub enum Message {
    IncrementPressed,
    DecrementPressed,
    Progressed(f32),
}

impl Updater {
    pub fn start() -> iced::Result {
        let setting = Settings::default();
        Updater::run(setting)
    }
}

impl Application for Updater {
    type Executor = executor::Default;
    type Message = Message;
    type Theme = Theme;
    type Flags = ();

    fn new(_flags: Self::Flags) -> (Updater, Command<Message>) {
        (Self { value: 0 }, Command::none())
    }

    fn title(&self) -> String {
        String::from("ナンギスカンアップデータ")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::IncrementPressed => {
                self.value += 1;
                Command::none()
            }
            Message::DecrementPressed => {
                self.value -= 1;
                Command::none()
            }
            Message::Progressed(progress) => {
                self.value = progress as i32;
                Command::none()
            }
        }
    }

    fn view(&self) -> Element<Message> {
        column![
            button("Increment").on_press(Message::IncrementPressed),
            text(self.value).size(50),
            button("Decrement").on_press(Message::DecrementPressed),
            progress_bar(0.0..=100.0, self.value as f32)
        ]
        .padding(20)
        .align_items(Alignment::Center)
        .into()
    }

    fn theme(&self) -> Self::Theme {
        Theme::Dark
    }
}
