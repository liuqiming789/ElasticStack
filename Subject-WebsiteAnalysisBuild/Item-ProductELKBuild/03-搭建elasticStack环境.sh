一.准备
1.分发安装包
scp ~/* 192.168.11.74:~/
scp ~/* 192.168.11.75:~/
scp ~/* 192.168.11.76:~/
scp ~/* 192.168.11.77:~/
2.jdk
java version "1.7.0_99"
OpenJDK Runtime Environment (rhel-2.6.5.1.el6-x86_64 u99-b00)
OpenJDK 64-Bit Server VM (build 24.95-b01, mixed mode)



二.elastic分布式安装
mkdir elastic
tar -zxvf elasticsearch-5.5.1.tar.gz -C elastic

1.jvm.option:
(1)JVM heap size:
-Xms2g
-Xmx2g
(2)内存回收
## GC configuration
-XX:+UseConcMarkSweepGC
-XX:CMSInitiatingOccupancyFraction=75
-XX:+UseCMSInitiatingOccupancyOnly


2.elasticsearch 配置
(1)
cluster.name: unicompayment-bigdata
(2)
node.name: node-1
node.name: node-2
node.name: node-3
(3)
path.data: /app/elk/elastic/elastic_data
path.logs: /app/elk/elastic/elastic_log

(4)
network.host: ["192.168.11.73","127.0.0.1"]
network.host: ["192.168.11.74","127.0.0.1"]
network.host: ["192.168.11.75","127.0.0.1"]
http.port: 9200
http.port: 9201
http.port: 9202

(5)To avoid a split brain:
discovery.zen.minimum_master_nodes: 2

(6)
discovery.zen.ping.unicast.hosts: ["192.168.11.73:9200", "192.168.11.74:9201","192.168.11.75:9202"]

(7)
# master节点
node.master: true
node.data: false

#数据节点
node.master: false
node.data: true

(8)
bootstrap.memory_lock: true

3.传配置
scp -r elastic 192.168.11.75:~
scp -r elastic 192.168.11.77:~

4.修改data node
node.name
network.host
http.port
node.master
node.data

6.报错1
[2017-08-09T15:33:15,765][WARN ][o.e.b.JNANatives         ] unable to install syscall filter: 
java.lang.UnsupportedOperationException: seccomp unavailable: CONFIG_SECCOMP not compiled into kernel, CONFIG_SECCOMP and CONFIG_SECCOMP_FILTER are needed
	at org.elasticsearch.bootstrap.SystemCallFilter.linuxImpl(SystemCallFilter.java:363) ~[elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.SystemCallFilter.init(SystemCallFilter.java:638) ~[elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.JNANatives.tryInstallSystemCallFilter(JNANatives.java:245) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Natives.tryInstallSystemCallFilter(Natives.java:113) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Bootstrap.initializeNatives(Bootstrap.java:111) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Bootstrap.setup(Bootstrap.java:194) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Bootstrap.init(Bootstrap.java:351) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:123) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:114) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:67) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:122) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.cli.Command.main(Command.java:88) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:91) [elasticsearch-5.5.1.jar:5.5.1]
	at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:84) [elasticsearch-5.5.1.jar:5.5.1]

ERROR: [2] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
[2]: system call filters failed to install; check the logs and fix your configuration or disable system call filters at your own risk

7.修改配置:
bootstrap.system_call_filter: false

8.报错2
[node-1] not enough master nodes discovered during pinging (found [[Candidate{node={node-1}{BxHQfpeBRPq4CLOk61bOIQ}{yhnp_Y1ISHWn4fo2rXzZKw}{192.168.11.73}{192.168.11.73:9300}, clusterStateVersion=-1}]], but needed [2]), pinging again

修改:
discovery.zen.minimum_master_nodes: 1
############################################################################################
discovery.zen.ping.unicast.hosts: ["192.168.11.73:9300", "192.168.11.74:9300","192.168.11.75:9300"]
#node.master: true
#node.data: false
#discovery.zen.minimum_master_nodes: 1

new_master {node-1}{BxHQfpeBRPq4CLOk61bOIQ}{RakD8NegQtKgDyrKvFq4mQ}{192.168.11.73}{192.168.11.73:9300}, reason: zen-disco-elected-as-master ([0] nodes joined)
[node-1] value for setting "discovery.zen.minimum_master_nodes" is too low. This can result in data loss! Please set it to at least a quorum of master-eligible nodes (current value: [-1], total number of master-eligible nodes used for publishing in this round: [2])


{
  "cluster_name" : "unicompayment-bigdata",
  "version" : 4,
  "state_uuid" : "Q0WZkXTtQu64dTUfpiV4oQ",
  "master_node" : "BxHQfpeBRPq4CLOk61bOIQ",
  "blocks" : { },
  "nodes" : {
    "BxHQfpeBRPq4CLOk61bOIQ" : {
      "name" : "node-1",
      "ephemeral_id" : "RakD8NegQtKgDyrKvFq4mQ",
      "transport_address" : "192.168.11.73:9300",
      "attributes" : { }
    },
    "G2fgu5ySTKOgYn6UvmOCjg" : {
      "name" : "node-3",
      "ephemeral_id" : "1qqEKc_9STeX8zhjFNPaHQ",
      "transport_address" : "192.168.11.75:9300",
      "attributes" : { }
    },
    "szWSHt-DSYWKi7_uLTgXNQ" : {
      "name" : "node-2",
      "ephemeral_id" : "WHYMAdr6SG2D_QojQ8iaCA",
      "transport_address" : "192.168.11.74:9300",
      "attributes" : { }
    }
  }
}
####################################################################
discovery.zen.ping.unicast.hosts: ["192.168.11.73:9300", "192.168.11.74:9300","192.168.11.75:9300"]
discovery.zen.minimum_master_nodes: 1
node.master: true
node.data: false
默认:
# Master-eligible node
# A node that has node.master set to true (default), which makes it eligible to be elected as the master node, which controls the cluster.
# Data node
# A node that has node.data set to true (default). Data nodes hold data and perform data related operations such as CRUD, search, and aggregations.
# Ingest node
# A node that has node.ingest set to true (default). Ingest nodes are able to apply an ingest pipeline to a document in order to transform and enrich the document before indexing. With a heavy ingest load, it makes sense to use dedicated ingest nodes and to mark the master and data nodes as node.ingest: false.
# Tribe node
# A tribe node, configured via the tribe.* settings, is a special type of coordinating only node that can connect to multiple clusters and perform search and other operations across all connected clusters.
####################################################################
discovery.zen.minimum_master_nodes: 2
#node.master: false
#node.data: true
discovery.zen.ping.unicast.hosts: ["192.168.11.73:9300", "192.168.11.74:9300","192.168.11.75:9300"]
