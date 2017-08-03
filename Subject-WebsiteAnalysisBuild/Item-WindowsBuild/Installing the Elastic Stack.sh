# 组件
Component		Version
Beats			5.x
Elasticsearch	5.x
Elasticsearch Hadoop		5.x
Kibana			5.x
Logstash		5.x
X-Pack			5.x

# Installation Order:安装顺序
1.Elasticsearch
2.X-Pack for Elasticsearch
3.Kibana
4.X-Pack for Kibana
5.Logstash
6.Beats
7.Elasticsearch Hadoop

###################################################################################
# install-elasticsearch
# example 安装在windowns上面
# config
Elasticsearch has two configuration files:
elasticsearch.yml for configuring Elasticsearch, and
log4j2.properties for configuring Elasticsearch logging.

默认配置文件位置 $ES_HOME/config/
手工指定配置文件位置:./bin/elasticsearch -Epath.conf=/path/to/my/config/

验证环境变量:
C:\Users\unicom>echo %ES_HOME%
D:\installtools\ELK_ElasticStack\elasticsearch-5.4.3

# config the server
# ----------------------------------- Paths ------------------------------------
# Path to directory where to store the data (separate multiple locations by comma):
path.data: D:\installtools\log\ELK\data
# Path to log files:
path.logs: D:\installtools\log\ELK\log
# ---------------------------------- Network -----------------------------------
# Set the bind address to a specific IP (IPv4 or IPv6):
network.host: 172.28.11.167
# Set a custom port for HTTP:
http.port: 9200

#关于命令行参数,可以代替配置文件
.\bin\elasticsearch.bat -Ecluster.name=my_cluster -Enode.name=node_1


# running
## edite jvm.options
-Xms1g
-Xmx1g

%ES_HOME%\bin\elasticsearch.bat

## checking the elsstic server
http://172.28.11.167:9200/

# Installing Elasticsearch as a Service on Windows
%ES_HOME%\bin\elasticsearch-service.bat
Usage: elasticsearch-service.bat install|remove|start|stop|manager [SERVICE_ID]

##Important Elasticsearch configuration
The path.data settings can be set to multiple paths, in which case all paths will be used to store data (although the files belonging to a single shard will all be stored on the same data path):

path:
  data:
    - /mnt/elasticsearch_1
    - /mnt/elasticsearch_2
    - /mnt/elasticsearch_3

###################################################################################
 # Set up X-Pack
# install X-Pack in Elasticsearch:
%ES_HOME%\bin\elasticsearch-plugin install x-pack
# 启动
%ES_HOME%\bin\elasticsearch.bat
###################################################################################
## set up Kibana
# Install Kibana on Windows

# Kibana Configuration Settings
server.port: 5601
server.host: "172.28.11.167"
elasticsearch.url: "http://172.28.11.167:9200"
elasticsearch.preserveHost: true
kibana.index: ".kibana"
server.ssl.enabled: false
# Enables SSL for outgoing requests from the Kibana server to the browser. When set to true, server.ssl.certificate and server.ssl.key are required

# running
C:\Users\unicom>echo %KIBANA_HOME%
D:\installtools\ELK_ElasticStack\kibana-5.4.3-windows-x86

%KIBANA_HOME%\bin\kibana.bat

# Accessing Kibana
http://172.28.11.167:5601/status#?_g=()
###################################################################################
Kibana Installing Plugins
%KIBANA_HOME%\bin\kibana-plugin install x-pack

logstash Installing Plugins
bin\logstash-plugin install x-pack
###################################################################################
# 默认密码:
 # Log in as the built-in elastic user with the password changeme
###################################################################################
# Logstash Introduction
Logstash is an open source data collection engine with real-time pipelining capabilities.
# Mix, match, and orchestrate different inputs, filters, and outputs to play in pipeline harmony

####获得哪些数据.

Logs and Metrics
Handle all types of logging data

