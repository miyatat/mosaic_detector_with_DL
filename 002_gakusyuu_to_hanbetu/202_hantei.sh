#!/bin/bash


#判定スクリプト。
#引数無しで実行すれば、filelist_test.txt内のファイルを判定し、
#ターゲットと同じディレクトリに「*_hanteikekka.png」として保存してくれる。


start_date=`date +%Y%m%d_%H%M%S`
logdir="./logs_${start_date}_hantei"
mkdir "${logdir}"


function mainfunc()
{
	#coreファイルが馬鹿でかいので制限。
	ulimit -c 1000

	date

	\rm gomi_motodata/*hanteikekka*

	time python -u main.py --log_dir="${logdir}" --ckpt_for_test=model.ckpt --test_image_list=filelist_test.txt --batch_size=5 --save_image=True

	date
}


mainfunc 2>&1 | perl -pe '$|=1;@x=localtime();$x=sprintf("[%02d/%02d/%02d %02d:%02d:%02d] ",$x[5]+1900,$x[4]+1,$x[3],$x[2],$x[1],$x[0]); s/^/$x/;' | tee "${logdir}/log_hantei_${start_date}.txt"
