1 mapping更新流程
node1收到新字段
node1确定mapping,通知master
master分发全集群更新成新的mapping
其他节点按照新mapping处理后来的数据中这个字段

2 mapping更新问题

3.数据类型:
string
number:integer,long,double
date
ipv4
geo_point

4.string类型的分析
4.1 默认分词器lowercase+english,可以自定义stopwords,但是.不在stopwords里,而且也加不上;

