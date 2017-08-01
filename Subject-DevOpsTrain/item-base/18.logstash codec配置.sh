
一.logstash处理流程
input->decode->filter->encode->output
       解码            编码
codec: json,msgpack,edn

二.插件
(一)plain编码
空的解析器,用户自定义编码
1.input{
	stdin{
		codec=>plain
	}
}
output{
	stdout{}
}

(二)json编码
1.

input{stdin{}}
output{
	stdout{codec=>json}
}


2.rubydebug
input{stdin{codec=>json}}
output{stdout{codec=>rubydebug}}

(三)multiline多行事件编码
不如java的异常日志

input{
	stdin{
		codec=>muliline{
			charset=>utf-8 #可选
			max_bytes=>bytes类型
			max_lines #默认500
			pattern => #必选项,匹配的正则表达死
			patterns_dir => [] #
			negate => # 正向匹配 反向匹配
			what =>  # privouse,next

		}
	}
}

1.
日志
[2017-12-31]
[2017-12-31]
input{
	stdin{
		codec=>muliline{
			pattern => '^\['  # [开头 分隔
			negate => true # 正向匹配
			what => "previous" # previous,next  #开头[加后面算一部分.  中间部分+下一个[算一部分.

		}
	}
}
output {stdout {}}


