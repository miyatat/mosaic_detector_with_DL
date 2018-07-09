#!/bin/bash


#学習やテストに使うためのファイルのリストを生成する。
#
#実行方法は以下。
#  ./100_list_maker.sh (画像ファイルが置いてあるディレクトリ)
#このディレクトリから「*_answer.png」を探し、
#それと「*_mosaic.png」が対応しているものとしてリストを作る。
#
#出力フォーマットは以下。
#  (セグメンテーションしたいファイル) (答えのファイル)


\rm -f ./tmp/tempfile.txt

echo
echo "target directory is $1"

find "$1" -name '*_answer.png' > ./tmp/tempfile.txt
sed -i 's|\(.*\)_answer.png|\1_mosaic.png \0|g' './tmp/tempfile.txt' num=`wc -l './tmp/tempfile.txt' | awk '{print $1}'`

echo
echo "done. file num is $num"
echo
echo "please divide ./tmp/tempfile.txt for train and validation. do like below."
echo "  split -l 1000 ./tmp/tempfile.txt; mv xaa filelist_train.txt; mv xab filelist_val.txt; cp filelist_val.txt filelist_test.txt"


