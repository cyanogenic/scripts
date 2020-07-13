#!/bin/bash

#获取Tracker
tracker_list=`curl https://trackerslist.com/all_aria2.txt`
tracker="bt-tracker=$tracker_list"
# 更新aria2c.conf
sed -i '/^bt-tracker=/c'$tracker'' /etc/aria2c/aria2c.conf
#重启aria2
systemctl reload aria2c