Easily ingest a multitude of web logs like Apache, and application logs like log4j for Java
Capture many other log formats like syslog, Windows event logs, networking and firewall logs, and more

Enjoy complementary secure log forwarding capabilities with Filebeat
Collect metrics from Ganglia, collectd, NetFlow, JMX, and many other infrastructure and application platforms over TCP and UDP

The Webedit
Unlock the World Wide Web.

Transform HTTP requests into events

Consume from web service firehoses like Twitter for social sentiment analysis
Webhook support for GitHub, HipChat, JIRA, and countless other applications
Enables many Watcher alerting use cases
Create events by polling HTTP endpoints on demand

Universally capture health, performance, metrics, and other types of data from web application interfaces
Perfect for scenarios where the control of polling is preferred over receiving

Data Stores and Streamsedit
Discover more value from the data you already own.

Better understand your data from any relational database or NoSQL store with a JDBC interface
Unify diverse data streams from messaging queues like Apache Kafka, RabbitMQ, Amazon SQS, and ZeroMQ

# 处理哪些数据:

Grok is the bread and butter of Logstash filters and is used ubiquitously to derive structure out of unstructured data. Enjoy a wealth of integrated patterns aimed to help quickly resolve web, systems, networking, and other types of event formats.
Expand your horizons by deciphering geo coordinates from IP addresses, normalizing date complexity, simplifying key-value pairs and CSV data, fingerprinting (anonymizing) sensitive information, and further enriching your data with local lookups or Elasticsearch queries.
Codecs are often used to ease the processing of common event structures like JSON and multiline events.
###################################################################################
# Beats input plugin
The default Logstash installation includes the Beats input plugin. 
the Beats input plugin minimizes the resource demands on the Logstash instance.
The Beats input plugin enables Logstash to receive events from the Elastic Beats framework, 
which means that any Beat written to work with the Beats framework, such as Packetbeat and Metricbeat, can also send event data to Logstash.
# configure Logstash to listen on port 5044 for incoming Beats connections and to index into Elasticsearch:
input {
  beats {
    port => 5044
  }
}

