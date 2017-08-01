一.插件json filter
1.作用:解析成相应的结构
2.
filter{
	json{
		add_field,
		add_tag,
		remove_field,
		rmove_tag,
		source=>, #必选
		target=>,
	}
}

3.
input{stdin{}}
filter{
	json{
		source=>'message'
	}
}
output{stdout{codec=>rubdebug}}

二.GROK filter
非结构话的日志数据工具

(一)自带:
%{IP:ip} 空格 

1.nginx日志
55.3.244.1 GET /index.html 15824 0.043

input{
	file{
		path
		type
		start_position
	}
}

filter{
	grok{
		match=>["message","%{IP:ip} %{}..."]
	}
}
output{stdout{codec=>rubdebug}}

(二)自定义

%(?<自定义列id>正则表达式)

1.自定义patterns_dir文件,文件中定义ID和正则表达式

(三)多匹配定义
文件中有多种格式的日志条数
match=>[
	"message","%%",
	message","%%",
	message","%%",
]

(四)参数
break_on_match=>false #不只是匹配一次
keep_empty_captures=> 
match
named_captures_only
overwrite=>"message"

(五)grokdebug.herokuapp.com

三.KV  filter
解析key-value

1.&&分隔.
filter{
	kv{
		filed_split=>"&?"
	}
}


}

