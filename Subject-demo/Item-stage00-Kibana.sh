wget https://artifacts.elastic.co/downloads/kibana/kibana-5.4.3-linux-x86_64.tar.gz
sha1sum kibana-5.4.3-linux-x86_64.tar.gz 
tar -xzf kibana-5.4.3-linux-x86_64.tar.gz
cd kibana/

####################################################################################
###/opt/ELK/kibana-5.4.3-linux-x86_64/config
####################################################################################
vi /opt/ELK/kibana-5.4.3-linux-x86_64/config/kibana.yml

# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "192.168.85.148"
# The URL of the Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://192.168.85.148:9200"

#####################################################################################
#安装2.6.7.	安装 Kibana Dashboards
wget http://download.elastic.co/beats/dashboards/beats-dashboards-1.2.2.zip

vi load.sh

# env KIBANA_INDEX='.kibana_env1' ./load.sh
# ./load.sh http://test.com:9200
# ./load.sh http://test.com:9200 test


# The default value of the variable. Initialize your own variables here
ELASTICSEARCH=http://192.168.85.148:9200

load.sh
Loading dashboards to http://192.168.85.148:9200 in .kibana
{"error":{"root_cause":[{"type":"index_already_exists_exception","reason":"index [.kibana/B3PK2L5GTh-C5c_U-fOyaw] already exists","index_uuid":"B3PK2L5GTh-C5c_U-fOyaw","index":".kibana"}],"type":"index_already_exists_exception","reason":"index [.kibana/B3PK2L5GTh-C5c_U-fOyaw] already exists","index_uuid":"B3PK2L5GTh-C5c_U-fOyaw","index":".kibana"},"status":400}{"acknowledged":true}Loading search Cache-transactions:
{"_index":".kibana","_type":"search","_id":"Cache-transactions","_version":1,"result":"created","_shards":{"total":2,"successful":1,"failed":0},"created":true}
Loading search DB-transactions:


[elk@m1 kibana-5.4.3-linux-x86_64]$ bin/kibana
  log   [08:55:40.269] [info][status][plugin:kibana@5.4.3] Status changed from uninitialized to green - Ready
  log   [08:55:40.427] [info][status][plugin:elasticsearch@5.4.3] Status changed from uninitialized to yellow - Waiting for Elasticsea
  log   [08:55:40.487] [info][status][plugin:console@5.4.3] Status changed from uninitialized to green - Ready
  log   [08:55:40.525] [info][status][plugin:metrics@5.4.3] Status changed from uninitialized to green - Ready
  log   [08:55:41.200] [info][status][plugin:timelion@5.4.3] Status changed from uninitialized to green - Ready
  log   [08:55:41.239] [info][listening] Server running at http://192.168.85.148:5601
  log   [08:55:41.241] [info][status][ui settings] Status changed from uninitialized to yellow - Elasticsearch plugin is yellow
  log   [08:55:46.715] [info][status][plugin:elasticsearch@5.4.3] Status changed from yellow to yellow - No existing Kibana index foun
  log   [08:55:49.815] [info][status][plugin:elasticsearch@5.4.3] Status changed from yellow to green - Kibana index ready
  log   [08:55:49.816] [info][status][ui settings] Status changed from yellow to green - Ready


