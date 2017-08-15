 # vi webtends_pipeline.conf
 input {
    beats {
        port => "5044"
        host => "192.168.80.81"
        ssl => false
        type => "webtrends_sdc_log"
    }
}
# The filter part of this file is commented out to indicate that it is
# optional.
filter {
	if [type] == "webtrends_sdc_log" {
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
	if [type] == "webtrends_sdc_log" {
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
}


# index名称
        index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
        document_type => "%{[@metadata][type]}"


# filebeat
output.logstash:
  # The Logstash hosts
  hosts: ["192.168.11.77:5044"]
  index: "webtrends-沃钱包-电子券-外放"
- input_type: log

fields:
  project_name: "webtrends-沃钱包-电子券-外放"


nohup bin/logstash -f config/webtends_pipeline.conf --config.reload.automatic 2>&1 &
bin/logstash -f config/full_pipeline.conf --config.test_and_exit