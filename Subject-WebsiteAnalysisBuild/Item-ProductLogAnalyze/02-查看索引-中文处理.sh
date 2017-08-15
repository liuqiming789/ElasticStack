http://192.168.11.73:9200/_cat/health?v
# 5.elasticsearch节点状态
http://192.168.11.73:9200/_cat/nodes?v
# 6.elasticsearch的索引状态
http://192.168.11.73:9200/_cat/indices?v


http://192.168.11.73:9200/_stats
http://192.168.11.73:9200/_all
http://192.168.11.73:9200/_nodes/stats
http://192.168.11.73:9200/_nodes
http://192.168.11.73:9200/_cluster/state
http://192.168.11.73:9200/_cluster/health

###################################################
[\u4e00-\u9fa5]+
[\u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]

所以最终版本
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message>[\u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}

####################################################################
## config v4.0
####################################################################
input {
#    beats {
#        port => "5044"
#        host => "192.168.80.81"
#        ssl => false
#        id => "e_coupon_waifang"
#        type => "webtrends_sdc_log"
#    }
    file {
        discover_interval => 10
        id => "inqueryPhoneNumInfo"
        type => "teleinfo_log"
        path => "/app/elk/filebeat_data/inqueryPhoneNumInfo.log"

    }
}
# The filter part of this file is commented out to indicate that it is optional.
filter {
    if [id] == "e_coupon_waifang" {
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
    if [id] == "inqueryPhoneNumInfo" {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             value_split => ":"
             remove_field=>['message_info','message']
         }
    }

}
output {
    if [id] == "e_coupon_waifang" {
        elasticsearch {
            hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
            manage_template => false
            #user => elastic
            #password => changeme
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }
    if [id] == "inqueryPhoneNumInfo" {
        elasticsearch {
            hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
            manage_template => false
            #user => elastic
            #password => changeme
            index => "%{[@metadata][id]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }
}

####################################################################
## config test
####################################################################
input {stdin{}}
filter {
	grok {
        	match => {
               "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                remove_field    =>  ['message']
                }
            }
        kv {
		source => "message_info"
             	field_split=>","
             	remove_field=>['message_info','message']
         }
}
output {stdout { codec => json}}


测试1:
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"sucess"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
测试中文:
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
####################################################################
## config 加id判断
####################################################################
input {
	stdin{
		id => "stdin"
	}
}
filter {
	if [id] == "stdin" {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field => ['message']
                }
            }
        kv {
             source => "message_info"
             field_split => ","
             value_split => ":"
             remove_field => ['message_info','message']
         }
    }
}
output {
	if [id] == "stdin" {
		stdout {
            codec => json
        }
    }
}

测试1:
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"sucess"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
测试中文:
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}

问题原因:
output
output {
	if [id] == "stdin" {
		stdout {
            codec => json
        }
    }
}
不能这样if判断

