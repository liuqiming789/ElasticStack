wget https://artifacts.elastic.co/downloads/logstash/logstash-5.4.3.tar.gz
######################################################################
rpm --import https://artifacts.elastic.co/GPG-KEY-elasticsearch

logstash.repo
[logstash-5.x]
name=Elastic repository for 5.x packages
baseurl=https://artifacts.elastic.co/packages/5.x/yum
gpgcheck=1
gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
enabled=1
autorefresh=1
type=rpm-md
######################################################################

Stashing Your First Event

cd logstash-5.4.3
bin/logstash -e 'input { stdin { } } output { stdout {} }'


[elk@m1 logstash-5.4.3]$ bin/logstash -e 'input { stdin { } } output { stdout {} }'
OpenJDK 64-Bit Server VM warning: If the number of processors is expected to increase from one, then you should configure the number of parallel GC threads appropriately using -XX:ParallelGCThreads=N
Sending Logstash has logs to /opt/ELK/logstash-5.4.3/logs which is now configured via log4j2.properties
[2017-06-30T17:21:58,434][INFO ][logstash.setting.writabledirectory] Creating directory {:setting=>"path.queue", :path=>"/opt/ELK/logstash-5.4.3/data/queue"}
[2017-06-30T17:21:58,750][INFO ][logstash.agent           ] No persistent UUID file found. Generating new UUID {:uuid=>"b1483f41-810a-497b-ac8b-b569f0a4bf4c", :path=>"/opt/ELK/logstash-5.4.3/data/uuid"}
[2017-06-30T17:21:59,351][INFO ][logstash.pipeline        ] Starting pipeline {"id"=>"main", "pipeline.workers"=>1, "pipeline.batch.size"=>125, "pipeline.batch.delay"=>5, "pipeline.max_inflight"=>125}
[2017-06-30T17:22:25,089][INFO ][logstash.pipeline        ] Pipeline main started
The stdin plugin is now waiting for input:
[2017-06-30T17:22:25,376][INFO ][logstash.agent           ] Successfully started Logstash API endpoint {:port=>9600}


After starting Logstash, wait until you see "Pipeline main started" and then enter hello world at the command prompt:

hello world
2017-06-30T09:25:14.156Z 0.0.0.0 hello world

#####################################################################
##生成ssl证书
vi /etc/pki/tls/openssl.cnf
##根据IP
openssl req -config /etc/pki/tls/openssl.cnf -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt

Generating a 2048 bit RSA private key
writing new private key to 'private/logstash-forwarder.key'

#####################################################################
#beats input
chmod a+w config/
touch config/02-beats-input.conf
vi config/02-beats-input.conf

input {
  beats {
    port => 5044
    ssl => true
    ssl_certificate => "/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"
    ssl_key => "/opt/ELK/logstash-5.4.3/private/logstash-forwarder.key"
  }
}
#######################################################################
##syslog Filter
vi config/10-syslog-filter.conf

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
#####################################################################
##output
vi config/30-elasticsearch-output.conf

output {
  elasticsearch {
    hosts => ["192.168.85.148:9200"]
    sniffing => true
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}

#####################################################################



启动5044服务


[root@m1 logstash-5.4.3]# cat patterns/ngix
NGUSERNAME [a-zA-Z\.\@\-\+_%]+
NGUSER %{NGUSERNAME}
NGINXACCESS %{IPORHOST:clientip} %{NGUSER:ident} %{NGUSER:auth} \[%{HTTPDATE:timestamp}\] "%{WORD:verb} %{URIPATHPARAM:request} HTTP/%{NUMBER:httpversion}" %{NUMBER:response} (?:%{NUMBER:bytes}|-) (?:"(?:%{URI:referrer}|-)"|%{QS:referrer}) %{QS:agent}



# 2.9.1.2.	Logstash Filter: Nginx


