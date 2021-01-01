#!/bin/bash

#配置变量
LIST=/opt/iptables-foward/port.config
TEMP=/tmp/port.config.$RANDOM
#读配置
grep -v "^[ \t]*\#" ${LIST} | grep -v "^$" > $TEMP

#写入iptables规则
while read line;do
    #读配置
    local_ip=`echo $line | cut -d ' ' -f 1`
    local_port=`echo $line | cut -d ' ' -f 2`
    remote_ip=`echo $line | cut -d ' ' -f 3`
    remote_port=`echo $line | cut -d ' ' -f 4`
    #加规则
    iptables -t nat -A PREROUTING -p tcp --dport $local_port -j DNAT --to-destination $remote_ip:$remote_port
    iptables -t nat -A POSTROUTING -p tcp -d $remote_ip --dport $remote_port -j SNAT --to-source $local_ip
done < $TEMP

echo "写入完成"
rm $TEMP
exit 0
