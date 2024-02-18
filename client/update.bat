@echo off
setlocal
REM "文字コードをUTF-8に設定"
chcp 65001 > nul
echo "アップデートを開始します..."
REM "専用リソースパックをダウンロード"
if exist resourcepacks\NaangisKhan (
    del /q resourcepacks\Naangiskhan > nul 2>&1
    set OLD_RESOURCES=1
)
if exist resourcepacks\Naan.zip (
    del /q resourcepacks\Naan.zip > nul 2>&1
    set OLD_RESOURCES=1
)
REM "最新のリソースパックをダウンロード"
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.0.15/NaangisKhan.zip "%CD%\resourcepacks\NaangisKhan.zip" > nul
REM "不足しているMODをダウンロード"
if not exist mods\polymorph*.jar (
    bitsadmin /transfer installer /priority FOREGROUND https://www.curseforge.com/api/v1/mods/388800/files/4928442/download "%CD%\mods\polymorph-forge-0.49.2+1.20.1.jar" > nul
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
    set RESOURCE_PACKS=%RESOURCE_PACKS:~15,-1%
    set AFTER_RESOURCE_PACKS=
    set left=%RESOURCE_PACKS%
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
endlocal