#!/bin/bash


#引数のファイルを正方形にし、ランダムにモザイクをかけた画像と、そのかけた箇所を示す正解画像を生成。
#元のファイル名がtest.jpgとしたら、同じディレクトリにtest_mosaic.pngと、test_answer.pngが
#生成される。


#出力画像のサイズ。必ず正方形とする。
gazou_size_w=480
gazou_size_h=360

#モザイクの1ブロックの大きさの上限と下限。
mosaic_size_max=20
mosaic_size_min=10

#モザイクをかけるエリアの最小値。
mosaic_min_area_size=20


for target_file in "$@"; do
	#理由がわからないが、output_file_resizeだけはjpgじゃないと縮小して拡大してもモザイクにならない。
	output_file_resize=${target_file%.*}_generated_resize.jpg
	output_file_mosaic=${target_file%.*}_generated_mosaic.png
	output_file_seikai=${target_file%.*}_generated_answer.png
	output_file_seikai_for_debug=${target_file%.*}_generated_answer_for_debug.png
	echo; echo "target_file=$target_file"; echo "output_file_mosaic=$output_file_mosaic"; echo "output_file_seikai=$output_file_seikai"; echo "output_file_seikai_for_debug=$output_file_seikai_for_debug"

	#ファイル名にgeneratedと含まれていたら、過去に生成されたファイルなのでスキップ。
	echo ${target_file} | grep 'generated'
	if [ $? -eq 0 ]; then
		echo "it is generated file. skip."
		continue
	fi

	#すでに生成されていたらスキップ。
	if [ -f $output_file_mosaic ]; then
		echo "already generated. skip."
		continue
	fi

	#モザイクサイズを計算。
	mosaic_size=$(($RANDOM % ($mosaic_size_max - $mosaic_size_min + 1) + $mosaic_size_min))
	echo "mosaic_size_max=$mosaic_size_max"; echo "mosaic_size_min=$mosaic_size_min"; echo "mosaic_size=$mosaic_size"

	#元画像の大きさ取得。
	read picture_w picture_h <<<`identify -format "%w %h\n" $target_file`
	echo "picture_w=$picture_w"; echo "picture_h=$picture_h";

	#小さすぎる場合はスキップ。
	if [ $picture_w -lt ${gazou_size_w} -o $picture_h -lt ${gazou_size_h} ]; then
		echo "image too small. skip."
		continue
	fi

	#サイズを整える。
	if [ $picture_w -eq ${gazou_size_w} -a $picture_h -eq ${gazou_size_h} ]; then
		echo "size are already ${gazou_size_w}x${gazou_size_h}. just copy."
		cp ${target_file} ${output_file_resize}
	else
		echo "size are different. resize."
		echo "size are different. resize to ${gazou_size_w}x${gazou_size_h}."
		convert -gravity center -crop ${gazou_size_w}x${gazou_size_h}+0+0 -resize ${gazou_size_w}x${gazou_size_h} ${target_file} ${output_file_resize}
		picture_w=${gazou_size_w}
		picture_h=${gazou_size_h}
	fi

	#モザイクをかける左上端の座標と、モザイクの大きさと、モザイクをかける右下端の座標を計算。
	mosaic_start_x=$(($RANDOM % ($picture_w - $mosaic_min_area_size)))
	mosaic_start_y=$(($RANDOM % ($picture_h - $mosaic_min_area_size)))
	mosaic_w=$(($RANDOM % ($picture_w - $mosaic_start_x - $mosaic_min_area_size) + $mosaic_min_area_size ))
	mosaic_h=$(($RANDOM % ($picture_h - $mosaic_start_y - $mosaic_min_area_size) + $mosaic_min_area_size ))
	mosaic_end_x=$(($mosaic_start_x + $mosaic_w))
	mosaic_end_y=$(($mosaic_start_y + $mosaic_h))
	echo "mosaic_start_x=$mosaic_start_x"; echo "mosaic_start_y=$mosaic_start_y"; echo "mosaic_w=$mosaic_w"; echo "mosaic_h=$mosaic_h"; echo "mosaic_end_x=$mosaic_end_x"; echo "mosaic_end_y=$mosaic_end_y";

	#モザイクの大きさから、resize指定する際の値を計算。
	resize1=`echo "scale=5; 100.0 / $mosaic_size" | bc`%
	resize2=${picture_w}x${picture_h}
	echo "mosaic_size=$mosaic_size"; echo "resize1=$resize1"; echo "resize2=$resize2";

	#変換。
	#一度全体を縮小、拡大してモザイク状にし、必要部分をcropして抜き出し、compositeで貼り付けた。
	convert ${output_file_resize} '(' ${output_file_resize} -interpolate Nearest -filter point -resize ${resize1} -resize ${resize2} -crop ${mosaic_w}x${mosaic_h}+${mosaic_start_x}+${mosaic_start_y} +repage ')' -geometry +${mosaic_start_x}+${mosaic_start_y} -composite ${output_file_mosaic}
	convert ${output_file_mosaic} ${output_file_mosaic}

	#正解画像を作る。
	#モザイク部分のみラベル付けをすべく背景は0、モザイク部分だけ#010101で
	#塗ったところうまく判別できず(単にiterationが少なかっただけかも)。
	#しょうがないので背景も、モザイク部分もそれぞれ別の
	#ラベル付けした箇所として扱うよう、背景は#010101、
	#モザイク部分は#020202で塗ったところうまくいった。
	#convert -size ${picture_w}x${picture_h} xc:black -fill "#010101" -draw "rectangle ${mosaic_start_x},${mosaic_start_y} ${mosaic_end_x},${mosaic_end_y}" ${output_file_seikai}
	convert -size ${picture_w}x${picture_h} xc:'#010101' -fill "#020202" -draw "rectangle ${mosaic_start_x},${mosaic_start_y} ${mosaic_end_x},${mosaic_end_y}" ${output_file_seikai}
	#以下はデバッグ用。モザイク部分は分かりやすい色にしている。
	#convert -size ${picture_w}x${picture_h} xc:black -fill "#303030" -draw "rectangle ${mosaic_start_x},${mosaic_start_y} ${mosaic_end_x},${mosaic_end_y}" ${output_file_seikai_for_debug}
	convert -size ${picture_w}x${picture_h} xc:'#010101' -fill "#303030" -draw "rectangle ${mosaic_start_x},${mosaic_start_y} ${mosaic_end_x},${mosaic_end_y}" ${output_file_seikai_for_debug}

	echo "done"
done
