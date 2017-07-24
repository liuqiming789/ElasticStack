############################
###client server:
############################
app server:filebeat
db  server:filebeat

-----------------数据传递(etc/filebeat/filebeat.yml)
-----------------input(
	filebeat:
  # List of prospectors to fetch data.
  prospectors:
    # Each - is a prospector. Below are the prospector specific configurations
    -
      # Paths that should be crawled and fetched. Glob based paths.
      # To fetch all ".log" files from a specific level of subdirectories
      # /var/log/*/*.log can be used.
      # For each file found under this path, a harvester is started.
      # Make sure not file is defined twice as this can lead to unexpected behaviour.
      paths:
        - /var/log/*.log
      )

-------------- output:分支1  logstash    
-------------  ### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: ["192.168.85.148:5044"]
    # Optional TLS. By default is off.
    tls:
      # List of root certificates for HTTPS server verifications
      certificate_authorities: ["/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"]



--------------output: 分支1  elasticSearch
----------- ### Elasticsearch as output
  elasticsearch:
    # Array of hosts to connect to.
    # Scheme and port can be left out and will be set to the default (http and 9200)
    # In case you specify and additional path, the scheme is required: http://localhost:9200/path
    # IPv6 addresses should always be defined as: https://[2001:db8::1]:9200
    hosts: ["192.168.85.148:9200"])


----------分支2 查询接口:  http://192.168.85.148:9200/filebeat-*/_search?pretty


################################################
## ELK  stack logstash server
## 启动,监听端口:5044
################################################

## logstash server 
bin/logstash -e 'input { stdin { } } output { stdout {} }'

## 启动队列,uuid,pipleline管道,等待输入,

Creating directory {:setting=>"path.queue", :path=>"/opt/ELK/logstash-5.4.3/data/queue"}
No persistent UUID file found. Generating new UUID {:uuid=>"b1483f41-810a-497b-ac8b-b569f0a4bf4c", :path=>"/opt/ELK/logstash-5.4.3/data/uuid"}
Starting pipeline {"id"=>"main", "pipeline.workers"=>1, "pipeline.batch.size"=>125, "pipeline.batch.delay"=>5, "pipeline.max_inflight"=>125}

The stdin plugin is now waiting for input:
[logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600}

##### 输入
vi /etc/logstash/conf.d/02-beats-input.conf

input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate => "/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"
    ssl_key => "/opt/ELK/logstash-5.4.3/private/logstash-forwarder.key"
  }
}

#### 过滤器

vi /etc/logstash/conf.d/10-syslog-filter.conf

filter {
  if [type] == "syslog" {
    grok {
      match => { "message" => "%{SYSLOGTIMESTAMP:syslog_timestamp} %{SYSLOGHOST:syslog_hostname} %{DATA:syslog_program}(?:\[%{POSINT:syslog_pid}\])?: %{GREEDYDATA:syslog_message}" }
      add_field => [ "received_at", "%{@timestamp}" ]
      add_field => [ "received_from", "%{host}" ]
    }
    syslog_pri { }
    date {
      match => [ "syslog_timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }
}

#### 输出
vi /etc/logstash/conf.d/30-elasticsearch-output.conf

output {
  elasticsearch {
    hosts => ["192.168.85.148:9200"]
    sniffing => true
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}

################################################
## ELK elasticsearch  server
## 启动,HTTP request to port 9200
################################################
vi /opt/ELK/elasticsearch-5.4.3/config/elasticsearch.yml
# ---------------------------------- Network -----------------------------------
#
# Set the bind address to a specific IP (IPv4 or IPv6):
#
#network.host: 192.168.85.148
#
# Set a custom port for HTTP:
#
#http.port: 9200
#
# For more information, consult the network module documentation.

new_master {xNIyjew}{xNIyjewASq6A8ZCyFurkQQ}{zQdDt4uVQM6iJPN_AmQAwA}{192.168.85.148}{192.168.85.148:9300}
publish_address {192.168.85.148:9200}
cluster health status changed from [RED] to [YELLOW] (reason: [shards started [[filebeat-2017.06.30][0], [.kibana][0]] ...])

################################################
## ELK kibana server
## http查询监听:5601
## elasticsearch.url实例查询端口: "http://192.168.85.148:9200"
################################################
vi /opt/ELK/kibana-5.4.3-linux-x86_64/config/kibana.yml
# Specifies the address to which the Kibana server will bind. IP addresses and host names are both valid values.
# The default is 'localhost', which usually means remote machines will not be able to connect.
# To allow connections from remote users, set this parameter to a non-loopback address.
server.host: "192.168.85.148"
# The URL of the Elasticsearch instance to use for all your queries.
elasticsearch.url: "http://192.168.85.148:9200"

####################
# 启动
####################
bin/kibana
[plugin:kibana@5.4.3] Status changed from uninitialized to green - Ready
[plugin:elasticsearch@5.4.3] Status changed from uninitialized to yellow - Waiting for Elasticsea
[plugin:console@5.4.3] Status changed from uninitialized to green - Ready
[plugin:metrics@5.4.3] Status changed from uninitialized to green - Ready
[plugin:timelion@5.4.3] Status changed from uninitialized to green - Ready
[listening] Server running at http://192.168.85.148:5601
[status][ui settings] Status changed from uninitialized to yellow - Elasticsearch plugin is yellow
[status][plugin:elasticsearch@5.4.3] Status changed from yellow to yellow - No existing Kibana index foun
[status][plugin:elasticsearch@5.4.3] Status changed from yellow to green - Kibana index ready
[status][ui settings] Status changed from yellow to green - Ready
####################
# nginx
# nginx反向代理到kibana所在服务器http://192.168.85.148:5601
# http://192.168.85.148反向代理到http://192.168.85.148/app/kibana
#http://192.168.85.148:5601 代理到http://192.168.85.148:5601/app/kibana
####################
vi /etc/nginx/conf.d/kibana.conf文件
server {
    listen 80;

    server_name 192.168.85.148;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://192.168.85.148:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;        
    }
}

####################
# Kibana Dashboards
####################
vi load.sh
# The default value of the variable. Initialize your own variables here
ELASTICSEARCH=http://192.168.85.148:9200

load.sh
Loading dashboards to http://192.168.85.148:9200 in .kibana
Loading search DB-transactions:
Loading search Default-Search:
Loading search Errors:

Loading visualization Average-system-load-across-all-systems:
Loading visualization Client-locations:
Loading visualization CPU-usage:

Loading dashboard HTTP:
Loading dashboard MongoDB-performance:
Loading dashboard MySQL-performance:

Loading index pattern filebeat-*:
Loading index pattern packetbeat-*:
Loading index pattern topbeat-*:
Loading index pattern winlogbeat-*: