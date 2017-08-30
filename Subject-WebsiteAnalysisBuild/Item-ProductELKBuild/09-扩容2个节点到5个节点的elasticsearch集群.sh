
export PATH
export JAVA_HOME=/app/elk/jdk1.8.0_121
export CLASS_PATH=.:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar
export PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin


mkdir -p /app/elk/elastic/elastic_data
mkdir -p /app/elk/elastic/elastic_log

echo "elk  -  nofile  65536">>/etc/security/limits.conf
echo "elk soft memlock unlimited">>/etc/security/limits.conf
echo "elk hard memlock unlimited">>/etc/security/limits.conf
echo "vm.max_map_count=262144">>/etc/sysctl.conf
sysctl -p

[elk@bjxhm-hadoopelk-75 elastic]$ scp -r elasticsearch-5.5.1 192.168.11.76:~/elastic/
[elk@bjxhm-hadoopelk-75 elastic]$ scp -r elasticsearch-5.5.1 192.168.11.77:~/elastic/


2.elasticsearch 配置
(1)
cluster.name: unicompayment-bigdata
(2)
node.name: node-1
node.name: node-2
node.name: node-3
node.name: node-4
node.name: node-5
(3)
path.data: /app/elk/elastic/elastic_data
path.logs: /app/elk/elastic/elastic_log

(4)
network.host: ["192.168.11.73","127.0.0.1"]
network.host: ["192.168.11.74","127.0.0.1"]
network.host: ["192.168.11.75","127.0.0.1"]
network.host: ["192.168.11.76","127.0.0.1"]
network.host: ["192.168.11.77","127.0.0.1"]
http.port: 9200

(5)To avoid a split brain:
discovery.zen.minimum_master_nodes: 3

(6)
discovery.zen.ping.unicast.hosts: ["192.168.11.73:9300", "192.168.11.74:9300","192.168.11.75:9300","192.168.11.76:9300","192.168.11.77:9300"]

(7)
bootstrap.memory_lock: true
