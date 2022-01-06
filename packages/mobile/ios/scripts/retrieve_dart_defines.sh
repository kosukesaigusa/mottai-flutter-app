#!/bin/sh

# Dart-define を書き込んだり、Flavor ごとの xcconfig を include するファイル
OUTPUT_FILE="${SRCROOT}/Flutter/DartDefines.xcconfig"

# Flutter 2.2 以降で必要な、Dart-Defines のデコード処理 
function decode_url() { echo "${*}" | base64 --decode; }

# 最初にファイルの内容をいったん空にする
: > $OUTPUT_FILE

IFS=',' read -r -a define_items <<<"$DART_DEFINES"

for index in "${!define_items[@]}"
do
    # Flutter 2.2 以降で必要なデコードを実行する
    item=$(decode_url "${define_items[$index]}")
    # FLAVOR が含まれる Dart Define の場合
    if [ $(echo $item | grep 'FLAVOR') ] ; then
        # FLAVOR の値
        value=${item#*=}
        # FLAVOR に対応した xcconfig ファイルを include させる
        echo "#include \"$value.xcconfig\"" >> $OUTPUT_FILE
    fi
done
