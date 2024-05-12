// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

#[macro_use]
extern crate log;
extern crate simplelog;

mod updater;
mod version;

use std::env;
use std::error;
use std::fs::{self, File};
use std::path::Path;
use std::process;

use simplelog::*;
use tauri::Manager;

use crate::updater::update;
use crate::version::Version;

fn initialize_logger(path: &str) -> Result<(), Box<dyn error::Error>> {
    let log_path = Path::new(path);
    // ログファイルまでのディレクトリを作成
    fs::create_dir_all(
        log_path
            .parent()
            .ok_or("Failed to get log file parent path.")?,
    )?;
    // ログファイルの作成 && ロガーの初期化
    WriteLogger::init(
        LevelFilter::Info,
        Config::default(),
        File::create(log_path)?,
    )?;
    Ok(())
}

fn main() {
    // ロガーの初期化
    if let Err(e) = initialize_logger("naangiskhan-logs/updater.log") {
        error!("Failed to initialize logger: {:?}", e);
        process::exit(1);
    }
    // バージョン引数のパース
    let args: Vec<String> = env::args().collect();
    let mut version: Option<Version> = None;
    if args.len() >= 2 {
        let version_str: &str = &args[1];
        match version_str.try_into() {
            Ok(v) => {
                version = Some(v);
            }
            Err(e) => {
                error!("Invalid version number: {:?}", e);
                process::exit(1);
            }
        }
    }
    // GUIを起動
    if let Err(e) = tauri::Builder::default()
        .setup(|app| {
            let _id = app.once_global("initialized", |_event| {
                match update(version) {
                    Ok(_) => {
                        info!("Updater finished successfully.");
                    }
                    Err(e) => {
                        error!("Updater failed: {:?}", e);
                        process::exit(1);
                    }
                }
            });

            Ok(())
        })
        .run(tauri::generate_context!())
    {
        error!("Error while running tauri application: {:?}", e);
        process::exit(1);
    }
}
