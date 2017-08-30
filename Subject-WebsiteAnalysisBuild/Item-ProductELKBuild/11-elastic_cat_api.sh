http://192.168.11.74:9200/_cat

/_cat/allocation
/_cat/shards
/_cat/shards/{index}
/_cat/master
/_cat/nodes
/_cat/indices
/_cat/indices/{index}
/_cat/segments
/_cat/segments/{index}
/_cat/count
/_cat/count/{index}
/_cat/recovery
/_cat/recovery/{index}
/_cat/health
/_cat/pending_tasks
/_cat/aliases
/_cat/aliases/{alias}
/_cat/thread_pool
/_cat/plugins
/_cat/fielddata
/_cat/fielddata/{fields}


# 案例
GET /_cat/nodes?v&h=ip,port,heapPercent,heapMax
curl 'localhost:9200/_cat/indices?bytes=mb' | sort -rnk8


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
## 2017-08-28 索引
#######################################################
