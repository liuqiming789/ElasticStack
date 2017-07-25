01-elasticsearch

一.特点
1.分布式(高可用,有备份),可扩展(添加节点很简单),实时的数据和实时的分析(延迟1秒)
2.restful Web API

二.概念
1.节点:平等关系,去中心化
2.集群:
3.index索引:拥有相似特征的文档的集合.
4.type类型:一个索引中可以定义多种类型.
5.document文档: 一个可以被索引的信息单元json对象;
6.field列: json对象的一个元素.数据的某一列.
7.shards分片:elastic将索引分成若干份.提高IO吞吐量.shards在索引创建的时候指定,默认五分.
8.repicas复制:索引的一份或者多份拷贝

注:非关系型数据库
index类似数据库.
type类似表
document类似row

三.架构:
1.gateway:
(1)filesystem
(2)hdfs
2.lucene框架
3.index模块,搜索模块,mapping,river(从外部获取异构数据,rabbitmq等)
4.自动发现模块(zen-广播机制寻找节点,ec2),脚本模块(js,python,mvel),3rd plugins(中文分词)
5.传输模块(thfrit,http-默认,memcached)
6.restful style API, java(netty)

四.相似工具:
solr	
elastic
splunk
marklogic

五.solr
solr:支持文本,pdf,work
ELK:只支持json

