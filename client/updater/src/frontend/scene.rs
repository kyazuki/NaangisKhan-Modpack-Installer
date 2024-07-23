use std::any::Any;

use iced::widget::Container;
use iced::{Command, Subscription};

use super::app::{Message, Updater};

pub trait Scene: Any {
    fn as_any(&self) -> &dyn Any;

    fn update(&mut self, message: Message) -> Command<Message>;
    fn view<'a>(&'a self, app: &'a Updater) -> Container<Message>;
    fn subscription<'a>(&'a self, _app: &'a Updater) -> Subscription<Message> {
        Subscription::none()
    }
}
