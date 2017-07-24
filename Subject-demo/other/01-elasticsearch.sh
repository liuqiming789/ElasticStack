# 1.IP
172.28.11.167
# 2.kibana地址
http://172.28.11.167:5601/app/kibana
# 3.用户密码
elasticsearch.username: "elastic"
elasticsearch.password: "changeme"
# 4.elasticsearch健康状态
http://172.28.11.167:9200/_cat/health?v
# 5.elasticsearch节点状态
http://172.28.11.167:9200/_cat/nodes?v
# 6.elasticsearch的索引状态
http://172.28.11.167:9200/_cat/indices?v
# 7.elasticsearch支持127.0.0.1 localhost
network.host: ["172.28.11.167","127.0.0.1"]
# 8.elastic创建索引
curl -U 'elastic':'changeme' -XPUT   'localhost:9200/customer?pretty'
	# (1)报错curl: (6) Could not resolve host: 'l27.0.0.1
	# windows喜欢双引号
	curl -u "elastic":"changeme" -XPUT   "localhost:9200/customer?pretty"
 #   {
 #    "error" : {
 #      "root_cause" : [
 #        {
 #          "type" : "security_exception",
 #          "reason" : "missing authentication token for REST request [/customer?pretty]",
 #          "header" : {
 #            "WWW-Authenticate" : "Basic realm=\"security\" charset=\"UTF-8\""
 #          }
 #        }
 #      ],
 #      "type" : "security_exception",
 #      "reason" : "missing authentication token for REST request [/customer?pretty]",
 #      "header" : {
 #        "WWW-Authenticate" : "Basic realm=\"security\" charset=\"UTF-8\""
 #      }
 #    },
  "status" : 401
}
   # (2)用小u,管理员用户
  curl -u "elastic":"changeme" -XPUT   "localhost:9200/customer?pretty"
# {
#   "acknowledged" : true,
#   "shards_acknowledged" : true
# }
	# (2)查看:5个主分片和1份复制（都是默认值），其中包含0个文档。
	health status index     uuid                   	pri rep docs.count  docs.deleted  store.size  pri.store.size
	yellow open   customer  K2W8dIscRLSY7kz6hTeKyw 	  5   1          0             0        650b            650b

# 9.查看webtrends日志
http://localhost:9200/filebeat-2017.07.21?pretty

# 10.在索引中创建类型和文档
	# (1)简单的客户文档索引到customer索引、“external”类型中，这个文档的ID是1
	curl -u "elastic":"changeme" -XPUT "localhost:9200/customer/type01/1?pretty" -d "{ ""name"": ""John Doe""}"
	# {
	#   "_index" : "customer",
	#   "_type" : "type01",
	#   "_id" : "1",
	#   "_version" : 1,
	#   "result" : "created",
	#   "_shards" : {
	#     "total" : 2,
	#     "successful" : 1,
	#     "failed" : 0
	#   },
	#   "created" : true
	# }	
	# (2)查看
	http://localhost:9200/customer/type01/1?pretty
		# {
		#   "_index" : "customer",
		#   "_type" : "type01",
		#   "_id" : "1",
		#   "_version" : 1,
		#   "found" : true,
		#   "_source" : {
		#     "name" : "John Doe"
		#   }
		# }
# 11.删除索引
curl -u "elastic":"changeme" -XDELETE "localhost:9200/customer?pretty"
# 12.访问模式
curl -<REST Verb> <Node>:<Port>/<Index>/<Type>/<ID>?pretty

# 13.没有指定ID创建文档,使用XPOST
curl -u "elastic":"changeme" -XPOST "localhost:9200/customer/type01?pretty" -d "{ ""name"": ""John Doe""}"

# {
#   "_index" : "customer",
#   "_type" : "type01",
#   "_id" : "AV1jOeT5IUiSmK791LYr",
#   "_version" : 1,
#   "result" : "created",
#   "_shards" : {
#     "total" : 2,
#     "successful" : 1,
#     "failed" : 0
#   },
#   "created" : true
# }
查看:http://localhost:9200/customer/type01/AV1jOeT5IUiSmK791LYr?pretty

# 14.update数据
curl -u "elastic":"changeme" -XPOST "http://localhost:9200/customer/type01/AV1jOeT5IUiSmK791LYr/_update?pretty" -d "{ ""doc"":{ ""name"": ""Clark"",""age"":20}}"

# {
#   "_index" : "customer",
#   "_type" : "type01",
#   "_id" : "AV1jOeT5IUiSmK791LYr",
#   "_version" : 2,
#   "result" : "updated",
#   "_shards" : {
#     "total" : 2,
#     "successful" : 1,
#     "failed" : 0
#   }
# }
# 15.select数据
curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/type01/AV1jOeT5IUiSmK791LYr"
# curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/type01/_search?pretty" -d "{ ""query"":{"" match"":{ ""name"": ""Clark""}}"
curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/type01/_search?q=""Clark""&pretty"
# {
#   "took" : 43,
#   "timed_out" : false,
#   "_shards" : {
#     "total" : 5,
#     "successful" : 5,
#     "failed" : 0
#   },
#   "hits" : {
#     "total" : 1,
#     "max_score" : 0.25811607,
#     "hits" : [
#       {
#         "_index" : "customer",
#         "_type" : "type01",
#         "_id" : "AV1jOeT5IUiSmK791LYr",
#         "_score" : 0.25811607,
#         "_source" : {
#           "name" : "Clark",
#           "age" : 20
#         }
#       }
#     ]
#   }
# }

