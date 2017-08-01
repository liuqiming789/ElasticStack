一.输出到file
	只输出IP
output{
	file{
		path
		gzip
		message_format=>"%{ip}"
	}
	stdout{

	}
}

二.TCP UDP方式输出

output{
	tcp{
		codec=>json_lines
		host=>"127.0.0.1"
		port=>5656
		mode=>"server"
	}
}


三.elastic
elasticsearch就是非关系数据库

output{
	elasticsearch{
		host
		protocal=>"http"
		index=>"test_output-%{+YYYY.MM.dd}"
		document_type=>"nginx"
		workers=>5
	}
}

