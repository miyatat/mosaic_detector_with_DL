#!/bin/bash


#学習スクリプト。
#引数無しで実行すれば、filelist_train.txtやfilelist_valを使って学習してくれる。


start_date=`date +%Y%m%d_%H%M%S`
logdir="./logs_${start_date}_gakusyuu"
mkdir "${logdir}"


function mainfunc()
{
	#coreファイルが馬鹿でかいので制限。
	ulimit -c 1000

	date

	time python -u main.py --log_dir="${logdir}" --train_image_list=filelist_train.txt --val_image_list=filelist_val.txt

	date
}


mainfunc 2>&1 | perl -pe '$|=1;@x=localtime();$x=sprintf("[%02d/%02d/%02d %02d:%02d:%02d] ",$x[5]+1900,$x[4]+1,$x[3],$x[2],$x[1],$x[0]); s/^/$x/;' | tee "${logdir}/log_gakusyuu_${start_date}.txt"
