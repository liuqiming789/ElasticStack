####################################################################
## 中文版本v2.0
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
####################################################################
## json版本test v3.1
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        id => "inqueryPhoneNumInfo"
        discover_interval => 10
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
        value_split => ":"
        remove_field=>['message_info','message']
    }
    json {
        source => "params"
        target => "params_json"
        skip_on_invalid_json => true
        remove_field => ['params','message_info','message']
    }
}
output {stdout{codec => json}}

{"\"signType\"":"MD5","\"paramsType\"":"0","\"resHostIp\"":"192.168.80.77","\"params\"":"{\"retCode\":\"0000\"","http_bio":"http-bio-8080-exec-2393","\"retMsg\"":"交易成功","\"appID\"":"600001","path":"/app/elk/filebeat_data/inqueryPhoneNumInfo.log","app_name":"UnicomPay_UniOperatorWS-app","@timestamp":"2017-08-21T06:09:21.437Z","\"signMac\"":"9302721ee7************02258f7cce","http_bio_id":"4656496502","msec":"358","@version":"1","host":"bjxhm-hadoopelk-77","\"reqSeq\"":"600001201708150000077962519","\"stepNo\"":"unipayres","\"reqHostIp\"":"\"\"","\"operTime\"":"2017-08-15 00:00:08,358","web_timestamp":"2017-08-15 00:00:08"}

####################################################################
## json版本test v3.2 --faild
####################################################################
input {
    file {
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        id => "inqueryPhoneNumInfo"
        discover_interval => 10
    }
}
filter {
    grok {
        match => {
        "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
        remove_field => ['message']
        }
    }
    json {
        source => "message_info"
        target => "message_info_json"
        skip_on_invalid_json => true
        remove_field => ['message']
    }
}
output {stdout{codec => json}}
####################################################################
## v3.3 --去掉\"字符"
####################################################################
input {
    file {
        id => "input-file-inqueryPhoneNumInfo"
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        discover_interval => 10
    }
}
filter {
    grok {
        id => "filter-grok-inqueryPhoneNumInfo"
        match => {
                    "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                    remove_field    =>  ['message']
                }
    }
    kv {
        id => "filter-kv-inqueryPhoneNumInfo"
        source => "message_info"
        field_split=>","
        value_split => ":"
        remove_field=>['message_info','message']
    }
    mutate {
        rename => { "\"signType\"" => "signType" }
        rename => { "\"paramsType\"" => "paramsType" }
        rename => { "\"resHostIp\"" => "resHostIp" }
        rename => { "\"params\"" => "retCode" }
        rename => { "\"retMsg\"" => "retMsg" }
        rename => { "\"appID\"" => "appID" }
        rename => { "\"signMac\"" => "signMac" }
        rename => { "\"reqSeq\"" => "reqSeq" }
        rename => { "\"stepNo\"" => "stepNo" }
        rename => { "\"reqHostIp\"" => "reqHostIp" }
        rename => { "\"operTime\"" => "operTime" }
    }
}
output {stdout{codec => json}}
####################################################################
## v3.4 --timestamp字段
####################################################################
input {
    file {
        id => "input-file-inqueryPhoneNumInfo"
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        discover_interval => 10
    }
}
filter {
    grok {
        id => "filter-grok-inqueryPhoneNumInfo"
        match => {
                    "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                    remove_field    =>  ['message']
                }
    }
    kv {
        id => "filter-kv-inqueryPhoneNumInfo"
        source => "message_info"
        field_split=>","
        value_split => ":"
        remove_field=>['message_info','message']
    }
    mutate {
        rename => { "\"signType\"" => "signType" }
        rename => { "\"paramsType\"" => "paramsType" }
        rename => { "\"resHostIp\"" => "resHostIp" }
        rename => { "\"params\"" => "retCode" }
        rename => { "\"retMsg\"" => "retMsg" }
        rename => { "\"appID\"" => "appID" }
        rename => { "\"signMac\"" => "signMac" }
        rename => { "\"reqSeq\"" => "reqSeq" }
        rename => { "\"stepNo\"" => "stepNo" }
        rename => { "\"reqHostIp\"" => "reqHostIp" }
        rename => { "\"operTime\"" => "operTime" }
    }
    date {
        match => [ "web_timestamp", "YYYY-MM-dd HH:mm:ss", "ISO8601","UNIX"]
        target => "@timestamp" #string类型 default to updating the @timestamp field of the event
        timezone => "Asia/Shanghai" #string类型
    }
}
output {stdout{codec => json}}
####################################################################
## v3.4 --timestamp字段
####################################################################
input {
    file {
        id => "input-file-inqueryPhoneNumInfo"
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.log"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
        discover_interval => 10
    }
}
filter {
    grok {
        id => "filter-grok-inqueryPhoneNumInfo"
        match => {
                    "message" => "\[(?<app_name>[0-9A-Za-z._-]{1,70})\] \[%{TIMESTAMP_ISO8601:web_timestamp},%{INT:msec}] \[INFO ] - \? \? \[(?<http_bio>[0-9A-Za-z._-]{1,70})\:%{INT:http_bio_id}\]\- \{(?<message_info>[u4e00-\u9fa5a-zA-Z0-9 \".:*,{}-]{1,100000})\}"
                    remove_field    =>  ['message']
                }
        add_field => {"index_name" => "inqueryPhoneNumInfo"}
    }

    mutate {
        gsub => [
        # replace all forward slashes with underscore
        "message_info", "\"", "",
        "message_info", "}", ""
        ]
    }

    kv {
        id => "filter-kv-inqueryPhoneNumInfo"
        source => "message_info"
        field_split=>","
        value_split => ":"
        remove_field=>['message_info','message']
    }

    date {
        match => [ "web_timestamp", "YYYY-MM-dd HH:mm:ss", "ISO8601","UNIX"]
        target => "@timestamp" #string default to updating the @timestamp field of the event
        timezone => "Asia/Shanghai" #string
    }
}
output {stdout{codec => json}}


