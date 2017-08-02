一.
(一)作用:
1.无缝对接elasticsearch
2.数据图表

(二)安装
server.port: 5601
server.host: "172.28.11.167"
elasticsearch.url: "http://172.28.11.167:9200"
elasticsearch.username: "elastic"
elasticsearch.password: "changeme"
elasticsearch.preserveHost: true
kibana.index: ".kibana"

二.基本操作

(一)setting添加索引

(二)dsicover
1.时间:
(1)5s准实时
(2)table 和json显示

2.字段:
(1)自定义字段,add
(2)时间字段是默认有的.
(3)_字段
(4)seleced field有简单的统计 百分比


3.字段查询
city:Keyport
age:26

4通配符查询
H*,H?

4.范围查询
age:[20 to 30]
age:{20 to 30}

5.逻辑操作
firstname:H* and age:20

必须和排除
+firstname:H* -age:20

6.字段分组查询
firstname:(+H* -He*)

7.转义
\ +- && !() {} [] \