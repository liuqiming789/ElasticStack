#日志:
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}

#input and out
input {
    stdin {
        type => "teleinfo_log"
    }
}
filter {
    if [type] == "teleinfo_log" {
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
    if [type] == "teleinfo_log" {
        stdout{
            codec => json
        }
    }
}

#测试配置文件
bin/logstash -f config/teleinfo_pipeline.conf --config.test_and_exit
##############################################################################################
#v1
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? 
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - ? ? 

# v2
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec:4627073270]-
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}]-
# 注:
[0-9A-z]里面不能出现:

# v3
{"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}

# v3.1
{"signMac":"2451231b84************1d9d95c18e","params":{"retCode":"0000"}}
\{(?<message_info>[a-zA-Z0-9":*,{}]{1,10000})\}

# v3.2
{"signMac":"2451231b84************1d9d95c18e","params":{"retCode":"0000","retMsg":"交易成功"}}
\{(?<message_info>[a-zA-Z0-9":*,{}交易成功]{1,100000})\}

# v3.3
{"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
\{(?<message_info>[a-zA-Z0-9".:*,{}交易成功-]{1,100000})\}

# v3.4
{"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001","params":{"retCode":"0000","retMsg":"交易成功"}}
\{(?<message_info>[a-zA-Z0-9".:*,{}交易成功-]{1,100000})\}

# v3.5
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec:4627073270]-{"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001","params":{"retCode":"0000","retMsg":"交易成功"}}
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}]-\{(?<message_info>[a-zA-Z0-9".:*,{}交易成功-]{1,100000})\}

#v4.0
差两个空格:去掉否则无法匹配
]-{
2017-08-1415:49:45

# v4.1
解决一个空格]-{
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-1415:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[a-zA-Z0-9".:*,{}交易成功-]{1,100000})\}

# v4.2
解决第二个空格[]中加空格
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"交易成功"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}
\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[a-zA-Z0-9 ".:*,{}交易成功-]{1,100000})\}

####################################################################
## config v1.0
####################################################################
input {
    stdin {
        type => "teleinfo_log"
    }
}
filter {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             remove_field=>['request_info','message']
         }
}
output {
        stdout{
            codec => json
        }
}


中文问题:交易成功=sucess
否则:
he following config files contains non-ascii characters but are not UTF-8 encoded

输入.输出
[UnicomPay_UniOperatorWS-app] [2017-08-14 15:49:45,126] [INFO ] - ? ? [http-bio-8080-exec-2382:4627073270]- {"signMac":"2451231b84************1d9d95c18e","paramsType":"0","reqHostIp":"","signType":"MD5","reqSeq":"600001201708141549444629557","operTime":"2017-08-14 15:49:45,126","params":{"retCode":"0000","retMsg":"sucess"},"stepNo":"unipayres","resHostIp":"192.168.80.77","appID":"600001"}

####################################################################
## config v2.0
####################################################################
input {
    stdin {
        type => "teleinfo_log"
    }
}
filter {
    if [type] == "teleinfo_log" {
        grok {
                match => {
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             remove_field=>['request_info','message']
         }
    }
}
output {
    if [type] == "teleinfo_log" {
        stdout{
            codec => json
        }
    }
}
####################################################################
## config v3.0
####################################################################
input {
    beats {
        port => "5044"
        host => "192.168.80.81"
        ssl => false
        id => "e_coupon_waifang"
        type => "webtrends_sdc_log"
    }
    file {
        discover_interval => 10
        id => "inqueryPhoneNumInfo"
        type => "teleinfo_log"
        path => "/app/elk/filebeat_data/inqueryPhoneNumInfo.log*"

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
                        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                        remove_field    =>  ['message']
                }
            }
        kv {
             source => "message_info"
             field_split=>","
             remove_field=>['message_info','message']
         }
    }

}

output {
    if [id] == "e_coupon_waifang" {
        elasticsearch {
            hosts => ["192.168.11.73:9200"]
            #manage_template => false
            #user => elastic
            #password => changeme
            #sniffing => true
            index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }

    if [id] == "inqueryPhoneNumInfo" {
        elasticsearch {
            hosts => ["192.168.11.73:9200"]
            #manage_template => false
            #user => elastic
            #password => changeme
            #sniffing => true
            index => "%{[@metadata][id]}-%{+YYYY.MM.dd}"
            document_type => "%{[@metadata][type]}"
        }
    }
}
