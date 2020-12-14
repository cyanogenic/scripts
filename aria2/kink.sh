#!/bin/bash

NEXTCLOUD_FOLDER=/media/data/nextcloud-data/cyan/files
NEXTCLOUD_OCC_FOLDER=/cyan/files

TEST()
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
CATEGORY="`curl -s https://www.kink.com/shoot/101664 | grep data-sitename | cut -d '"' -f 6`"
#套图
IMAGE="${ID}_images.zip"

#测一手
TEST


#开整
sudo -u www-data mkdir -p $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}"
sudo -u www-data mv $FILE_PATH $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}"/"${TITLE}".$FILE_SUFFIX
#是否存在套图
if [[ `ls $FILE_DIR/$IMAGE > /dev/null 2>&1 && echo $?` -eq 0 ]];then
    sudo mv $FILE_DIR/$IMAGE $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}" && cd $NEXTCLOUD_FOLDER/eivi/kink/$CATEGORY/$ID-"${TITLE}" && sudo -u www-data unzip $IMAGE && sudo rm $IMAGE
else
    echo "未检测到$ID的套图"
fi
occ files:scan --path="$NEXTCLOUD_OCC_FOLDER/eivi/kink/$CATEGORY"
