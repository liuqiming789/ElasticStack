# 06-elasticsearch mget获取多个文档
一.准备
# _mget
1. 查看索引
http://172.28.11.167:9200/_cat/indices?v
# filebeat-2017.07.21
# http://172.28.11.167:9200/filebeat-2017.07.21/log

2. 获得所有记录
curl -u "elastic":"changeme" -XGET "http://localhost:9200/filebeat-2017.07.21/log/_search?pretty" -d "{""query"":{ ""match_all"":{}}}"


一.mget
# "reason" : "unknown key [doc] for a START_ARRAY, expected [docs] or [ids]"
#docs不是doc
curl -u "elastic":"changeme" -XGET "localhost:9200/filebeat-2017.07.21/_mget?pretty"  -d "{ ""docs"":[{  ""_index"": ""filebeat-2017.07.21"",""_type"": ""log"",""_id"":""AV1i1gLK9TidAeTwo8O7""}, {   ""_index"": ""filebeat-2017.07.21"",""_type"": ""log"",""_id"":""AV1i1gLK9TidAeTwo8O0""}]}"

二.bulk批量操作
1.为了实现多个文档的create,index,update或delete

2.请求体格式
{action:{metadata}}\n
{request body} \n

(1)action:create,index,update,delete
(2)
{"delete":{"_index":"libray","_type":"books"}}
(3)换行识别请求
因此不能美化展示
处理快速

3.批量操作

curl -u "elastic":"changeme" -XPOST "localhost:9200/library/books/_bulk?pretty" -d "{""index"":{""_id"":3}}\r\n{ ""title"": ""easy on java"", ""price"": ""355.99"", ""publish_date"": ""2016-12-31""}\r\n"
# "reason" : "Validation Failed: 1: no requests added;"


 
