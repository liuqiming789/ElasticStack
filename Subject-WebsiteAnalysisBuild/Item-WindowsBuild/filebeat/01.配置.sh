# 输入
filebeat.prospectors:

# Each - is a prospector. Most options can be set at the prospector level, so
# you can use different prospectors for various configurations.
# Below are the prospector specific configurations.

- input_type: log

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
    - D:\installtools\log\ELK\data\dcswcvyn00v0kief66rvmqc9o_6d7n_sdc_07_04_2017.log


#输出
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["172.28.11.167:5044"]


测试配置:
.\filebeat -configtest -e

###################################################################################
# At the data source machine, run Filebeat with the following command:

sudo ./filebeat -e -c filebeat.yml -d "publish"

