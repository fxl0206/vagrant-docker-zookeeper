FROM docker.io/centos

MAINTAINER fxl0206@gmail.com

USER root

#初始化zookeeper环境
RUN yum -y install passwd expect net-tools java ssh-keygen tar wget&& wget -q -O - http://mirrors.cnnic.cn/apache/zookeeper/zookeeper-3.3.6/zookeeper-3.3.6.tar.gz | tar -xzf - -C /opt && mv /opt/zookeeper-3.3.6 /opt/zookeeper && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg && mkdir -p /opt/zookeeper/data && mkdir -p /opt/zookeeper/log && mkdir -p /tmp/zookeeper

#RUN echo "server.1=$HOST1:2888:3888" >> /opt/zookeeper/conf/zoo.cfg && echo "server.2=$HOST2:2888:3888" >> /opt/zookeeper/conf/zoo.cfg && echo "server.3=$HOST3:2888:3888" >> /opt/zookeeper/conf/zoo.cfg && mkdir -p /tmp/zookeeper && echo $SERVERID > /tmp/zookeeper/myid

#添加初始化脚本到镜像
ADD include/init.sh /init.sh
ADD include/start.sh /start.sh
RUN /init.sh

#设定登陆初始目录
WORKDIR /opt/zookeeper

#映射docker到host
VOLUME ["/opt/zookeeper/conf", "/opt/zookeeper/data", "/opt/zookeeper/log"]

#安装sshd
RUN yum install -y openssh-server sudo  
   
# 添加测试用户admin，密码admin，并且将此用户添加到sudoers里  
RUN useradd admin  
RUN echo "admin:admin" | chpasswd  
RUN echo "admin   ALL=(ALL)       ALL" >> /etc/sudoers  
   
# 下面这两句比较特殊，在centos6上必须要有，否则创建出来的容器sshd不能登录  
RUN ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key  
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key  

# 启动sshd服务并且暴露22端口  
RUN mkdir /var/run/sshd  
#EXPOSE 22
  
#ENTRYPOINT ["/bin/sh","-c","'/start.sh'"]

#CMD ["/bin/sh","-c","'/start.sh'"]
CMD ["/usr/sbin/sshd", "-D"]
