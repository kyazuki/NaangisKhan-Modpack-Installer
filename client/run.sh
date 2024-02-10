#!/bin/bash
# Javaがなければインストール
java --version > nul 2>&1
if [ $? -ne 0 ]; then
    if [ "$(uname)" == 'Darwin']; then  # macOS
        echo -e Javaのインストールが必要です。下記リンクからインストールした後に再実行してください。\\nhttps://www.oracle.com/jp/java/technologies/downloads/#jdk17-mac 1>&2
        exit 1
    else    # Linux
        sudo apt update > nul 2>&1
        sudo apt install -y openjdk-17-jdk > nul 2>&1
        if [ $? -ne 0 ]; then
            echo Javaのインストールに失敗しました。 1>&2
            exit 1
        fi
    fi
fi
# 設定ファイル・リソースをダウンロードして展開
echo リソースをダウンロード中...
curl -OsSf https://github.com/kyazuki/NaangisKhan-Modpack-Installer/releases/download/v1.0.0/client.zip 2>/dev/null
if [ $? -ne 0 ]; then
    echo リソースのダウンロードに失敗しました。 1>&2
    exit 1
fi
jar --version > nul 2>&1
if [ $? -eq 0 ]; then   # jarコマンドが使える場合
    jar xf client.zip > nul 2>&1
else # jarコマンドが使えない場合
    unzip client.zip > nul 2>&1
fi
if [ $? -ne 0 ]; then
    echo リソースの展開に失敗しました。 1>&2
    exit 1
fi
rm client.zip
# インストーラーをダウンロードして実行
echo インストーラーをダウンロード中...
curl -OsSf https://github.com/kyazuki/Minecraft-Modpack-Installer/releases/download/v1.1.0/minecraft-modpack-installer-1.1.0.jar 2>/dev/null
if [ $? -ne 0 ]; then
    echo インストーラーのダウンロードに失敗しました。 1>&2
fi
echo インストール中...
java -jar minecraft-modpack-installer-1.1.0.jar