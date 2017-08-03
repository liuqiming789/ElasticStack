#######################################################
#配置文件
#######################################################
input {stdin{}}
filter {
     kv{
     field_split=>"&?"
    }
}
output{stdout{codec=>json}}
#######################################################

bin\logstash -f test-pipeline.conf --config.test_and_exit
bin\logstash -f test-pipeline.conf --config.reload.automatic

[2017-08-02T17:32:34,078][ERROR][logstash.inputs.metrics  ] Failed to create monitoring event {:message=>"For path: queue", :error=>"LogStash::Instrum
ent::MetricStore::MetricNotFound"}

logstash.yml添加

http.host: "127.0.0.1"
path.config: D:\installtools\ELK_ElasticStack\logstash-5.4.3

# http://111.*.*.11:9200 is the IP & Port of Elasticsearch's server 
xpack.monitoring.elasticsearch.url: 127.0.0.1:9200

# "elastic" is the user name of Elasticsearch's account
xpack.monitoring.elasticsearch.username: elastic 

# "changeme" is the password of Elasticsearch's "elastic" user 
xpack.monitoring.elasticsearch.password: changeme

######################################################
#重点
# bin\logstash-plugin remove x-pack
#[2017-08-02T17:32:34,078][ERROR][logstash.inputs.metrics  ] Failed to create monitoring event {:message=>"For path: queue", :error=>"LogStash::Instrum
# ent::MetricStore::MetricNotFound"}
######################################################
bin\logstash-plugin remove x-pack

logstash.yml去掉配置
bin\logstash -f test-pipeline.conf --config.test_and_exit
bin\logstash -f test-pipeline.conf --config.reload.automatic

[2017-08-02T17:48:41,583][ERROR][logstash.agent           ] Logstash is not able to start since configuration auto reloading was enabled but the confi
guration contains plugins that don not support it. Quitting... {:pipeline_id=>"main", :plugins=>[LogStash::Inputs::Stdin]}

##stdout stdin 不能config.reload.automatic

bin\logstash -f test-pipeline.conf


测试
2017-07-04 04:32:44 113.57.182.16 - epay.10010.com GET /wappay3.0/httpservice/wapPayPageAction.do reqcharset=UTF-8&WT.tz=8&WT.bh=12&WT.ul=zh-cn&WT.cd=32&WT.sr=375x667&WT.jo=No&WT.ti=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&WT.js=Yes&WT.jv=1.5&WT.ct=unknown&WT.bs=749x1203&WT.fi=No&WT.em=uri&WT.le=ISO-8859-1&WT.tv=8.0.2&WT.vt_f_tlh=1499142823&WT.mod=order&WT.act=order_load&WT.mobile=17612778318&WT.co=No&WT.vt_sid=2fbe451eaa7d89566da1497936556154.1499142769111&WT.co_f=2fbe451eaa7d89566da1497936556154 200 - - Mozilla/5.0+(iPhone;+CPU+iPhone+OS+10_0_2+like+Mac+OS+X)+AppleWebKit/602.1.50+(KHTML,+like+Gecko)+Mobile/14A456+unicom{version:iphone_c@5.3} - https://epay.10010.com/ecpay/pay/payAction.action dcswcvyn00v0kief66rvmqc9o_6d7n

#####################################################
#测试 两个过滤器
#####################################################
#手写
" %{TIMESTAMP_ISO8601:web_timestamp} %{IP:server_ip} - %{HOSTNAME1:http_host} GET %{URIPATH:uri} %{?(^(reqcharset=)( 200)$:message} -- %{?(^(Mozilla)(\})$:agent} %{?[A-Za-z0-9]{30}:dcsid}"

##自动生成
%{URIHOST:id} %{HAPROXYTIME:id} %{IP:id} - epay%{BASE16FLOAT:id}.com GET %{URIPATHPARAM:id} reqcharset=UTF-8&%{JAVACLASS:id}=8&%{JAVACLASS:id}=12&%{JAVACLASS:id}=zh-cn&%{JAVACLASS:id}=32&%{JAVACLASS:id}=375x667&%{JAVACLASS:id}=No&%{JAVACLASS:id}=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&%{JAVACLASS:id}=Yes&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}=unknown&%{JAVACLASS:id}=749x1203&%{JAVACLASS:id}=No&%{JAVACLASS:id}=uri&%{JAVACLASS:id}=%{CISCOTAG:id}&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}_f_tlh=1499142823&%{JAVACLASS:id}=order&%{JAVACLASS:id}=order_load&%{JAVACLASS:id}=17612778318&%{JAVACLASS:id}=No&%{JAVACLASS:id}_sid=%{JAVACLASS:id}&%{JAVACLASS:id}_f=2fbe451eaa7d89566da1497936556154 200 - - Mozilla%{URIPATHPARAM:id} - %{URI:id} dcswcvyn00v0kief66rvmqc9o_6d7n
##修改1 --OK
%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - epay%{BASE16FLOAT:id}.com GET %{URIPATHPARAM:id} reqcharset=UTF-8&%{JAVACLASS:id}=8&%{JAVACLASS:id}=12&%{JAVACLASS:id}=zh-cn&%{JAVACLASS:id}=32&%{JAVACLASS:id}=375x667&%{JAVACLASS:id}=No&%{JAVACLASS:id}=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&%{JAVACLASS:id}=Yes&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}=unknown&%{JAVACLASS:id}=749x1203&%{JAVACLASS:id}=No&%{JAVACLASS:id}=uri&%{JAVACLASS:id}=%{CISCOTAG:id}&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}_f_tlh=1499142823&%{JAVACLASS:id}=order&%{JAVACLASS:id}=order_load&%{JAVACLASS:id}=17612778318&%{JAVACLASS:id}=No&%{JAVACLASS:id}_sid=%{JAVACLASS:id}&%{JAVACLASS:id}_f=2fbe451eaa7d89566da1497936556154 200 - - Mozilla%{URIPATHPARAM:id} - %{URI:id} dcswcvyn00v0kief66rvmqc9o_6d7n
##修改2
%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} reqcharset=UTF-8&%{JAVACLASS:id}=8&%{JAVACLASS:id}=12&%{JAVACLASS:id}=zh-cn&%{JAVACLASS:id}=32&%{JAVACLASS:id}=375x667&%{JAVACLASS:id}=No&%{JAVACLASS:id}=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&%{JAVACLASS:id}=Yes&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}=unknown&%{JAVACLASS:id}=749x1203&%{JAVACLASS:id}=No&%{JAVACLASS:id}=uri&%{JAVACLASS:id}=%{CISCOTAG:id}&%{JAVACLASS:id}=%{JAVACLASS:id}&%{JAVACLASS:id}_f_tlh=1499142823&%{JAVACLASS:id}=order&%{JAVACLASS:id}=order_load&%{JAVACLASS:id}=17612778318&%{JAVACLASS:id}=No&%{JAVACLASS:id}_sid=%{JAVACLASS:id}&%{JAVACLASS:id}_f=2fbe451eaa7d89566da1497936556154 200 - - Mozilla%{URIPATHPARAM:id} - %{URI:id} dcswcvyn00v0kief66rvmqc9o_6d7n

