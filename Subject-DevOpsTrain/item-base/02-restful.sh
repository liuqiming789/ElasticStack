02-restful

一.restful
1.json优点:格式压缩,方便解析,支持编程语言
2.表现层的状态转换:
# 资源操作
get 获取资源
post	新建和更新资源
put		更新资源
delete	删除资源

二.curl
1.开头通过http接口,运维通过curl
2.显示头信息
curl -i www.baidu.com
3.显示一次通信过程
curl -v www.baidu.com
4.网页操作
curl -X GET wwww.baidu.com
curl -X POST wwww.baidu.com
curl -X PUT wwww.baidu.com
curl -X DELETE wwww.baidu.com



