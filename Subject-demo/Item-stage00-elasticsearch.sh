systemctl stop firewalld
systemctl mask firewalld
yum install iptables-services
systemctl stop iptables
service iptables save
###############################################

https://www.elastic.co/guide/en/elasticsearch/reference/current/install-elasticsearch.html

cd /opt
mkdir ELK

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.tar.gz
sha1sum elasticsearch-5.4.3.tar.gz 
tar -xzf elasticsearch-5.4.3.tar.gz
cd elasticsearch-5.4.3/ 

wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.4.3.zip
sha1sum elasticsearch-5.4.3.zip 
unzip elasticsearch-5.4.3.zip
cd elasticsearch-5.4.3/

Elasticsearch can be started from the command line as follows:

./bin/elasticsearch

Checking that Elasticsearch is runningedit
You can test that your Elasticsearch node is running by sending an HTTP request to port 9200 on localhost:

GET /

Running as a daemonedit
To run Elasticsearch as a daemon, specify -d on the command line, and record the process ID in a file using the -p option:

./bin/elasticsearch -d -p pid

To shut down Elasticsearch, kill the process ID recorded in the pid file:

kill `cat pid`

###############################################
yum install java-1.7.0-openjdk
yum install java-1.8.0-openjdk
yum install java-1.8.0-openjdk-devel
###############################################
##运行报错
###############################################
bin/elasticsearch
#OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
#OpenJDK 64-Bit Server VM warning: INFO: os::commit_memory(0x0000000085330000, 2060255232, 0) failed; error='Cannot allocate memory' (errno=12)
#
# There is insufficient memory for the Java Runtime Environment to continue.
# Native memory allocation (mmap) failed to map 2060255232 bytes for committing reserved memory.
# An error report file with more information is saved as:
# /opt/ELK/elasticsearch-5.4.3/hs_err_pid92044.log
cat /opt/ELK/elasticsearch-5.4.3/hs_err_pid92044.log
# There is insufficient memory for the Java Runtime Environment to continue.
# Native memory allocation (mmap) failed to map 2060255232 bytes for committing reserved memory.

#   Use 64 bit Java on a 64 bit OS
#   Decrease Java heap size (-Xmx/-Xms)
#   Decrease number of Java threads
#   Decrease Java thread stack sizes (-Xss)
#   Set larger code cache with -XX:ReservedCodeCacheSize=

VM内存增加到2G

#############################################
#elastic GET started
##############################################

 ./bin/elasticsearch -d -p pid
#OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N

 /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.131-3.b12.el7_3.x86_64//bin/java 
 -Xms2g -Xmx2g -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=75 -XX:+UseCMSInitiatingOccupancyOnly -XX:+DisableExplicitGC -XX:+AlwaysPreTouch 
 -server -Xss1m -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djna.nosys=true -Djdk.io.permissionsUseCanonicalPath=true -Dio.netty.noUnsafe=true 
 -Dio.netty.noKeySetOptimization=true -Dio.netty.recycler.maxCapacityPerThread=0 -Dlog4j.shutdownHookEnabled=false -Dlog4j2.disable.jmx=true 
 -Dlog4j.skipJansi=true -XX:+HeapDumpOnOutOfMemoryError -Des.path.home=/opt/ELK/elasticsearch-5.4.3 
 -cp /opt/ELK/elasticsearch-5.4.3/lib/* org.elasticsearch.bootstrap.Elasticsearch -d -p pid

##############################################
#导入elasticsearch公钥
rpm --import http://packages.elastic.co/GPG-KEY-elasticsearch

#2.3.2.	创建elasticsearch.repo
cat /etc/yum.repos.d/elasticsearch.repo
[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=http://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1

yum -y install elasticsearch
##############################################
##修改elasticsearch配置（修改主机ip）
##############################################
vi /opt/ELK/elasticsearch-5.4.3/config/elasticsearch.yml
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
#network.host: 192.168.85.148
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.
##############################################
##修改启动jvm配置
##############################################
vi /opt/ELK/elasticsearch-5.4.3/config/jvm.options

# Xms represents the initial size of total heap space
# Xmx represents the maximum size of total heap space
-Xms1g
-Xmx1g

################################################
##访问can not run elasticsearch as root
[elk@m1 elasticsearch-5.4.3]$ bin/elasticsearch
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
[2017-06-30T15:54:46,185][INFO ][o.e.n.Node               ] [] initializing ...
[2017-06-30T15:54:46,354][INFO ][o.e.e.NodeEnvironment    ] [xNIyjew] using [1] data paths, mounts [[/ (rootfs)]], net usable_space [9.3gb], net total_space [18.5gb], spins? [unknown], types [rootfs]
[2017-06-30T15:54:46,354][INFO ][o.e.e.NodeEnvironment    ] [xNIyjew] heap size [1015.6mb], compressed ordinary object pointers [true]
[2017-06-30T15:54:46,356][INFO ][o.e.n.Node               ] node name [xNIyjew] derived from node ID [xNIyjewASq6A8ZCyFurkQQ]; set [node.name] to override
[2017-06-30T15:54:46,357][INFO ][o.e.n.Node               ] version[5.4.3], pid[4701], build[eed30a8/2017-06-22T00:34:03.743Z], OS[Linux/3.10.0-123.el7.x86_64/amd64], JVM[Oracle Corporation/OpenJDK 64-Bit Server VM/1.8.0_131/25.131-b12]
[2017-06-30T15:54:46,357][INFO ][o.e.n.Node               ] JVM arguments [-Xms1g, -Xmx1g, -XX:+UseConcMarkSweepGC, -XX:CMSInitiatingOccupancyFraction=75, -XX:+UseCMSInitiatingOccupancyOnly, -XX:+DisableExplicitGC, -XX:+AlwaysPreTouch, -Xss1m, -Djava.awt.headless=true, -Dfile.encoding=UTF-8, -Djna.nosys=true, -Djdk.io.permissionsUseCanonicalPath=true, -Dio.netty.noUnsafe=true, -Dio.netty.noKeySetOptimization=true, -Dio.netty.recycler.maxCapacityPerThread=0, -Dlog4j.shutdownHookEnabled=false, -Dlog4j2.disable.jmx=true, -Dlog4j.skipJansi=true, -XX:+HeapDumpOnOutOfMemoryError, -Des.path.home=/opt/ELK/elasticsearch-5.4.3]
[2017-06-30T15:54:49,406][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [aggs-matrix-stats]
[2017-06-30T15:54:49,406][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [ingest-common]
[2017-06-30T15:54:49,406][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-expression]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-groovy]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-mustache]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-painless]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [percolator]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [reindex]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [transport-netty3]
[2017-06-30T15:54:49,407][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [transport-netty4]
[2017-06-30T15:54:49,408][INFO ][o.e.p.PluginsService     ] [xNIyjew] no plugins loaded
[2017-06-30T15:54:53,197][INFO ][o.e.d.DiscoveryModule    ] [xNIyjew] using discovery type [zen]
[2017-06-30T15:54:54,419][INFO ][o.e.n.Node               ] initialized
[2017-06-30T15:54:54,419][INFO ][o.e.n.Node               ] [xNIyjew] starting ...
[2017-06-30T15:55:15,111][INFO ][o.e.t.TransportService   ] [xNIyjew] publish_address {127.0.0.1:9300}, bound_addresses {[::1]:9300}, {127.0.0.1:9300}
[2017-06-30T15:55:15,118][WARN ][o.e.b.BootstrapChecks    ] [xNIyjew] max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
[2017-06-30T15:55:15,118][WARN ][o.e.b.BootstrapChecks    ] [xNIyjew] max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
[2017-06-30T15:55:18,345][INFO ][o.e.c.s.ClusterService   ] [xNIyjew] new_master {xNIyjew}{xNIyjewASq6A8ZCyFurkQQ}{TPvNEHnlSvid1kftmnqtug}{127.0.0.1}{127.0.0.1:9300}, reason: zen-disco-elected-as-master ([0] nodes joined)
[2017-06-30T15:55:18,484][INFO ][o.e.g.GatewayService     ] [xNIyjew] recovered [0] indices into cluster_state
[2017-06-30T15:55:18,499][INFO ][o.e.h.n.Netty4HttpServerTransport] [xNIyjew] publish_address {127.0.0.1:9200}, bound_addresses {[::1]:9200}, {127.0.0.1:9200}
[2017-06-30T15:55:18,501][INFO ][o.e.n.Node               ] [xNIyjew] started


http://127.0.0.1:9200

{
  "name" : "xNIyjew",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "aJcQKdYKSraY-oq3NSI5vA",
  "version" : {
    "number" : "5.4.3",
    "build_hash" : "eed30a8",
    "build_date" : "2017-06-22T00:34:03.743Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.1"
  },
  "tagline" : "You Know, for Search"
}
##############################################

w
tty
write root pts/0
ctrl + c end && send
EOF
#############################################
systemctl daemon-reload
systemctl stop firewalld
systemctl stop iptables
#############################################
[root@m1 yum.repos.d]# netstat -anp | grep 9200
tcp6       0      0 127.0.0.1:9200          :::*                    LISTEN      4701/java           
tcp6       0      0 ::1:9200                :::*                    LISTEN      4701/java  
############################################
[2017-06-30T16:13:52,530][INFO ][o.e.t.TransportService   ] [xNIyjew] publish_address {192.168.85.148:9300}, bound_addresses {192.168.85.148:9300}
[2017-06-30T16:13:52,536][INFO ][o.e.b.BootstrapChecks    ] [xNIyjew] bound or publishing to a non-loopback or non-link-local address, enforcing bootstrap checks
ERROR: [2] bootstrap checks failed
[1]: max file descriptors [4096] for elasticsearch process is too low, increase to at least [65536]
[2]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]

########################################
vi /usr/lib/sysctl.d/00-system.conf
vm.max_map_count = 262144
sysctl -p /usr/lib/sysctl.d/00-system.conf
sysctl -a | grep vm.max_map_count
vm.max_map_count = 262144

vi /etc/security/limits.conf 
* soft nofile 65536
* hard nofile 131072
#########################################
{
  "name" : "xNIyjew",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "aJcQKdYKSraY-oq3NSI5vA",
  "version" : {
    "number" : "5.4.3",
    "build_hash" : "eed30a8",
    "build_date" : "2017-06-22T00:34:03.743Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.1"
  },
  "tagline" : "You Know, for Search"
}


[2017-06-30T16:34:17,187][INFO ][o.e.n.Node               ] JVM arguments [-Xms1g, -Xmx1g, -XX:+UseConcMarkSweepGC, -XX:CMSInitiatingOitGC, -XX:+AlwaysPreTouch, -Xss1m, -Djava.awt.headless=true, -Dfile.encoding=UTF-8, -Djna.nosys=true, -Djdk.io.permissionsUseCanonical-Dio.netty.recycler.maxCapacityPerThread=0, -Dlog4j.shutdownHookEnabled=false, -Dlog4j2.disable.jmx=true, -Dlog4j.skipJansi=true, -XX:
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [aggs-matrix-stats]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [ingest-common]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-expression]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-groovy]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-mustache]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [lang-painless]
[2017-06-30T16:34:18,616][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [percolator]
[2017-06-30T16:34:18,617][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [reindex]
[2017-06-30T16:34:18,617][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [transport-netty3]
[2017-06-30T16:34:18,617][INFO ][o.e.p.PluginsService     ] [xNIyjew] loaded module [transport-netty4]
[2017-06-30T16:34:18,617][INFO ][o.e.p.PluginsService     ] [xNIyjew] no plugins loaded
[2017-06-30T16:34:21,437][INFO ][o.e.d.DiscoveryModule    ] [xNIyjew] using discovery type [zen]
[2017-06-30T16:34:22,369][INFO ][o.e.n.Node               ] initialized
[2017-06-30T16:34:22,369][INFO ][o.e.n.Node               ] [xNIyjew] starting ...
[2017-06-30T16:34:42,853][INFO ][o.e.t.TransportService   ] [xNIyjew] publish_address {192.168.85.148:9300}, bound_addresses {192.168.
[2017-06-30T16:34:42,859][INFO ][o.e.b.BootstrapChecks    ] [xNIyjew] bound or publishing to a non-loopback or non-link-local address,
[2017-06-30T16:34:46,123][INFO ][o.e.c.s.ClusterService   ] [xNIyjew] new_master {xNIyjew}{xNIyjewASq6A8ZCyFurkQQ}{6E2FZjnuRR-5dk5M3gkter ([0] nodes joined)
[2017-06-30T16:34:46,245][INFO ][o.e.h.n.Netty4HttpServerTransport] [xNIyjew] publish_address {192.168.85.148:9200}, bound_addresses {
[2017-06-30T16:34:46,254][INFO ][o.e.n.Node               ] [xNIyjew] started
[2017-06-30T16:34:46,259][INFO ][o.e.g.GatewayService     ] [xNIyjew] recovered [0] indices into cluster_state
[2017-06-30T16:55:47,797][INFO ][o.e.c.m.MetaDataCreateIndexService] [xNIyjew] [.kibana] creating index, cause [api], templates [], sh
[2017-06-30T17:51:35,797][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] create_mapping [search]
[2017-06-30T17:51:35,972][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] update_mapping [search]
[2017-06-30T17:51:37,016][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] create_mapping [visualizat
[2017-06-30T17:51:37,163][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] update_mapping [visualizat
[2017-06-30T17:51:39,953][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] create_mapping [dashboard]
[2017-06-30T17:51:40,212][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] update_mapping [dashboard]
[2017-06-30T17:51:40,372][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] create_mapping [index-patt
[2017-06-30T17:51:40,592][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [.kibana/B3PK2L5GTh-C5c_U-fOyaw] update_mapping [index-patt
[2017-06-30T18:16:00,734][INFO ][o.e.c.m.MetaDataCreateIndexService] [xNIyjew] [filebeat-2017.06.30] creating index, cause [auto(bulk 
[2017-06-30T18:16:00,989][INFO ][o.e.c.m.MetaDataMappingService] [xNIyjew] [filebeat-2017.06.30/zPslDPYBTtKQcwXUZC4rsg] create_mapping


/****************************
# 插件
*****************************/
bin/elasticsearch-plugin -h

安装插件

[root@m1 elasticsearch-5.4.3]# bin/elasticsearch-plugin install mobz/elasticsearch-head

