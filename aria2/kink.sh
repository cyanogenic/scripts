#!/bin/bash
  
NEXTCLOUD_FOLDER=/media/data/nextcloud-data/cyan/files
NEXTCLOUD_OCC_FOLDER=/cyan/files

INFO()
{
    echo "FILE_PATH=$FILE_PATH"
    echo "FILE_DIR=$FILE_DIR"
    echo "FILE_SUFFIX=$FILE_SUFFIX"
    echo "ID=$ID"
    echo "TITLE=$TITLE"
    echo "DESCIPTION=$DESCIPTION"
    echo "CATEGORY=$CATEGORY"
    echo "IMAGE=$IMAGE"
}

#解析文件路径
FILE_PATH="`pwd`/$1"
#解析文件所在目录
FILE_DIR=`dirname $FILE_PATH`
#解析文件后缀
FILE_SUFFIX=`echo ${FILE_PATH##*.}`
#番号
ID=`echo ${FILE_PATH##*/} | cut -d '_' -f 1`
#标题
TITLE="`curl -s https://www.kink.com/shoot/$ID | grep \<title\> | cut -d '>' -f 2 | cut -d '<' -f 1`"
#简介
DESCIPTION=
#分类
CATEGORY="`curl -s https://www.kink.com/shoot/$ID | grep "kbar kbar-" | cut -d '-' -f 2 | cut -d ' ' -f 1`"
#套图
IMAGE="`ls $FILE_DIR/*${ID}_*.zip | xargs`"

#测一手
INFO

#开整
if test -z "${TITLE}";then
    echo "未获取到TITLE"            
    exit 2
elif test -z "${CATEGORY}";then
    echo "未获取到CATEGORY"
    exit 2
fi
#建文件夹
sudo -u www-data mkdir -p $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}"
#移动视频
sudo -u www-data mv $FILE_PATH $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}"/"${TITLE}".$FILE_SUFFIX
#是否存在套图
if test -n "${IMAGE}";then
    echo "存在$ID的套图"            
    sudo find $FILE_DIR -name "*$ID*.zip" -print -exec mv {} $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}"/ \;
    cd $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}" && sudo unzip *.zip && sudo rm *.zip
else
    echo "未检测到$ID的套图"
fi
#更新索引
occ files:scan --path="$NEXTCLOUD_OCC_FOLDER/eivi/kink/$CATEGORY"
occ files:scan --path="$NEXTCLOUD_OCC_FOLDER/aria2c"
