### elaticsearch
[2017-07-05T16:46:13,713][WARN ][o.e.x.s.a.AuthenticationService] [Qw63PiB] An error occurred while attempting to authenticate [kibana] against realm
[reserved] - ElasticsearchSecurityException[failed to authenticate user [kibana]]
[2017-07-05T16:46:13,713][WARN ][o.e.x.s.a.AuthenticationService] [Qw63PiB] An error occurred while attempting to authenticate [kibana] against realm
[reserved] - ElasticsearchSecurityException[failed to authenticate user [kibana]]

### 处理:
elasticsearch.url: "http://172.28.11.167:9200"
elasticsearch.username: "elastic"
elasticsearch.password: "changeme"


[2017-07-05T17:53:45,683][WARN ][o.e.x.s.a.AuthenticationService] [Qw63PiB] An error occurred while attempting to authenticate [elastic] against realm
 [reserved] - ElasticsearchSecurityException[failed to authenticate user [elastic]]


#### Logstash server
[2017-07-05T17:37:19,163][ERROR][logstash.inputs.metrics  ] Failed to create monitoring event {:message=>"For path: events", :error=>"LogStash::Instru
ment::MetricStore::MetricNotFound"}
[2017-07-05T17:37:19,687][INFO ][logstash.outputs.elasticsearch] Running health check to see if an Elasticsearch connection is working {:healthcheck_u
rl=>http://logstash_system:xxxxxx@localhost:9200/, :path=>"/"}
[2017-07-05T17:37:21,407][INFO ][logstash.outputs.elasticsearch] Running health check to see if an Elasticsearch connection is working {:healthcheck_u
rl=>http://logstash_system:xxxxxx@localhost:9200/, :path=>"/"}
[2017-07-05T17:37:21,703][WARN ][logstash.outputs.elasticsearch] Attempted to resurrect connection to dead ES instance, but got an error. {:url=>#<URI
::HTTP:0x16b3616 URL:http://logstash_system:xxxxxx@localhost:9200/>, :error_type=>LogStash::Outputs::ElasticSearch::HttpClient::Pool::HostUnreachableE
rror, :error=>"Elasticsearch Unreachable: [http://logstash_system:xxxxxx@localhost:9200/][Manticore::SocketException] Connection refused: connect"}

### 处理
配置logstash.conf
output {
  elasticsearch {
    hosts => ["172.28.11.167:9200"]
    user => "elastic"
    password => "changeme"
....


[2017-07-05T18:11:48,324][INFO ][logstash.outputs.elasticsearch] Running health check to see if an Elasticsearch connection is working {:healthcheck_u
rl=>http://logstash_system:xxxxxx@localhost:9200/, :path=>"/"}
[2017-07-05T18:02:06,084][WARN ][logstash.outputs.elasticsearch] Attempted to resurrect connection to dead ES instance, but got an error. {:url=>#<URI
::HTTP:0x620f6993 URL:http://logstash_system:xxxxxx@localhost:9200/>, :error_type=>LogStash::Outputs::ElasticSearch::HttpClient::Pool::HostUnreachable
Error, :error=>"Elasticsearch Unreachable: [http://logstash_system:xxxxxx@localhost:9200/][Manticore::SocketException] Connection refused: connect"}



修改filebeat

output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["172.28.11.167:9200"]
  # Optional protocol and basic auth credentials.
  #protocol: "https"
  username: "elastic"
  password: "changeme"

#----------------------------- Logstash output --------------------------------
# output.logstash:
#   # The Logstash hosts
#   hosts: ["172.28.11.167:5044"]




