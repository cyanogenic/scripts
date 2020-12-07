#!/bin/bash

#######################################
# Author : cyan<zhouziqi@css.com.cn>
# Version: 0.3
#######################################

MODE=
LIST=
CMD=
SRC=
DES=
ERR_MSG="xssh: try 'xssh --help' for more information"

usage()
{
    #TBD
    echo ""
    echo "Usage"
    echo "  xssh [mode] <list> [options]"
    echo ""
    echo "Options:"
    echo "  -m, --mode    选择模式(ssh或rsync)"
    echo "  -l, --list    指定IP列表"
    echo ""
    echo "  --cmd         指定ssh模式下要批量执行的命令"
    echo "  --src         指定rsync模式下要传输的源文件路径(绝对路径)"
    echo "  --des         指定rsync模式下要传输的文件的目标路径(绝对路径)"
    echo ""
    echo "  e.g.  xssh -m ssh -l server.list --cmd \"ls -al /root\""
    echo "  e.g.  xssh -m rsync -l server.list --src=/root/1.txt --des=/root/1.txt"
}

ARGS=$(getopt -o 'hl:m:' --long 'mode:,list:,cmd:,src:,des:,help' -n 'xssh' -- "$@")
#取参数列表出错
if [ $? != 0 ]; then
    echo $ERR_MSG
    exit 1
fi

eval set -- "$ARGS"
unset ARGS
 
while true
do
    case "$1" in
        '-m'|'--mode')
            MODE=$2
            shift 2
            continue
            ;;
        '-l'|'--list')
            LIST=$2
            shift 2
            continue
            ;;
        '--cmd')
            CMD=$2
            break
            ;;
        '--src')
            SRC=$2
            shift 2
            continue
            ;;
        '--des')
            DES=$2
            shift 2
            continue
            ;;
        '-h'|'--help')
            usage
            exit 2
            ;;
        '--')
            shift
            break
            ;;
        *)
            #参数不对
            echo $ERR_MSG
            exit 3
            ;;
    esac
done

#检查IP列表
if [ "`file -b $LIST 2>&1;echo $?`" != "0" ];then
    echo "请使用-l或--list参数指定一个IP列表"
    exit 4
fi
if [ "`file -b $LIST 2>&1`" != "ASCII text" ];then
    echo "无效的IP列表"
    exit 5
fi
#判断模式
case $MODE in
"ssh")
    while read host;do
    ip=`echo $host`
    echo "开始在$ip上执行命令$CMD..."
    ssh -n $ip $CMD
    done < $LIST
    ;;

"rsync")
    while read host;do
    ip=`echo $host`
    echo "开始向$ip传输文件..."
    rsync -av $SRC $ip:$DES
done < $LIST
    ;;

*)
    echo $ERR_MSG
    exit 6
    ;;
esac
