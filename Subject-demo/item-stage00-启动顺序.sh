## logstash使用rpm安装,不用tar.gz
vi /etc/yum.repos.d/logstash.repo
[logstash-2.2]
name=logstash repository for 2.2 packages
baseurl=http://packages.elasticsearch.org/logstash/2.2/centos
gpgcheck=1
gpgkey=http://packages.elasticsearch.org/GPG-KEY-elasticsearch
enabled=1

yum -y install logstash

vi /etc/logstash/conf.d/02-beats-input.conf

input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate => "/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"
    ssl_key => "/opt/ELK/logstash-5.4.3/private/logstash-forwarder.key"
  }
}


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

service logstash configtest

/*******************************
启动顺序
********************************/

## 启动filebeat
systemctl start filebeat

## 启动logstash
/etc/logstash/conf.d
[root@m1 conf.d]# systemctl restart logstash
[root@m1 conf.d]# ps -ef | grep  logstash

[root@m1 conf.d]# netstat -ano | grep 5044
tcp6       0      0 :::5044                 :::*                    LISTEN      off (0.00/0/0)


## 启动elasticsearch
[root@m1 elasticsearch-5.4.3]# su - elk
Last login: Mon Jul  3 09:55:35 CST 2017 on pts/4
[elk@m1 ~]$ /opt/ELK/elasticsearch-5.4.3/bin/elasticsearch


[o.e.c.s.ClusterService   ] [xNIyjew] new_master {xNIyjew}{xNIyjewASq6A8ZCyFurkQQ}{zQdDt4uVQM6iJPN_AmQAwA}{192.168.85.148}{192.168.85.148:9300}, reason: zen-disco-elected-as-master ([0] nodes joined)
[o.e.h.n.Netty4HttpServerTransport] [xNIyjew] publish_address {192.168.85.148:9200}, bound_addresses {192.168.85.148:9200}
[o.e.n.Node               ] [xNIyjew] started
[o.e.g.GatewayService     ] [xNIyjew] recovered [2] indices into cluster_state

测试
http://192.168.85.148:9200/
{
  "name" : "xNIyjew",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "aJcQKdYKSraY-oq3NSI5vA",
  "version" : {
    "number" : "5.4.3",
    "build_hash" : "eed30a8",
    "build_date" : "2017-06-22T00:34:03.743Z",
    "build_snapshot" : false,
    "lucene_version" : "6.5.1"
  },
  "tagline" : "You Know, for Search"
}
测试
http://192.168.85.148:9200/_search


## 启动kibana
/opt/ELK/kibana-5.4.3-linux-x86_64/bin/kibana

[plugin:kibana@5.4.3] Status changed from uninitialized to green - Ready
[plugin:elasticsearch@5.4.3] Status changed from uninitialized to yellow - Waiting for Elasticsearch
[plugin:console@5.4.3] Status changed from uninitialized to green - Ready
[plugin:metrics@5.4.3] Status changed from uninitialized to green - Ready
[plugin:timelion@5.4.3] Status changed from uninitialized to green - Ready
Server running at http://192.168.85.148:5601
[ui settings] Status changed from uninitialized to yellow - Elasticsearch plugin is yellow
[plugin:elasticsearch@5.4.3] Status changed from yellow to green - Kibana index ready
[ui settings] Status changed from yellow to green - Ready

[root@m1 conf.d]# netstat -ano | grep 5601
tcp        0      0 192.168.85.148:5601     0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 192.168.85.148:55827    192.168.85.148:5601     TIME_WAIT   timewait (0.00/0/0)
tcp        0      0 192.168.85.148:55810    192.168.85.148:5601     TIME_WAIT   timewait (0.00/0/0)

## 启动kibana beats-dashboards
[root@m1 beats-dashboards-1.2.2]# cat /opt/ELK/beats-dashboards-1.2.2/load.sh | grep ELASTICSEARCH
ELASTICSEARCH=http://192.168.85.148:9200

/opt/ELK/beats-dashboards-1.2.2/load.sh

Loading dashboards to http://192.168.85.148:9200 in .kibana
{"error":{"root_cause":[{"type":"index_already_exists_exception","reason":"index [.kibana/B3PK2L5GTh-C5c_U-fOyaw] already exists","index_uuid":"B3PK2L5GTh-C5c_U-fOyaw","index":".kibana"}],"type":"index_already_exists_exception","reason":"index [.kibana/B3PK2L5GTh-C5c_U-fOyaw] already exists","index_uuid":"B3PK2L5GTh-C5c_U-fOyaw","index":".kibana"},"status":400}{"acknowledged":true}Loading search Cache-transactions:
{"_index":".kibana","_type":"search","_id":"Cache-transactions","_version":3,"result":"updated","_shards":{"total":2,"successful":1,"failed":0},"created":false}

