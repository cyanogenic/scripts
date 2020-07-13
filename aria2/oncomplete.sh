#!/bin/bash

#截取扫描路径
occ_scandir="/`echo $3 | cut -d '/' -f 5-8`"

#判断下载任务是否为种子
if [ "$2" -gt "1" ]; then
	#删掉不兼容BitComet导致出现的文件，暂无其它有效的解决方法
	find $aria2_path | grep "_____padding_file_" | xargs -n1 rm -f
fi
#扫描下载完成的文件到Nextcloud
/usr/local/bin/occ files:scan --path=$occ_scandir
