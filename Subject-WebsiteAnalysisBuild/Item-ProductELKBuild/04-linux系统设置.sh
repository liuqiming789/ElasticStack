echo "elk  -  nofile  65536">>/etc/security/limits.conf
sysctl -w vm.max_map_count=262144

一.jdk
[elk@bjxhm-hadoopelk-73 ~]$ tail .bash_profile 
# User specific environment and startup programs

PATH=$PATH:$HOME/bin

export PATH
export JAVA_HOME=/app/elk/jdk1.8.0_121
export CLASS_PATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin


[elk@bjxhm-hadoopelk-73 ~]$ tail .bashrc
# User specific aliases and functions
PATH=$PATH:$HOME/bin

export PATH
export JAVA_HOME=/app/elk/jdk1.8.0_121
export CLASS_PATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin

[elk@bjxhm-hadoopelk-73 ~]$ rpm -qa | grep jdk
java-1.7.0-openjdk-devel-1.7.0.99-2.6.5.1.el6.x86_64
java-1.6.0-openjdk-1.6.0.38-1.13.10.4.el6.x86_64
java-1.7.0-openjdk-1.7.0.99-2.6.5.1.el6.x86_64

[elk@bjxhm-hadoopelk-73 ~]$ java -version
java version "1.7.0_99"
OpenJDK Runtime Environment (rhel-2.6.5.1.el6-x86_64 u99-b00)
OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)
[elk@bjxhm-hadoopelk-73 ~]$ echo $JAVA_HOME
/app/elk/jdk1.8.0_121
############################################################
[root@bjxhm-hadoopelk-73 ~]# tail /etc/profile
HISTSIZE=50
HISTFILESIZE=50
TMOUT=1200i
export JAVA_HOME=/app/elk/jdk1.8.0_121
export CLASS_PATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin

yum erase java-1.7.0-openjdk
  Erasing    : ant-1.7.1-15.el6.x86_64
  Erasing    : 1:java-1.7.0-openjdk-1.7.0.99-2.6.5.1.el6.x86_64
  Erasing    : 1:java-1.7.0-openjdk-devel-1.7.0.99-2.6.5.1.el6.x86_64 


############################################################
[2017-08-09T15:26:55,614][WARN ][o.e.b.JNANatives         ] Unable to lock JVM Memory: error=12, reason=Cannot allocate memory
[2017-08-09T15:26:55,615][WARN ][o.e.b.JNANatives         ] This can result in part of the JVM being swapped out.
[2017-08-09T15:26:55,616][WARN ][o.e.b.JNANatives         ] Increase RLIMIT_MEMLOCK, soft limit: 65536, hard limit: 65536
[2017-08-09T15:26:55,616][WARN ][o.e.b.JNANatives         ] These can be adjusted by modifying /etc/security/limits.conf, for example: 
	# allow user 'elk' mlockall
	elk soft memlock unlimited
	elk hard memlock unlimited

echo "elk soft memlock unlimited">>/etc/security/limits.conf
echo "elk hard memlock unlimited">>/etc/security/limits.conf

#############################################################
ERROR: [2] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
[2]: system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk

echo "vm.max_map_count=262144">>/etc/sysctl.conf
sysctl -p
############################################################
ERROR: [1] bootstrap checks failed
[1]: system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk

[2017-08-09T15:40:03,138][WARN ][o.e.b.JNANatives         ] unable to install syscall filter: 
java.lang.UnsupportedOperationException: seccomp unavailable: CONFIG_SECCOMP not compiled into kernel, CONFIG_SECCOMP and CONFIG_SECCOMP_FILTER are needed

############################################################
This is another of those bootstrap checks that enforces something in version 5 that was previously optional.
Two ways around this:

Use the image on a Linux kernel/distribution that has CONFIG_SECCOMP* compiled in the kernel.
Accept the risk of not doing this by setting bootstrap.system_call_filter to false in elasticsearch.yml 
(see https://www.elastic.co/guide/en/elasticsearch/reference/master/_system_call_filter_check.html).



echo "elk  -  nofile  65536">>/etc/security/limits.conf
echo "elk soft memlock unlimited">>/etc/security/limits.conf
echo "elk hard memlock unlimited">>/etc/security/limits.conf
echo "vm.max_map_count=262144">>/etc/sysctl.conf
sysctl -p
# sysctl -w vm.max_map_count=262144
export JAVA_HOME=/app/elk/jdk1.8.0_121
export CLASS_PATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
yum erase java-1.7.0-openjdk -y