Loading search DB-transactions:
Loading search Default-Search:
Loading search Errors:
Loading search Filesystem-stats:
Loading search HTTP-errors:
Loading search MongoDB-errors:
Loading search MongoDB-transactions:
Loading search MongoDB-transactions-with-write-concern-0:
Loading search MySQL-errors:
Loading search MySQL-Transactions:
Loading search Packetbeat-Search:
Loading search PgSQL-errors:
Loading search PgSQL-transactions:
Loading search Processes:
Loading search Proc-stats:
Loading search RPC-transactions:
Loading search System-stats:
Loading search System-wide:
Loading search Thrift-errors:
Loading search Thrift-transactions:
Loading search Web-transactions:
Loading search Winlogbeat-Search:
Loading visualization Average-system-load-across-all-systems:
Loading visualization Cache-transactions:
Loading visualization Client-locations:
Loading visualization CPU-usage:
Loading visualization CPU-usage-per-process:
Loading visualization DB-transactions:
Loading visualization Disk-usage:
Loading visualization Disk-usage-overview:
Loading visualization Disk-utilization-over-time:
Loading visualization Errors-count-over-time:
Loading visualization Errors-vs-successful-transactions:
Loading visualization Event-Levels:
Loading visualization Evolution-of-the-CPU-times-per-process:
Loading visualization HTTP-codes-for-the-top-queries:
Loading visualization HTTP-error-codes-evolution:
Loading visualization HTTP-error-codes:
Loading visualization Latency-histogram:
Loading visualization Levels:
Loading visualization Memory-usage:
Loading visualization Memory-usage-per-process:
Loading visualization MongoDB-commands:
Loading visualization MongoDB-errors:
Loading visualization MongoDB-errors-per-collection:
Loading visualization MongoDB-in-slash-out-throughput:
Loading visualization MongoDB-response-times-and-count:
Loading visualization MongoDB-response-times-by-collection:
Loading visualization Most-frequent-MySQL-queries:
Loading visualization Most-frequent-PgSQL-queries:
Loading visualization MySQL-Errors:
Loading visualization MySQL-Methods:
Loading visualization MySQL-Reads-vs-Writes:
Loading visualization Mysql-response-times-percentiles:
Loading visualization MySQL-throughput:
Loading visualization Navigation:
Loading visualization Number-of-Events:
Loading visualization Number-of-Events-Over-Time-By-Event-Log:
Loading visualization Number-of-MongoDB-transactions-with-writeConcern-w-equal-0:
Loading visualization PgSQL-Errors:
Loading visualization PgSQL-Methods:
Loading visualization PgSQL-Reads-vs-Writes:
Loading visualization PgSQL-response-times-percentiles:
Loading visualization PgSQL-throughput:
Loading visualization Process-status:
Loading visualization Reads-versus-Writes:
Loading visualization Response-times-percentiles:
Loading visualization Response-times-repartition:
Loading visualization RPC-transactions:
Loading visualization Servers:
Loading visualization Slowest-MySQL-queries:
Loading visualization Slowest-PgSQL-queries:
Loading visualization Slowest-Thrift-RPC-methods:
Loading visualization Sources:
Loading visualization System-load:
Loading visualization Thrift-requests-per-minute:
Loading visualization Thrift-response-times-percentiles:
Loading visualization Thrift-RPC-Errors:
Loading visualization Top-10-HTTP-requests:
Loading visualization Top-10-memory-consumers:
Loading visualization Top-10-processes-by-total-CPU-usage:
Loading visualization Top-Event-IDs:
Loading visualization Top-processes:
Loading visualization Top-slowest-MongoDB-queries:
Loading visualization Top-Thrift-RPC-calls-with-errors:
Loading visualization Top-Thrift-RPC-methods:
Loading visualization Total-number-of-HTTP-transactions:
Loading visualization Total-time-spent-in-each-MongoDB-collection:
Loading visualization Web-transactions:
Loading dashboard HTTP:
Loading dashboard MongoDB-performance:
Loading dashboard MySQL-performance:
Loading dashboard Packetbeat-Dashboard:
Loading dashboard PgSQL-performance:
Loading dashboard Thrift-performance:
Loading dashboard Topbeat-Dashboard:
Loading dashboard Winlogbeat-Dashboard:
Loading index pattern filebeat-*:
Loading index pattern packetbeat-*:
Loading index pattern topbeat-*:
Loading index pattern winlogbeat-*:

