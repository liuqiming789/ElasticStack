# The date filter is used for parsing dates from fields, and then using that date or timestamp as the logstash timestamp for the event.

# match
# If your time field has multiple possible formats, you can do this:

# match => [ "logdate", "MMM dd yyyy HH:mm:ss",
#           "MMM  d yyyy HH:mm:ss", "ISO8601" ]

# ISO8601 - should parse any valid ISO8601 timestamp, such as 2011-04-19T03:44:01.103Z
# UNIX - will parse float or int value expressing unix time in seconds since epoch like 1326149001.132 as well as 1326149001
# UNIX_MS - will parse int value expressing unix time in milliseconds since epoch like 1366125117000
# TAI64N - will parse tai64n time values
date {
  match => [ "timestamp", "YYYY-MM-dd HH:mm:ss", "ISO8601","UNIX"]
  target => "timestamp" #string类型 default to updating the @timestamp field of the event
  timezone => "Asia/Shanghai" #string类型
}


# plugins-filters-dissect
# Unlike a regular split operation where one delimiter is applied to the whole string, this operation applies a set of delimiters # to a string value.

# /plugins-filters-elapsed
filter {
  elapsed {
    start_tag => "start event tag"
    end_tag => "end event tag"
    unique_id_field => "id field name"
    timeout => seconds
    new_event_on_match => true/false
  }
}

filter {
  grok {
    match => { "message" => "%{TIMESTAMP_ISO8601} START id: (?<task_id>.*)" }
    add_tag => [ "taskStarted" ]
  }
  grok {
  match => { "message" => "%{TIMESTAMP_ISO8601} END id: (?<task_id>.*)" }
  add_tag => [ "taskTerminated" ]
  }
elapsed {
    start_tag => "taskStarted"
    end_tag => "taskTerminated"
    unique_id_field => "task_id"
  }
}

# plugins-filters-environment
# This filter stores environment variables as subfields in the @metadata field, You can then use these values in other parts of the pipeline.
filter { environment { add_metadata_from_env => { "field_name" => "ENV_VAR_NAME" } } }
["@metadata"]["field_name"]