####################################################
#request_info
####################################################
reqcharset=UTF-8&WT.tz=8&WT.bh=12&WT.ul=zh-cn&WT.cd=32&WT.sr=375x667&WT.jo=No&WT.ti=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&WT.js=Yes&WT.jv=1.5&WT.ct=unknown&WT.bs=749x1203&WT.fi=No&WT.em=uri&WT.le=ISO-8859-1&WT.tv=8.0.2&WT.vt_f_tlh=1499142823&WT.mod=order&WT.act=order_load&WT.mobile=17612778318&WT.co=No&WT.vt_sid=2fbe451eaa7d89566da1497936556154.1499142769111&WT.co_f=2fbe451eaa7d89566da1497936556154
(?<request_info>[a-zA-z0-9.%-=&]{1,70000})

##修改4
%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - Mozilla%{URIPATHPARAM:id} - %{URI:id} dcswcvyn00v0kief66rvmqc9o_6d7n

####################################################
#agent
####################################################
Mozilla/5.0+(iPhone;+CPU+iPhone+OS+10_0_2+like+Mac+OS+X)+AppleWebKit/602.1.50+(KHTML,+like+Gecko)+Mobile/14A456+unicom{version:iphone_c@5.3}
(?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000})

##修改5
%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - (?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000}) - %{URI:full_url} dcswcvyn00v0kief66rvmqc9o_6d7n
##修改6
%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - (?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000}) - %{URI:full_url} (?<dcsid>[a-zA-z0-9]{20,40})

#####################################################
# 测试1
# 第二个kv生效,第一个grok不生效
#####################################################
input {stdin{}}
filter {
     grok {
            match => { 
                    "message" => "%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - (?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000}) - %{URI:full_url} (?<dcsid>[a-zA-z0-9]{20,40})"
            remove_field=>['message']
            }
        }
#    kv {
#         field_split=>"&?"
#         remove_field=>['request_info']
#     }
}

output{
    file{
        path=>"output-20170803.txt"
        codec=>json
    }
}
#####################################################
# 测试1
# 第二个kv生效,第一个grok不生效
#####################################################

input {stdin{}}
filter {
     grok {
            match => { 
                    "message" => "%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - (?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000}) - %{URI:full_url} (?<dcsid>[a-zA-z0-9]{20,40})"
            remove_field=>['message']
            }
        }
    kv {
         source => "request_info"
         field_split=>"&?"
         remove_field=>['request_info','message']
     }
}

output{
    file{
        path=>"output-20170803.txt"
        codec=>json
    }
}