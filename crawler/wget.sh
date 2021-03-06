#!/bin/bash
set -e

###
### About
### 引数で指定されたCSVファイルを対象にミラーリングするシェルスクリプト
### CSVのフォーマットは
### 組織名,略称,URL
###
### Usage
### ./wget.sh data/test.csv
###

# 配列の初期化
urls=()
domains=()
# $#は引数の個数
while (( $# > 0 ))
do
	# $1は1つ目の引数
	for line in `cat $1`; do
		# CSVファイルの行の3番めを取り出す
		url=`echo ${line} | cut -d',' -f 3`
		# urls配列に追加
		urls=("${urls} $url")
		# urlからhttp://とhttps://を削る
		domain=${url//http:\/\//}
		domain=${domain//https:\/\//}
		# domains配列に追加
		domains=("${domains} $domain")
	done
	# shiftで次の引数を$1に入れている
	shift
done

cd www-data
# urls配列の中身をwgetに渡している
echo $urls | xargs -n 1 echo | xargs -P 16 -I{} wget -l 2 -r --no-check-certificate {}
echo $domains | xargs -n 1 echo | xargs -I{} cp -f robots.txt {}
cd -

