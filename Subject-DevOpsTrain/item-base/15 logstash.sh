# 15 logstash
一.简介:
(一)好处
灵活过滤日志,试试分析,直观的展示
(二)ELK
1.elasticsearch,logstash,kibana

二.logstash
(一)功能特性
1.各种类型的数据
2.标准化不同模式和格式的数据
3.快速扩展自定义日志的格式
4.插件,自定义数据源

(二)解释
jruby编写,运行jvm上
收集分析和转发数据量

(三)安装
1.

三.logstash运行参数
1. -f 配置文件
2. -e 指定字符串输入
3. -w 工作线程个数
4. -l 日志文件
5. --V 版本
6. -t 测试配置文件语法

四.logstash配置语法以及插件
(一)input
input{
	# stdin{}
	file{
		path=>
		start_postiton=>
	}
}

(二)语法格式
1.区域:{},可以定义插件,完成功能.一个区域内可以定义多个插件
2.数据类型:
	布尔 => true
	字节:=>"10MiB"
	字符串=>""
	数值 => 5433
	数组 => ["",""]
	哈希 =>{
		key1=>value,
	}
	
	字符串 =>""
	编码解码:codec=>"json",
	密码
	路径
	注释:#
3.条件判断
	==,!=
	正则:=~,!~
	符合表达式:(),
	对符合表达式取反 !()
	if true{}
	else if{}
    else{}

4.字段引用,标量内插
	"apache%{[reponse][status]}%"

五.logstash插件:github.com/logstash-pugins
/plugin install logstash-input-jdbc

(一)inputs 输入

(二)codecs 编码

(三)filters 过滤

(四)output输出
