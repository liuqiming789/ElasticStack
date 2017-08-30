# 01 集群状态

http://192.168.11.74:9200/_cluster/state?pretty
http://192.168.11.74:9200/_cluster/health?pretty
http://192.168.11.74:9200/_stats?pretty


# 02 节点

http://192.168.11.74:9200/_cat/nodes?v
http://192.168.11.74:9200/_nodes?pretty
GET _nodes/stats


# 03 索引状态
http://192.168.11.74:9200/_all?pretty
http://192.168.11.74:9200/_cat/indices?v
GET my_index,another_index/_stats
GET _all/_stats
http://192.168.11.74:9200/_all/_stats?pretty

# 04 健康状态:
http://192.168.11.73:9200/_cat/health?v
http://192.168.11.74:9200/_cluster/health?pretty&level=indices
GET _cluster/health
GET _cluster/health?level=indices
GET _cluster/health?level=shards
GET _cluster/health?wait_for_status=green

# 05 
 http://192.168.11.73:9200/_cluster/pending_tasks
#######################################################
# 20170823-删除索引
curl -XGET "http://192.168.11.73:9200/_cat/indices?v"

curl -XGET 'http://192.168.11.73:9200/file-2017.08.15'
curl -XDELETE 'http://192.168.11.73:9200/file-2017.08.15'

curl -XGET 'http://192.168.11.73:9200/full-2017.08.15'
curl -XDELETE 'http://192.168.11.73:9200/full-2017.08.15'

curl -XGET 'http://192.168.11.73:9200/test-2017.08.15'
curl -XDELETE 'http://192.168.11.73:9200/test-2017.08.15'

curl -XGET 'http://192.168.11.73:9200/*-2017.08.23?pretty'
curl -XDELETE 'http://192.168.11.73:9200/*-2017.08.23?pretty'

curl -XGET 'http://192.168.11.73:9200/*metadata*?pretty'
curl -XDELETE 'http://192.168.11.73:9200/*metadata*?pretty'

curl -XGET 'http://192.168.11.73:9200/logstash-2017.08.08?pretty'
curl -XDELETE 'http://192.168.11.73:9200/*metadata*?pretty'
#######################################################
# 20170823-日志还原
http://192.168.11.74:9200/logstash-2017.08.03/_recovery?human
http://192.168.11.74:9200/logstash-2017.08.03/_recovery?human&pretty
http://192.168.11.74:9200/logstash-2017.08.03/_stats?pretty
http://192.168.11.74:9200/logstash-2017.08.03/_shard_stores?pretty
http://192.168.11.74:9200/logstash-2017.08.03/_shard_stores?status=green&pretty


http://192.168.11.74:9200/logstash-2017.08.04/_recovery?human&pretty

http://192.168.11.74:9200/logstash-2017.08.03/_shard_stores?status=red&pretty
#######################################################
## 2017-08-28 容量查询
#######################################################
http://192.168.11.74:9200/_cat/allocation?help
shards       | s              | number of shards on node      
disk.indices | di,diskIndices | disk used by ES indices       
disk.used    | du,diskUsed    | disk used (total, not just ES)
disk.avail   | da,diskAvail   | disk available                
disk.total   | dt,diskTotal   | total capacity of all volumes 
disk.percent | dp,diskPercent | percent disk used             
host         | h              | host of node                  
ip           |                | ip of node                    
node         | n              | name of node   

http://192.168.11.74:9200/_cat/allocation

42 51.1gb 58.5gb 16.8gb 75.3gb 77 192.168.11.75 192.168.11.75 node-3
44 51.3gb 58.8gb 16.5gb 75.3gb 78 192.168.11.73 192.168.11.73 node-1
25 23.3gb 28.5gb 46.8gb 75.3gb 37 192.168.11.77 192.168.11.77 node-5
26 20.9gb 25.9gb 49.4gb 75.3gb 34 192.168.11.76 192.168.11.76 node-4
39 52.5gb 57.6gb 17.6gb 75.3gb 76 192.168.11.74 192.168.11.74 node-2

#######################################################
## 2017-08-28 索引查询
#######################################################
http://192.168.11.74:9200/_cat/shards?help
http://192.168.11.74:9200/_cat/shards?v&h=index,shard,state,docs,store,ip,unassigned.reason,unassigned.details
logstash-2017.08.04 4     UNASSIGNED                                ALLOCATION_FAILED failed to create shard, failure IOException[No space left on device]
logstash-2017.08.04 4     UNASSIGNED                                INDEX_CREATED     
logstash-2017.08.04 3     UNASSIGNED                                ALLOCATION_FAILED failed to create shard, failure IOException[No space left on device]
logstash-2017.08.04 3     UNASSIGNED                                INDEX_CREATED 
logstash-2017.08.03 3     UNASSIGNED                                ALLOCATION_FAILED failed to create shard, failure IOException[No space left on device]
logstash-2017.08.03 3     UNASSIGNED                                ALLOCATION_FAILED shard failure, reason [refresh failed], failure IOException[No space left on device]
# 删除索引
curl -XDELETE 'http://192.168.11.73:9200/logstash-2017.08.04'
curl -XDELETE 'http://192.168.11.73:9200/logstash-2017.08.03'
