filebeat服务监听		172.28.11.167:5044
filebeat启动			./filebeat  -c filebeat.yml -e
						/filebeat -e -c filebeat.yml -d "publish"

logstash API endpoint	172.28.11.167:9600
logstash启动            bin\logstash -f filter-pipeline.conf --config.reload.automatic

elasticsearch服务监听	172.28.11.167:9200
elasticsearch启动		%ES_HOME%\bin\elasticsearch.bat

kibana网页端口			172.28.11.167:5601
kibana启动				%KIBANA_HOME%\bin\kibana.bat

elasticsearch-head 
file:///D:/installtools/ELK_ElasticStack/elasticsearch-head/index.html?auth_user=elastic&auth_password=changeme