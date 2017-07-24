# 2.5.1.	安装nginx
yum -y install epel-release
yum -y install nginx httpd-tools
# 2.5.2.	创建用户并设定密码
htpasswd -c /etc/nginx/htpasswd.users kibanaadmin
# 2.5.3.	修改/etc/nginx/nginx.conf
没变
include /etc/nginx/conf.d/*.conf;
# 2.5.4.	创建/etc/nginx/conf.d/kibana.conf文件
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

# 使用http basic认证用户身份。
# 使用nginx反向代理到kibana所在服务器http://192.168.85.148:5601 为了使上述配置生效并能成功代理，需做如下操作
setsebool -P httpd_can_network_connect 1
# 至此，访问nginx时则会要求输入用户名密码（kibanaadmin/kibanaadmin）。输入正确后请求会请求代理到kibana

systemctl start nginx
systemctl enable nginx

#############################
http://192.168.85.148反向代理到
http://192.168.85.148/app/kibana


  # 2.8.3.	安装topbeat
wget https://download.elastic.co/beats/topbeat/topbeat-1.2.2-x86_64.rpm
rpm -vi topbeat-1.2.2-x86_64.rpm

vim /etc/topbeat/topbeat.yml

output:

  ### Elasticsearch as output
  #elasticsearch:
    # Array of hosts to connect to.
    # Scheme and port can be left out and will be set to the default (http and 9200)
    # In case you specify and additional path, the scheme is required: http://localhost:9200/path
    # IPv6 addresses should always be defined as: https://[2001:db8::1]:9200
   # hosts: ["localhost:9200"]
### Logstash as output
  logstash:
    # The Logstash hosts
    hosts: ["192.168.85.148:5044"]
    # Number of workers per Logstash host.
    #worker: 1
    # Set gzip compression level.
    #compression_level: 3
    # Optional load balance the events between the Logstash hosts
    #loadbalance: true
    # Optional index name. The default index name depends on the each beat.
    # For Packetbeat, the default is set to packetbeat, for Topbeat
    # top topbeat and for Filebeat to filebeat.
    #index: topbeat
    # Optional TLS. By default is off.
    tls:
      # List of root certificates for HTTPS server verifications
      #certificate_authorities: ["/etc/pki/root/ca.pem"]
      certificate_authorities: ["/opt/ELK/logstash-5.4.3/certs/logstash-forwarder.crt"]

#####################
test
#####################

curl -XPUT 'http://192.168.85.148:9200/_template/topbeat' -d@/etc/topbeat/topbeat.template.json
 curl -XDELETE 'http://192.168.85.148:9200/topbeat-*'

 systemctl enable topbeat
 systemctl restart topbeat

 curl -XGET 'http://192.168.85.148:9200/topbeat-*/_search?pretty'

 {
  "took" : 1,
  "timed_out" : false,
  "_shards" : {
    "total" : 0,
    "successful" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 0,
    "max_score" : 0.0,
    "hits" : [ ]
  }
}