output {
  elasticsearch {
    hosts => "172.28.11.167:9200"
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}

output {
 stdout {
   id => "my_plugin_id"
 }
}

###################################################################################
# Getting Started With Filebeat
 The Filebeat client is a lightweight, resource-friendly tool that collects logs from files on the server and forwards these logs to your Logstash instance for processing.
 Filebeat is designed for reliability and low latency. Filebeat has a light resource footprint on the host machine

# windows install--powershell
get-help about_signing
get-help about_Execution_Policies
get-ExecutionPolicy
# Restricted
set-ExecutionPolicy Unrestricted


PS D:\installtools\ELK_ElasticStack\filebeat-5.4.3-windows-x86_64> .\install-service-filebeat.ps1

Status   Name               DisplayName
------   ----               -----------
Stopped  filebeat           filebeat

##Step 2: Configuring Filebeat
filebeat.yml
# Define the path (or paths) to your log files.
filebeat.prospectors:
- input_type: log
  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    # - c:\programdata\elasticsearch\logs\*
    - D:\installtools\log\ELK\data\*.log
    - D:\installtools\log\ELK\data\*\*.log
    - D:\installtools\log\ELK\log\*.log

##输出两种情况:
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["172.28.11.167:9200"]

##情况2:
# If you want to use Logstash to perform additional processing on the data collected by Filebeat, you need to configure Filebeat to use Logstash.
# For this configuration, you must load the index template into Elasticsearch manually because the options for auto loading the template are only available for the Elasticsearch output.
output.logstash:
  # The Logstash hosts
  hosts: ["172.28.11.167:5044"]

.\filebeat -configtest -e

# Step 4: Loading the Index Template in Elasticsearched

In Elasticsearch, index templates are used to define settings and mappings that determine how fields should be analyzed.
The recommended index template file for Filebeat is installed by the Filebeat packages

# Configuring Template Loading
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["172.28.11.167:9200"]
  # template.name: "filebeat"
  # template.path: "filebeat.template.json"
  # template.overwrite: false

# Loading the Template Manually
deb or rpm:
curl -H 'Content-Type: application/json' -XPUT 'http://172.28.11.167:9200/_template/filebeat' -d@/etc/filebeat/filebeat.template.json
win:
# powershell3.0以后
PS Invoke-WebRequest -Method Put -InFile filebeat.template.json -Uri  http://172.28.11.167:9200/_template/filebeat?pretty -ContentType application/json
#安装curl
https://winampplugins.co.uk/curl/
# .\curl -H 'Content-Type: application/json' -U elastic:changeme -T 'http://172.28.11.167:9200/_template/filebeat' -d@'D:\installtools\ELK_ElasticStack\filebeat-5.4.3-windows-x86_64\filebeat.template.json'
.\curl -H 'Content-Type: application/json' -XPUT 'http://172.28.11.167:9200/_template/filebeat' -d@filebeat.template.json -U elastic:changeme 
# 先删除,再导入
.\curl -XDELETE 'http://172.28.11.167:9200/filebeat-*'
http://172.28.11.167:9200/_template/filebeat?pretty

# Step 5: Starting Filebeat
# powershell
Start-Service filebeat

# Step 6: Loading the Kibana Index Pattern
# Import Dashboards and/or the Index Pattern for a Single Beat
./scripts/import_dashboards -dir kibana/metricbeat

.\scripts\import_dashboards -only-index -es "http://172.28.11.167:9200" -user "elastic" -pass "changeme"
.\scripts\import_dashboards -only-dashboards -es "http://172.28.11.167:9200"  -user "elastic" -pass "changeme"


###################################################################################
# At the data source machine, run Filebeat with the following command:

sudo ./filebeat -e -c filebeat.yml -d "publish"
###################################################################################
# Configuring Logstash for Filebeat Input
# vi  first-pipeline.conf

input {
    beats {
        port => "5043"
    }
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
    stdout { codec => rubydebug }
}

netstat -ano | findstr "5044"
netstat -ano | findstr "5043"
# 确认配置

bin/logstash -f first-pipeline.conf --config.test_and_exit

Sending Logstash s logs to D:/installtools/ELK_ElasticStack/logstash-5.4.3/logs which is now configured via log4j2.properties
Configuration OK
[2017-07-05T15:55:47,975][INFO ][logstash.runner          ] Using config.test_and_exit mode. Config Validation Result: OK. Exiting Logstash

# The --config.test_and_exit option parses your configuration file and reports any errors.

# If the configuration file passes the configuration test, start Logstash with the following command:

bin/logstash -f first-pipeline.conf --config.reload.automatic

# The --config.reload.automatic option enables automatic config reloading so that you don’t have to stop and restart Logstash every time you modify the configuration file.
[2017-07-05T15:59:57,752][INFO ][logstash.outputs.elasticsearch] Running health check to see if an Elasticsearch connection is working {:healthcheck_u
rl=>http://logstash_system:xxxxxx@localhost:9200/, :path=>"/"}
[2017-07-05T15:59:59,766][WARN ][logstash.outputs.elasticsearch] Attempted to resurrect connection to dead ES instance, but got an error. {:url=>#<URI
::HTTP:0x72919731 URL:http://logstash_system:xxxxxx@localhost:9200/>, :error_type=>LogStash::Outputs::ElasticSearch::HttpClient::Pool::HostUnreachable
Error, :error=>"Elasticsearch Unreachable: [http://logstash_system:xxxxxx@localhost:9200/][Manticore::SocketException] Connection refused: connect"}
[2017-07-05T15:59:59,781][INFO ][logstash.outputs.elasticsearch] Running health check to see if an Elasticsearch connection is working {:healthcheck_u
rl=>http://logstash_system:xxxxxx@localhost:9200/, :path=>"/"}