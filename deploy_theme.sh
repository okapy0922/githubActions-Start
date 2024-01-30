#!/bin/bash

# ローカルのテーマディレクトリを指定
local_theme_directory="/home/okapy/pacificmall"

# アーカイブの作成
tar -czvf pacificmall.tar.gz --directory="$local_theme_directory" .

# Dockerコンテナ内のディレクトリのパス
container_directory="/var/www/html/wp-content/themes/pacificmall"

# ディレクトリが存在するか確認
if ! docker exec 3ec0263f325d2ffeae43ef516e0b987b6ac046a67fe472e7710df21f52f091b5 test -d "$container_directory"; then
    # ディレクトリが存在しない場合に作成
    docker exec 3ec0263f325d2ffeae43ef516e0b987b6ac046a67fe472e7710df21f52f091b5 mkdir -p "$container_directory"
    echo "ディレクトリを作成しました。"
else
    echo "ディレクトリは既に存在します。スキップします。"
fi

# Dockerコンテナにファイルをコピー
docker cp pacificmall.tar.gz 3ec0263f325d2ffeae43ef516e0b987b6ac046a67fe472e7710df21f52f091b5:/var/www/html/wp-content/themes

# コピーが完了するのを待つ
sleep 3

# Dockerコンテナ内でファイルを展開
docker exec 3ec0263f325d2ffeae43ef516e0b987b6ac046a67fe472e7710df21f52f091b5 tar -xzvf /var/www/html/wp-content/themes/pacificmall.tar.gz -C /var/www/html/wp-content/themes/pacificmall

# 不要なファイルを削除
docker exec 3ec0263f325d2ffeae43ef516e0b987b6ac046a67fe472e7710df21f52f091b5 rm /var/www/html/wp-content/themes/pacificmall.tar.gz

# ローカルの圧縮ファイルを削除（オプション）
rm pacificmall.tar.gz