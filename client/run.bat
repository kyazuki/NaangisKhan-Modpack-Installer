@echo off
REM "文字コードをUTF-8に設定"
chcp 65001 > nul
REM "Javaがなければインストール"
java --version > nul 2>&1
if errorlevel 1 (
    echo Javaをインストール中...
    winget install --id Microsoft.OpenJDK.17 > nul 2>&1
    if errorlevel 1 (
        echo Javaのインストールに失敗しました。 1>&2
        pause
        exit 1
    )
    echo Javaのインストールが完了しました。再度実行してください。
    pause
    exit 0
)
REM "設定ファイル・リソースをダウンロードして展開"
echo リソースをダウンロード中...
bitsadmin /transfer resources /priority FOREGROUND https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.0.9/client.zip "%CD%\client.zip" > nul
if errorlevel 1 (
    echo リソースのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
jar xf client.zip > nul 2>&1
if errorlevel 1 (
    tar -xf client.zip > nul 2>&1
    if errorlevel 1 (
        call powershell -command "Expand-Archive -Force -Path client.zip -DestinationPath .\ | Out-Null" > nul 2>&1
        if errorlevel 1 (
            echo リソースの展開に失敗しました。 1>&2
            pause
            exit 1
        )
    )
)
del client.zip
REM "インストーラーをダウンロードして実行"
echo インストーラーをダウンロード中...
bitsadmin /transfer installer /priority FOREGROUND https://github.com/kyazuki/Minecraft-Modpack-Installer/releases/download/v1.1.3/minecraft-modpack-installer-1.1.3.jar "%CD%\minecraft-modpack-installer.jar" > nul
if errorlevel 1 (
    echo インストーラーのダウンロードに失敗しました。 1>&2
    pause
    exit 1
)
echo インストール中...
java -jar minecraft-modpack-installer.jar