以前に以下でOpenCVなどを駆使して力技でモザイク検知をしたが、今度は機械学習でやってみる。
* https://qiita.com/summer4an/items/306acc5d38169f880ba8
* https://github.com/summer4an/mosaic_detector

semantic segmentationを使った。
semantic segmentationについては以下等参照。
* http://postd.cc/semantic-segmentation-deep-learning-review/
* https://www.slideshare.net/takmin/semantic-segmentation

以下のコードを拝借。
* https://github.com/tkuanlun350/Tensorflow-SegNet

画像データはターゲットのモザイクを含むpngファイルと、
モザイクの位置を示す答えのpngファイルが必要。

答えのpngはsemantic segmentationでは一般的(？)な形式で、
ラベルなしの背景部分(色は#000000)と、
ラベル部分(ラベルの順に#010101、#020202…)に塗り分けられたもの。

今回の場合、モザイクでない部分は#000000で、モザイク部分だけ
#010101で塗って学習させてみたが、うまく判別できず(単にiterationが
少なかっただけかも)。
背景もモザイク部分もそれぞれ別のラベル付けした箇所として扱うよう、
背景は#010101、モザイク部分は#020202で塗ったところうまくいった。

精度は完全とは言えないがまあまあか。

