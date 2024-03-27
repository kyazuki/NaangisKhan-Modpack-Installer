#[macro_use]
extern crate log;
extern crate simplelog;

use std::env;
use std::fs::{self, File};
use std::io::{BufRead, BufReader, Write};
use std::path::Path;
use std::process;
use std::{error, vec};

use simplelog::*;

fn updater(version: [u32; 3]) -> Result<(), Box<dyn error::Error>> {
    // ロガーを初期化
    let log_path = Path::new("naangiskhan-logs/updater.log");
    fs::create_dir_all(
        log_path
            .parent()
            .ok_or("Failed to get log file parent path.")?,
    )?;
    WriteLogger::init(
        LevelFilter::Info,
        Config::default(),
        File::create(log_path)?,
    )?;

    info!("Starting updater...");
    println!("アップデートを開始します...");
    // 旧リソースパックが残っていれば削除
    let mut is_old_resource = false;
    let old_packs = vec!["resourcepacks/NaangisKhan", "resourcepacks/Naan.zip"];
    for pack in old_packs {
        let path = Path::new(pack);
        match path.try_exists() {
            Ok(false) => {}
            Ok(true) => {
                info!("Found old resource pack: {:?}", path);
                is_old_resource = true;
                if path.is_dir() {
                    fs::remove_dir_all(path).unwrap_or_else(|e| {
                        warn!("Failed to remove old resource pack: {:?}", e);
                    });
                } else {
                    fs::remove_file(path).unwrap_or_else(|e| {
                        warn!("Failed to remove old resource pack: {:?}", e);
                    });
                }
            }
            Err(e) => {
                warn!("Failed to check if old resource pack exists: {:?}", e);
            }
        }
    }
    if is_old_resource {    // 旧仕様であればリソースパックの設定を差し替える
        let mut new_options_txt = String::new();
        match File::open("options.txt") {
            Ok(file) => {
                for result in BufReader::new(file).lines() {
                    let line = result?;
                    if line.starts_with("resourcePacks:") {
                        new_options_txt.push_str("resourcePacks:[");
                        for pack in line[15..(line.len() - 1)].split(",") {
                            let pack = pack.trim();
                            if pack != "NaangisKhan" && pack != "Naan.zip" {
                                // 'Naangiskhan'と'Naan.zip'を除き追加
                                new_options_txt.push_str(pack);
                                new_options_txt.push_str(",");
                            }
                        }
                        // 'NaangisKhan.zip'を末尾(優先度最高)に追加
                        new_options_txt.push_str("file/NaangisKhan.zip]");
                        new_options_txt.push_str("\n");
                    } else {
                        new_options_txt.push_str(&line);
                        new_options_txt.push_str("\n");
                    }
                }
            }
            Err(e) => {
                error!("Failed to open options.txt: {:?}", e);
                eprintln!("設定ファイルが存在しません。");
            }
        };
        match File::create("options.txt.tmp") {
            Ok(mut file) => {
                write!(file, "{}", new_options_txt)?;
                file.flush()?;
                info!("Created options.txt.tmp.");
            }
            Err(e) => {
                error!("Failed to create options.txt.tmp: {:?}", e);
                eprintln!("設定ファイルの更新に失敗しました。");
            }
        }
        fs::rename("options.txt.tmp", "options.txt")?;
        info!("Updated options.txt.");
        println!("設定ファイルを更新しました。");
    }

    // 最新のリソースパックをダウンロード
    println!("リソースパックを更新中...");

    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let version = [0, 0, 0];
    if args.len() >= 2 {
        let version_nums = args[1].split(".");
        if version_nums.len() == 3 {
            let mut i = 0;
            for i in 0..version.len() {
                match num.parse::<u32>() {
                    Ok(n) => {
                        version[i] = n;
                        i += 1;
                    }
                    Err(e) => {
                        break;
                    }
                }
            }
        } else {
            error!("Invalid version number: {:?}", args[1]);
            process::exit(1);
        
    }
    match updater(version) {
        Ok(_) => {
            info!("Updater finished successfully.");
        }
        Err(e) => {
            error!("Updater failed: {:?}", e);
            process::exit(1);
        }
    }
}