结论:
input定义的id可以传到filter,不能传到output
filter可以if [id]==判断
output不可用if [id] ==判断
####################################################################
## config v5.0
####################################################################
input {
#    beats {
#        port => "5044"
#        host => "192.168.80.81"
#        ssl => false
#        id => "e_coupon_waifang"
#        type => "webtrends_sdc_log"
#    }
    file {
        discover_interval => 10
        id => "inqueryPhoneNumInfo"
        type => "teleinfo_log"
        path => "/app/elk/filebeat_data/inqueryPhoneNumInfo.log"
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {
    if [id] == "e_coupon_waifang" {
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
    if [id] == "inqueryPhoneNumInfo" {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             value_split => ":"
             remove_field=>['message_info','message']
         }
    }

}
output {
    #if [id] == "e_coupon_waifang" {
    #    elasticsearch {
    #        hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
    #        manage_template => false
    #        #user => elastic
    #        #password => changeme
    #        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    #        document_type => "%{[@metadata][type]}"
    #    }
    #}
    #if [id] == "inqueryPhoneNumInfo" {
        elasticsearch {
            hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
            manage_template => false
            #user => elastic
            #password => changeme
            index => "%{[@metadata][id]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    #}
}
####################################################################
## config test 无输出
####################################################################
input {
    file {
        discover_interval => 10
        id => "inqueryPhoneNumInfo"
        type => "teleinfo_log"
        path => "/app/elk/filebeat_data/inqueryPhoneNumInfo.log"
        start_position => "beginning"
    }
}
filter {
    if [id] == "inqueryPhoneNumInfo" {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             #value_split => ":"
             remove_field=>['message_info','message']
         }
    }

}
output {
#	elasticsearch {
#	    hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
#	    manage_template => false
#	    #user => elastic
#	    #password => changeme
#	    index => "%{[@metadata][id]}-%{+YYYY.MM.dd}"
#	    document_type => "%{[@metadata][type]}"
#	}
	stdout{codec => json}
}

问题:文件输入没有输入

input {
    file {
        discover_interval => 10
        id => "inqueryPhoneNumInfo"
        type => "teleinfo_log"
        path => "/app/elk/filebeat_data/inqueryPhoneNumInfo.log"
        start_position => "beginning"
    }
}
filter {}
output {stdout{codec => json}}


input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {}
output {stdout{}}

奇怪问题
echo "hello wold" >> inqueryPhoneNumInfo.log
追加.显示begging怎么破
sincedb_path => "/dev/null"

解决:
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {}
output {stdout{}}

####################################################################
## config test --输出没有问题.
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {
 grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             #value_split => ":"
             remove_field=>['message_info','message']
         }
}
output {stdout{}}

####################################################################
## 输入到elastic的问题
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {
 grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             #value_split => ":"
             remove_field=>['message_info','message']
         }
}
output {
	elasticsearch {
	   	hosts => ["192.168.11.73:9200"]
	    manage_template => false
	    index => "%{[@metadata][id]}-%{+YYYY.MM.dd}"
	    document_type => "%{[@metadata][type]}"
	}
}
####################################################################
## 改进2
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
    }
}
filter {
 grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             #value_split => ":"
             remove_field=>['message_info','message']
         }
}
output {
	elasticsearch {
	    hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
	    manage_template => false
	    #user => elastic
	    #password => changeme
	    index => "file-%{+YYYY.MM.dd}"
	    document_type => "log"
	}
}

green  open   file-2017.08.15               d8KK0C90So60muufCeML7A   5   1      39784            0     60.4mb         29.9mb
测试通过
####################################################################
## 改进3 if --成功
####################################################################

input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        id => "inqueryPhoneNumInfo"

    }
}
filter {
        if [id] == "inqueryPhoneNumInfo" {
                grok {  
                        match => {                                "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                                remove_field    =>  ['message']
                        }
                }   
                kv {
                source => "message_info"
                field_split=>","
                #value_split => ":"
                remove_field=>['message_info','message']
                }
        }
}
output {
        elasticsearch {
            hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
            manage_template => false
            #user => elastic
            #password => changeme
            index => "test-%{+YYYY.MM.dd}"
            document_type => "log"
        }
}
####################################################################
## full版本 --成功版本
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        id => "inqueryPhoneNumInfo"
        discover_interval => 10
    }
#    beats {
#        port => "5044"
#        host => "192.168.80.81"
#        ssl => false
#        id => "e_coupon_waifang"
#        type => "webtrends_sdc_log"
#    }
}
filter {
    if [id] == "inqueryPhoneNumInfo" {
        grok {
			match => {
						"message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                    }
        }
		kv {
			source => "message_info"
			field_split=>","
           	#value_split => ":"
            remove_field=>['message_info','message']
            }
    }
    if [id] == "e_coupon_waifang" {
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
}
output {
        elasticsearch {
            hosts => ["192.168.11.73:9200","192.168.11.74:9200","192.168.11.75:9200"]
            manage_template => false
            #user => elastic
            #password => changeme
            index => "full-%{+YYYY.MM.dd}"
            document_type => "log"
        }
}