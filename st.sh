ip1=172.17.42.11
ip2=172.17.42.12
ip3=172.17.42.13
ifconfig enp0s8:11 20.26.1.11/24 up
ifconfig enp0s8:12 20.26.1.12/24 up
ifconfig enp0s8:13 20.26.1.13/24 up
./rmallhost.sh
./2starthost.sh 20.26.1.11 $ip1 zk1
./2starthost.sh 20.26.1.12 $ip2 zk2
./2starthost.sh 20.26.1.13 $ip3 zk3
./3startzk.sh 20.26.1.11 1
./3startzk.sh 20.26.1.12 2
./3startzk.sh 20.26.1.13 3