#部署服务器
webtrends sdc服务器 192.168.80.81
# 01占用情况
netstat -aon|findstr "5044"
# 02
output.logstash:
  # The Logstash hosts
  hosts: ["192.168.11.77:5044"]

# 01
- input_type: log

  # Paths that should be crawled and fetched. Glob based paths.
  paths:
  # 沃钱包-电子券-外放
    - D:\Program Files (x86)\Webtrends\SmartSource Data Collector\sdc\weblog\dcs4zpvp31v0kiag42qwkqc9o_4w2v_sdc*.log

# 03

#================================ General =====================================

# The name of the shipper that publishes the network data. It can be used to group
# all the transactions sent by a single shipper in the web interface.
#name:

# The tags of the shipper are included in their own field with each
# transaction published.
#tags: ["service-X", "web-tier"]

# Optional fields that you can specify to add additional information to the
# output.
fields:
  project_name: "webtrends-沃钱包-电子券-外放"


# 04 index
output.logstash:
  # The Logstash hosts
  hosts: ["192.168.11.77:5044"]
  index: "webtrends-沃钱包-电子券-外放"


# 04 test
.\filebeat -configtest -e

#05 启动
.\filebeat -c filebeat.yml -e -d "publish"

# 添加网络开发5044
