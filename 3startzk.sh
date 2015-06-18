#!/usr/bin/expect -f
 set ip [lindex $argv 0 ]
 set myid [lindex $argv 1 ]
 set password vagrant
 set timeout 10  
 spawn ssh root@$ip  
 expect {  
 "*yes/no" { send "yes\r"; exp_continue}  
 "*password:" { send "$password\r" }  
 }  
 expect "#*"  
 send "/start.sh $myid 172.17.42.11 172.17.42.12 172.17.42.13\r"  
 send  "exit\r"  
 expect eof  