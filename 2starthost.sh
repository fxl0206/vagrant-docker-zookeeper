#!/usr/bin/bash
NAT_IP=$1
LAN_IP=$2
NAME=$3
echo $NAT_IP $LAN_IP $NAME

docker run -d --name=$NAME -p $NAT_IP:22:22 -p $NAT_IP:2181:2181 zk:2

PID=`docker inspect --format="{{ .State.Pid }}" $NAME`

#如果netns目录不存在则新建
if [ ! -d /var/run/netns ]; then
	echo "新建目录 /var/run/netns"
	mkdir -p /var/run/netns/
fi

#进程网络命名空间不存在文件，新建软连接
if [ ! -f /var/run/netns/$PID ]; then
	echo "新建软连接 /var/run/netns/$PID"
	ln -s /proc/$PID/ns/net /var/run/netns/$PID
fi

#设置制定IP地址
ip netns exec $PID ip addr add $LAN_IP/24 dev eth0

#查看设置结果
ip netns exec $PID ip addr

