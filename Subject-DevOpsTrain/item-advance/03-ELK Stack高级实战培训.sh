一.数据映射mapping
1.实时索引原理
(1).Lucene 把每次生成的倒排索引，叫做一个段(segment)。然后另外使用一个 commit 文件，记录索引内所有的 segment。而生成 segment 的数据来源，则是内存中的 buffer。
(2).新收到的数据写到新的索引文件里。
2.准实时查询原理
(1)segment刷新到文件系统缓存
(2)默认1s间隔
(3)主动调用/_refresh接口刷到缓存
(4)refresh_interval设置

2.主要数据类型
(1)string的not analyzed
默认单个term最大长度32KB(32766)
为了保护ES，可以配置ignore_above(非英文按char算，也就是要小于32766/3=10922，因为JSON固定是UTF8格式，一个char占用3B)
        "message": {
          "type": "string",
          "index": "not_analyzed",
          "ignore_above": 20 
        }

(2)date format
自定义方式:
{"mappings":{"type1":{"properties":{"timefield":{"type":"date","format":"yyyy-MM-dd HH:mm:ss"}}}}}

(3)nested和array的区别
ES会平铺array里的字段。
{"user":[{"first":"john","last":"smith"},               {"first":"alice","last":"white"}]}
存储成：
{"user.first":["john","alice"] "user.last":["smith","white"]}
当你想搜john smitch的时候，alice white也命中

3.attachment
需要安装mapper-attachments插件 可以将PPT、XLS、PDF、HTML等各类文档，以base64格式存入

4.动态mapping
默认有_default_的动态mapping。
      "dynamic_templates": [
        {
          "named_analyzers": {
            "match_mapping_type": "string",
            "match": "*", 或者 "path_match":"field.subfield.*",
            "mapping": {
              "type": "string",
              "analyzer": "{name}"
            }
          }
        }
      }


5._type之间的mapping
{
  "field1":
  "type":"object",
  "enabled":false,
  "index":"no"
}
注意：必须写成object，因为string是只有index没有enabled参数的

6.
ES有一系列meta fields在每个document里：
_index, _type, _id, _version是基础内容；
_source, _all, _field_names是数据内容；
_timestamp, _ttl, _size是辅助功能内容；
_meta是用户自定义内容。


7.
_source的作用在store，_all的作用在index
Lucene中，每个field是需要设置store才能获取原文的；
ES中，单独使用_source存原文，各field默认"store":false
_all是为了响应不指明field的全文检索请求。
在script中，可以使用_source.field和doc['field']来获取内容，分别从_source store和inverted index里拿数据。


8.
merge默认最大segment为5GB
optimize有单独的一个线程运行
2.0后改名叫/_forcemerge接口
max_num_segments=1


9.
indices.store.throttle.max_bytes_per_sec默认20MB
index.merge.scheduler.max_thread_count默认3个
Policy策略(tiered，2.0以后唯一选择)
index.merge.policy.floor_segment:2MB
index.merge.policy.max_merge_at_once:10
index.merge.policy.max_merged_segment:5GB
index.merge.policy.segments_per_tier:10


10.
热：当前正在写入的索引
温：当前无写入，但是还在读取的索引
冷：当前无读写，随时可以恢复的索引(/_close接口)

N 台机器做热数据的存储。这 N 台热数据节点的 elasticsearc.yml 中配置
node.tag: hot
 M 台机器做温数据的存储。这 M 台温数据节点中配置
node.tag: stale

index template新增设置：
{
 "order" : 0,
 "template" : "*",
 "settings" : {
   "index.routing.allocation.require.tag" : "hot"
 }
}

每天0点，对前一天索引发请求：
curl -XPUT http://127.0.0.1:9200/logstash-yyyy.mm.dd/_settings -d'
{
  "index": {
    "routing.allocation.require.tag": "stale"
  }
}'






