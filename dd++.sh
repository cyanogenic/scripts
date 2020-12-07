#!/bin/bash

#######################################
# Author : cyan<zhouziqi@css.com.cn>
# Version: 0.1
#######################################
signal()
{
    #TODO:检测多个kill程序,防止乱杀
    while :
    do
        pkill -USR1 ^dd$
        sleep 5
    done
}


TMP=/tmp/dd++.$RANDOM

dd $@ > $TMP 2>&1 &
PID_dd=$!

signal &
PID_signal=$!

while :
do
    if [ `ps -ef | awk '{print $2}' | grep -w $PID_dd` ];then
        tail -n 1 $TMP
    else
        kill $PID_signal
        rm $TMP
        exit 0
    fi
done
