####################################################################
## fullv4.0 --
####################################################################
input {
    file {
        id => "inqueryPhoneNumInfo"
        path => ["/app/elk/filebeat_data/inqueryPhoneNumInfo.bak"]
        start_position => "beginning"
        sincedb_path => "/dev/null"
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

    if [id] == "e_coupon_waifang" {
        grok {
            match => {
                "message" => "%{TIMESTAMP_ISO8601:web_timestamp} %{IPV4:ip} - (?<root_url>[0-9A-Za-z.]{1,70}) GET %{URIPATHPARAM:uripathparam} (?<request_info>[a-zA-z0-9.%-=&]{1,70000}) 200 - - (?<agent>[a-zA-z0-9/.+(;+),:{}@]{1,70000}) - %{URI:full_url} (?<dcsid>[a-zA-z0-9]{20,40})"
                remove_field=>['message']
            }
            add_field => {"index_name"=>"e_coupon_waifang"}

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
            index => "%{[@metadata][index_name]}-%{+YYYY.MM.dd}"
            document_type => "log"
        }
}
