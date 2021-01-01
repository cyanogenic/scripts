#!/bin/bash

#检测是否安装iptables
if (command -v iptables > /dev/null 2>&1)
then
    echo "本机已经安装iptables"
else
    echo "本机没有安装iptables"
    exit 1
fi

#检测iptables是否开启

#允许ipv4转发
tmp_sysctl=`sysctl -n net.ipv4.ip_forward`
if [ $tmp_sysctl -ne 1 ]; then
    echo "开启ipv4转发中"
    echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
    sysctl -p
else
    echo "已经开启ipv4转发"
fi

#复制文件
mkdir -p /opt/iptables-foward
cp iptables-foward.sh /opt/iptables-foward
chmod 755 /opt/iptables-foward/iptables-foward.sh
cp port.config /opt/iptables-foward
#启动service
cp ./iptables-foward.service /lib/systemd/system
systemctl daemon-reload && systemctl enable iptables-foward.service && systemctl start iptables-foward.service
