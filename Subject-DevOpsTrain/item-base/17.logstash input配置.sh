# 标准输入插件:
input {stdin {} } output { stdout {}}

#file  input插件
input{
	file{
		codec=> plain  # 默认的.编码格式
		discover_interval=> # number,多久去监听path的文件,默认15秒
		path=>  [""]#必选项,可以定义多个路径.array;绝对路径
		tags=> #
		type=>'syslog',
		start_position=> #beginning 全部数据  #end类似end
	}

}

output{
	stdout{}
}

# tcp输入
input {
	tcp{
		add_field=>      
		codec=>,
		data_timeout=>..#number,默认-1,永不超时
		host=>,
		port=>,
		mode=>#server默认,或者client
		ssl_cert,
		ssl_enable,
		ssl_key,
		ssl_vertify
	}
}

# 读入数据nc 127.0.0.1 9999 < datas


# syslog输入

6之后,rsyslog是一个syslogd多线程增强版

/etc/rsyslog.conf
service rsyslog restart

# 日志量大,kafka
facility_lables 
serverity_lables
host
port  514默认 

input{
	syslog{
		host=>"127.0.0.1",
		type='syslog',
		port=>'518'
	}
}
output{
	stdout{}
}
# 开启MODload lmtcp
两个@@采用tcp协议
*.* @@127.0.0.1:518

# logger
输入hello syslog
