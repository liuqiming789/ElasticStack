(一)
1.based on apache lucene,written in java
2.http rest api 
	curl -X <rest verb> node:port/index/type/in
3.schema-less json doc
(二)
1.near realtime
2.cluter:
3.node:
4.index:
	index name 必须小写
5.type:
	consists of a name and a mapping
6.mapping:
	schema
7.document
	basic unit infomation
8.shards
	an index分成多个片,叫shards分片
	比如一个索引超过一个节点数据能存储的量
	创建索引的时候,可以指定numbers分片
	针对分片分布式和并行处理
9.replicas
	副本是分片的一个备份
	提供高可靠些
	副本和分片在不同的节点上面;
(三)create a index
