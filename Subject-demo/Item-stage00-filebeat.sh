
wget https://download.elastic.co/beats/filebeat/filebeat-1.2.3-x86_64.rpm

https://www.elastic.co/guide/en/beats/filebeat/1.2/filebeat-configuration.html

rpm -ivh /opt/ELK/filebeat-1.2.3-x86_64.rpm 

vi /etc/filebeat/filebeat.yml

#################################
2.7.4.1.1.	使用elasticsearch作为输出

############################# Filebeat ######################################
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

############################# Output ##########################################

# Configure what outputs to use when sending the data collected by the beat.
# Multiple outputs may be used.
output:

  ### Elasticsearch as output
  elasticsearch:
    # Array of hosts to connect to.
    # Scheme and port can be left out and will be set to the default (http and 9200)
    # In case you specify and additional path, the scheme is required: http://localhost:9200/path
    # IPv6 addresses should always be defined as: https://[2001:db8::1]:9200
    hosts: ["192.168.85.148:9200"]

###################################################################################
2.7.4.1.2.	使用logstash作为输出

###################################################################################
  ### Logstash as output
  #logstash:
    # The Logstash hosts
    #hosts: ["localhost:5044"]
  ### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: ["192.168.85.148:5044"]
    # Optional TLS. By default is off.
    tls:
      # List of root certificates for HTTPS server verifications
      certificate_authorities: ["/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"]
######################################################################################
##2.7.5.	load filebeat template
[root@m1 ~]# curl -XPUT 'http://192.168.85.148:9200/_template/filebeat' -d@/etc/filebeat/filebeat.template.json
{"acknowledged":true}[root@m1 ~]# 

##删除filebeat template
curl -XDELETE 'http://192.168.85.148:9200/filebeat-*'

systemctl start filebeat

########################################################################################
2.7.7.	测试filebeat
curl -XGET 'http://192.168.85.148:9200/filebeat-*/_search?pretty'

 {
        "_index" : "filebeat-2017.06.30",
        "_type" : "log",
        "_id" : "AVz4gA6ECcIFH9erG5ed",
        "_score" : 1.0,
        "_source" : {
          "@timestamp" : "2017-06-30T10:15:58.122Z",
          "beat" : {
            "hostname" : "m1",
            "name" : "m1"
          },
          "count" : 1,
          "fields" : null,
          "input_type" : "log",
          "message" : "         Expecting device dev-disk-by\\x2duuid-d1ebebf2\\x2d8b7e\\x2d409d\\x2dac48\\x2d8d080530e100.device...",
          "offset" : 2597,
          "source" : "/var/log/boot.log",
          "type" : "log"
        }
