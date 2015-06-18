ii=$1
shift
nn=0
for i in $@
do
	tp=$((++nn))
	if [ "$tp" = "$ii" ]; then
		echo "$tp" > /tmp/zookeeper/myid
	fi
	echo "server.$tp=$i:2888:3888" >> /opt/zookeeper/conf/zoo.cfg
done
/opt/zookeeper/bin/zkServer.sh start