#!/bin/bash


#途中で保存されたモデルはファイル名にiteration数がついていて邪魔なので、
#それを除去するスクリプト。
#使用方法は以下。
#  ./201_move_model.sh logs_20180117_005941/model.ckpt-100.data-00000-of-00001


echo "target is $1"

base=`echo "$1" | sed 's|\(ckpt-[0-9]\+\).*|\1|g'`

echo "base is $base"

\cp -v -a "$base".data-00000-of-00001 model.ckpt.data-00000-of-00001
\cp -v -a "$base".index model.ckpt.index
\cp -v -a "$base".meta model.ckpt.meta