# 16.批量插入-POST _bulk API
curl -u "elastic":"changeme" -XPOST "localhost:9200/customer/type01/_bulk?pretty" -d "{""index"":{""_id"":""1""}}{""name"": ""saber""}{""index"":{""_id"":""2""}}{""name"": ""clark""}"

# {
#   "error" : {
#     "root_cause" : [
#       {
#         "type" : "action_request_validation_exception",
#         "reason" : "Validation Failed: 1: no requests added;"
#       }
#     ],
#     "type" : "action_request_validation_exception",
#     "reason" : "Validation Failed: 1: no requests added;"
#   },
#   "status" : 400
# }

# 17.批量删除更新
curl -u "elastic":"changeme" -XPOST "localhost:9200/customer/type01/_bulk?pretty" -d "{""update"":{""_id"":""1""}}{""doc"":{ ""name"": ""John Doe becomes Jane Doe""}}{""delete"":{""_id"":""2""}}"
# {
#   "error" : {
#     "root_cause" : [
#       {
#         "type" : "action_request_validation_exception",
#         "reason" : "Validation Failed: 1: no requests added;"
#       }
#     ],
#     "type" : "action_request_validation_exception",
#     "reason" : "Validation Failed: 1: no requests added;"
#   },
#   "status" : 400
# }

# 18.查询webtends日志
http://localhost:9200/filebeat-2017.07.21/_search?q=%22WT.act%22&pretty
http://localhost:9200/filebeat-2017.07.21/log/_search?q=%22WT.act%22&pretty

# 19.查看类型下面的所有日志
http://localhost:9200/customer/type01/_search?q=*&pretty

# 20.批量查询2
curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/type01/_search?pretty" -d "{""query"":{ ""match_all"":{}}}"
# {
#   "took" : 0,
#   "timed_out" : false,
#   "_shards" : {
#     "total" : 5,
#     "successful" : 5,
#     "failed" : 0
#   },
#   "hits" : {
#     "total" : 1,
#     "max_score" : 1.0,
#     "hits" : [
#       {
#         "_index" : "customer",
#         "_type" : "type01",
#         "_id" : "AV1jOeT5IUiSmK791LYr",
#         "_score" : 1.0,
#         "_source" : {
#           "name" : "Clark",
#           "age" : 20
#         }
#       }
#     ]
#   }

# 21.排序查询
curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/type01/_search?pretty" -d "{""query"":{ ""match_all"":{}}},""sort"":{""balance"": {""order"": ""desc""}}"
curl -u "elastic":"changeme" -XGET "http://localhost:9200/customer/_search?pretty" -d "{""query"":{ ""match"":{""name"":""Clark""}}},""sort"":{""balance"": {""order"": ""desc""}}"

# 22.多个条件,布尔查询
curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
        {
          "query": {
            "bool": {
              "must": [
                { "match": { "address": "mill" } },
                { "match": { "address": "lane" } }
              ]
            }
          }
        }'
# 22.布尔查询
  curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
        {
          "query": {
            "bool": {
              "must": [
                { "match": { "age": "40" } }
              ],
              "must_not": [
                { "match": { "state": "ID" } }
              ]
            }
          }
        }'

# 23.过滤查询 这个例子使用一个被过滤的查询，其返回值是越在20000到30000之间（闭区间）的账户。换句话说，我们想要找到越大于等于20000并且小于等于30000的账户。
    
        curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
        {
          "query": {
            "filtered": {
              "query": { "match_all": {} },
              "filter": {
                "range": {
                  "balance": {
                    "gte": 20000,
                    "lte": 30000
                  }
                }
              }
            }
          }
        }'

# 24.聚合查询
      curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
        {
          "size": 0,
          "aggs": {
            "group_by_state": {
              "terms": {
                "field": "state"
              }
            }
          }
        }'


    在SQL中，上面的聚合在概念上类似于：
       SELECT COUNT(*) from bank GROUP BY state ORDER BY COUNT(*) DESC

# 25.平均值查询
基于前面的聚合，现在让我们按照平均余额进行排序：
    
        curl -XPOST 'localhost:9200/bank/_search?pretty' -d '
        {
          "size": 0,
          "aggs": {
            "group_by_state": {
              "terms": {
                "field": "state",
                "order": {
                  "average_balance": "desc"
                }
              },
              "aggs": {
                "average_balance": {
                  "avg": {
                    "field": "balance"
                  }
                }
              }
            }
          }
        }'
        
# 23.webtrends聚合查询
curl -u "elastic":"changeme" -XGET "http://localhost:9200/filebeat-2017.07.21/_search?pretty" -d "{""query"":{ ""match"":{""message"":""WT.act=load""}}},""sort"":{""balance"": {""order"": ""desc""}}"
