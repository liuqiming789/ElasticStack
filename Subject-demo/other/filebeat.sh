# %ES_HOME%\bin\elasticsearch.bat


# 1.使用logstash作为输出
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["172.28.11.167:5044"]


# 2.输入

#=========================== Filebeat prospectors =============================

filebeat.prospectors:
# Each - is a prospector. Most options can be set at the prospector level, so
# you can use different prospectors for various configurations.
# Below are the prospector specific configurations.
- input_type: log
  paths:
    - D:\installtools\log\ELK\data\dcswcvyn00v0kief66rvmqc9o_6d7n_sdc_07_04_2017.log


# 3.先启动logstash
# first-pipeline.conf
input {
    beats {
        port => "5044"
        host => "172.28.11.167"
        ssl => false
    }
}
# The filter part of this file is commented out to indicate that it is
# optional.
# filter {
#
# }
output {
    elasticsearch {
        osts => ["172.28.11.167:9200"]
        #manage_template => false
        user => elastic
        password => changeme
        #sniffing => true
        #index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
        #document_type => "%{[@metadata][type]}"
    }
}


# windows执行
bin\logstash -f first-pipeline.conf --config.test_and_exit
bin\logstash -f first-pipeline.conf --config.reload.automatic