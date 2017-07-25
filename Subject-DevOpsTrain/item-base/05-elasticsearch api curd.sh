一.marvel插件
不是免费的.集head和bigdesk优点.

bin/plugin install file:///path/to/file/license-2.4.4.zip
bin/plugin install file:///path/to/file/marvel-agent-2.4.4.zip
bin/kibana plugin --install marvel --url file:///path/to/file/marvel-2.4.5.tar.gz


marvel.agent.exporters:
  id1:
    type: http
    host: ["http://es-mon-1:9200", "http://es-mon2:9200"]

bin/plugin install license
bin/plugin install marvel-agent
bin/kibana plugin --install elasticsearch/marvel/2.4.5

-> Downloading file:///D:/installtools/ELK_ElasticStack/elasticsearch-5.4.3/marvel-2.4.5.tar.gz
[=================================================] 100%??
ERROR: `elasticsearch` directory is missing in the plugin zip

二.创建文件
1.创建
# --shards为5,复制为1
curl -u "elastic":"changeme" -XPUT "http://127.0.0.1:9200/library/" -d "{""settings"":{""index"":{""number_of_shards"":5,""number_of_replicas"":5}}}"
# {"acknowledged":true,"shards_acknowledged":true}
2.查看设置
http://127.0.0.1:9200/_all/_settings
http://127.0.0.1:9200/library/_settings

3.创建文档
(1)指定id
curl -u "elastic":"changeme" -XPUT "localhost:9200/library/books/1?pretty" -d "{ ""title"": ""easy on perl"", ""price"": ""35.99"", ""publish_date"": ""2016-12-31""}"

(2)不指定id
curl -u "elastic":"changeme" -XPOST "localhost:9200/library/books/?pretty" -d "{ ""title"": ""easy on python"", ""price"": ""37.99"", ""publish_date"": ""2016-12-31""}"

4.获得文档
(1)通过id获得文档
curl -u "elastic":"changeme" -XGET "localhost:9200/library/books/1?pretty" 

(2)通过_source获取指定字段
curl -u "elastic":"changeme" -XGET "localhost:9200/library/books/1?_source=title,price&pretty" 

(3)通过_search?q=查找
curl -u "elastic":"changeme" -XGET "localhost:9200/library/books/_search?q=""python""&pretty" 

4.更新文档-覆盖更新-PUT
curl -u "elastic":"changeme" -XPUT "localhost:9200/library/books/1?pretty" -d "{ ""title"": ""easy on perl"", ""price"": ""355.99"", ""publish_date"": ""2016-12-31""}"

5.推荐通过_update来更新

curl -u "elastic":"changeme" -XPOST "localhost:9200/library/books/1/_update?pretty" -d "{ ""doc"":{ ""price"": ""35.99""}}"
# curl -u "elastic":"changeme" -XGET "localhost:9200/library/books/_search?q=""perl""&pretty"

6.删除

三.内置类型
String,integer/long,float/double,boolean,null,date 

