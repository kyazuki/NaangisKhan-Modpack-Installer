@echo off
setlocal enabledelayedexpansion
REM "文字コードをUTF-8に設定"
chcp 65001 > nul
echo アップデートを開始します...
REM "旧リソースパックが残っていれば削除"
if exist resourcepacks\NaangisKhan (
    rmdir /q /s resourcepacks\Naangiskhan > nul 2>&1
    set OLD_RESOURCES=1
)
if exist resourcepacks\Naan.zip (
    del /q resourcepacks\Naan.zip > nul 2>&1
    set OLD_RESOURCES=1
)
REM "旧仕様であればリソースパックの設定を差し替える"
if defined OLD_RESOURCES (
    if not exist options.txt (
        echo 設定ファイルが存在しません。 1>&2
        pause
        exit 1
    )
    for /f "tokens=* USEBACKQ" %%F in (`findstr /b resourcePacks options.txt`) do (
        set "RESOURCE_PACKS=%%F"
    )
    set RESOURCE_PACKS=!RESOURCE_PACKS:~15,-1!
    set AFTER_RESOURCE_PACKS=
    set left=!RESOURCE_PACKS!
    :loop
    for /f "tokens=1* delims=," %%a in ("%left%") do (
        if not %%a == "file/Naangiskhan" if not %%a == "file/Naan.zip" (
            set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS%,%%a
        )
        set left=%%b
    )
    if defined left goto :loop
    set AFTER_RESOURCE_PACKS=%AFTER_RESOURCE_PACKS:~1%,"file/NaangisKhan.zip"
    del /q options.txt.tmp > nul 2>&1
    for /f "delims=" %%L in (options.txt) do (
        echo %%L | find "resourcePacks" > nul 2>&1
        if errorlevel 1 (
            (echo %%L) >> options.txt.tmp
        ) else (
            (echo resourcePacks:[%AFTER_RESOURCE_PACKS%]) >> options.txt.tmp
        )
    )
    move /y options.txt.tmp options.txt > nul 2>&1
)
REM "最新のリソースパックをダウンロード"
echo リソースパックを更新中...
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v%LATEST_VERSION%/NaangisKhan.zip "%CD%\resourcepacks\NaangisKhan.zip" > nul
if errorlevel 1 (
    echo リソースパックのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
REM "マイグレーション処理"
echo アップデート中...
REM "v1.0.15アップデート"
call :is_old_version 1.0.15
if not errorlevel 1 (
    REM "Polymorphをダウンロード"
    call :download_file "%CD%\mods\polymorph-forge-0.49.2+1.20.1.jar" https://www.curseforge.com/api/v1/mods/388800/files/4928442/download
)
echo アップデートが完了しました。
exit /b 0

REM "現行バージョンが指定されたバージョンより古いかを判定するサブルーチン"
:is_old_version
REM "直接update.batが実行された場合(INSTALLED_VERSIONが未定義)は強制アップデートとする"
if not defined INSTALLED_VERSION (
    exit /b 0
)
set CHECK_VERSION=%1
for /f "tokens=1* delims=." %%a in ("%1") do (
    set check_major=%%a
    set check_minor=%%b
    set check_patch=%%c
)
for /f "tokens=1* delims=." %%a in ("%INSTALLED_VERSION%") do (
    if %%a lss %check_major% (
        exit /b 0
    ) else if %%b lss %check_minor% (
        exit /b 0
    ) else if %%c lss %check_patch% (
        exit /b 0
    )
)
exit /b 1

REM "指定されたパスへ、指定されたURLからファイルをダウンロードするサブルーチン"
REM "ダウンロードエラーが発生した場合はプロセスを終了させる"
:download_file
if not exist %1 (
    bitsadmin /transfer installer /priority FOREGROUND %2 %1 > nul
    if not exist %1 (
        echo ファイルのダウンロードに失敗しました。 1>&2
        echo 詳細: %1
        exit 1
    )
)
exit /b 0

endlocal