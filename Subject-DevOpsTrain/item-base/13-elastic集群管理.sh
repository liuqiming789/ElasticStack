#13-elastic集群管理
一.Elasticsearch Configuration
了解内部配置,观察发生变化,可控持续稳定

cluster.name: bigdataelk
node.name: etk-1

# master节点
node.master:true
node.data:false

#数据节点
node.master:false
node.data:true
#数据修改只能master

path.data: D:\installtools\log\ELK\data
path.logs: D:\installtools\log\ELK\log

bootstrap.memory_lock: true
#锁定内存,给JVM

network.host: ["172.28.11.167","127.0.0.1"]
http.port: 9200
transport.tcp.port:9300
#发布地址,和通信地址;绑定地址

gateway.recover_after_nodes: 3
#在集群达到几个节点启动之后,才能数据恢复.

discovery.zen.minimum_master_nodes: 2-4
# 具有集群master
discovery.zen.ping.unicast.hosts: ["host1", "host2"]
# 初始化列表

二.集群优化和管理
1.分片和副本的工作方式
(1)索引和删除文档
分片p1,副本r0
user-master-node-告知master-通知客户端user

(2) 更新文档
user-master-node3-更改node3分片-node3更新所有分片的副本-其他node确认副本更新-node3通知客户端更新成功

(3)检索
user-node3-广播其他node-其他node直接查询-返回给node3-返回给客户

2.影响性能的因素

3.软件层面:
(1)索引-分词器,
	-分区器算法(中文,英文),选择合适的分词器,影响索引的大小.
	segment数量,越多,查询越慢

(2)参数
max_num_segment:段数优化,值越小,查询速度越快
only_expunge_deletes:是否清空有删除标签的索引.
wait_for_merge:通常是false,比较耗时.
flush:


4.分片数量
 (1)分片数量多:单个分片不能超过30G;但是会导致交换多.
 (2)冷热分离;冷的数据备份到HDFS中.热数据放elastic.
 	所以可以通过时间戳建索引.
 (3)默认是5个分片.
 (4)旧日志用处不大,放hdfs中

5.副本数量
(1)副本为1就可以.


