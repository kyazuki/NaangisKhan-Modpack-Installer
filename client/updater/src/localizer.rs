use std::fmt::{self, Display, Formatter};
use std::sync::OnceLock;
use std::{collections::HashMap, hash::Hash};

use sys_locale::get_locales;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Language {
    English,
    Japanese,
}

impl Language {
    pub fn list() -> Vec<Language> {
        vec![Language::English, Language::Japanese]
    }
}

impl Display for Language {
    fn fmt(&self, f: &mut Formatter) -> fmt::Result {
        match self {
            Language::English => write!(f, "English"),
            Language::Japanese => write!(f, "日本語"),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum Key {
    Empty,
    Start,
    Exit,
    CommandLineArgCurrentVersion,
    CommandLineArgIsAutoStart,
    CommandLineArgIsNoGui,
    GuiUpdaterTitle,
    UpdaterSceneUpdateStart,
    UpdaterSceneUpdateStartForce,
    UpdaterSceneUpdateFinished,
    UpdaterSceneUpdateError,
    UpdaterSceneUpdateConfigFile,
    UpdaterSceneUpdateConfigFileSuccess,
    UpdaterSceneUpdateConfigFileError,
    UpdaterSceneUpdateConfigFileNoExist,
    UpdaterSceneUpdateResourcePack,
    UpdaterSceneUpdateVersion,
    UpdaterSceneUpdateModInstall,
    UpdaterSceneUpdateModUpdate,
    UpdaterSceneUpdateModRemove,
    UpdaterSceneUpdateResourcePackInstall,
    UpdaterSceneUpdateResourcePackReorder,
    UpdaterSceneUpdateResourceConfigFile,
}

pub struct Localizer;

const FALLBACK_LANG: Language = Language::English;
static RESOURCES: OnceLock<HashMap<Key, HashMap<Language, &'static str>>> = OnceLock::new();

impl Localizer {
    pub fn get(key: &Key) -> &'static str {
        Self::get_by_lang(key, &Self::get_language())
    }

    pub fn get_with_params(key: &Key, params: &Vec<String>) -> String {
        Self::get_with_params_by_lang(key, params, &Self::get_language())
    }

    pub fn get_with_params_by_lang(key: &Key, params: &Vec<String>, lang: &Language) -> String {
        let mut message = Self::get_by_lang(key, lang).to_string();
        for param in params {
            message = message.replacen("{}", param, 1);
        }
        message
    }

    pub fn get_by_lang(key: &Key, lang: &Language) -> &'static str {
        if key == &Key::Empty {
            return "";
        }
        let resources = RESOURCES.get_or_init(|| {
            HashMap::from([
                (
                    Key::Start,
                    HashMap::from([(Language::English, "Start"), (Language::Japanese, "開始")]),
                ),
                (
                    Key::Exit,
                    HashMap::from([(Language::English, "Exit"), (Language::Japanese, "閉じる")]),
                ),
                (
                    Key::CommandLineArgCurrentVersion,
                    HashMap::from([
                        (Language::English, "Current pack version"),
                        (Language::Japanese, "現在のパックバージョン"),
                    ]),
                ),
                (
                    Key::CommandLineArgIsAutoStart,
                    HashMap::from([
                        (Language::English, "Whether to start automatically"),
                        (
                            Language::Japanese,
                            "自動的にアップデート処理を起動するかどうか",
                        ),
                    ]),
                ),
                (
                    Key::CommandLineArgIsNoGui,
                    HashMap::from([
                        (Language::English, "Whether to launch with gui"),
                        (Language::Japanese, "GUI有りで起動するかどうか"),
                    ]),
                ),
                (
                    Key::GuiUpdaterTitle,
                    HashMap::from([
                        (Language::English, "NaangisKhan Updater"),
                        (Language::Japanese, "ナンギスカンアップデータ"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateStart,
                    HashMap::from([
                        (Language::English, "Starting update..."),
                        (Language::Japanese, "アップデートを開始します..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateStartForce,
                    HashMap::from([
                        (Language::English, "Starting force update..."),
                        (Language::Japanese, "強制アップデートを開始します..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateFinished,
                    HashMap::from([
                        (Language::English, "Update finished."),
                        (Language::Japanese, "アップデートが完了しました。"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateError,
                    HashMap::from([
                        (Language::English, "An error occurred during the update."),
                        (Language::Japanese, "アップデート中にエラーが発生しました。"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateConfigFile,
                    HashMap::from([
                        (Language::English, "Migrating the configuration file..."),
                        (Language::Japanese, "設定ファイルをマイグレーション中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateConfigFileSuccess,
                    HashMap::from([
                        (Language::English, "Updated the configuration file."),
                        (Language::Japanese, "設定ファイルを更新しました。"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateConfigFileError,
                    HashMap::from([
                        (
                            Language::English,
                            "Failed to update the configuration file.",
                        ),
                        (Language::Japanese, "設定ファイルの更新に失敗しました。"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateConfigFileNoExist,
                    HashMap::from([
                        (Language::English, "The configuration file does not exist."),
                        (Language::Japanese, "設定ファイルが存在しません。"),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateResourcePack,
                    HashMap::from([
                        (Language::English, "Updating resource pack..."),
                        (Language::Japanese, "リソースパックを更新中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateVersion,
                    HashMap::from([
                        (Language::English, "Applying update {}..."),
                        (Language::Japanese, "{}アップデートの適用を開始します..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateModInstall,
                    HashMap::from([
                        (Language::English, "Installing mods..."),
                        (Language::Japanese, "追加Modをインストール中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateModUpdate,
                    HashMap::from([
                        (Language::English, "Updating mods..."),
                        (Language::Japanese, "Modをアップデート中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateModRemove,
                    HashMap::from([
                        (Language::English, "Removing mods..."),
                        (Language::Japanese, "Modを削除中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateResourcePackInstall,
                    HashMap::from([
                        (Language::English, "Installing resource packs..."),
                        (Language::Japanese, "追加リソースパックをインストール中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateResourcePackReorder,
                    HashMap::from([
                        (Language::English, "Ordering resource packs..."),
                        (Language::Japanese, "リソースパックを整理中..."),
                    ]),
                ),
                (
                    Key::UpdaterSceneUpdateResourceConfigFile,
                    HashMap::from([
                        (Language::English, "Applying update to {}..."),
                        (Language::Japanese, "{}の設定を変更中..."),
                    ]),
                ),
            ])
        });
        let r = resources.get(key).unwrap();
        r.get(lang).or_else(|| r.get(&FALLBACK_LANG)).unwrap()
    }

    pub fn get_language() -> Language {
        let mut language = FALLBACK_LANG;
        for lang in get_locales() {
            match lang.as_str() {
                "en-US" => {
                    language = Language::English;
                    break;
                }
                "ja-JP" => {
                    language = Language::Japanese;
                    break;
                }
                _ => continue,
            }
        }
        language
    }
}
