# 01.日志分析:
#Fields: date time c-ip cs-username cs-host cs-method cs-uri-stem cs-uri-query sc-status sc-bytes cs-version cs(User-Agent) cs(Cookie) cs(Referer) dcs-id 
2017-07-04 04:32:44 113.57.182.16 - epay.10010.com GET /wappay3.0/httpservice/wapPayPageAction.do reqcharset=UTF-8&WT.tz=8&WT.bh=12&WT.ul=zh-cn&WT.cd=32&WT.sr=375x667&WT.jo=No&WT.ti=%2525252525252525252525252525252525E6%2525252525252525252525252525252525B2%252525252525252525252525252525252583%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525AF%2525252525252525252525252525252525E4%2525252525252525252525252525252525BB%252525252525252525252525252525252598%2525252525252525252525252525252525E6%252525252525252525252525252525252594%2525252525252525252525252525252525B6%2525252525252525252525252525252525E9%252525252525252525252525252525252593%2525252525252525252525252525252525B6%2525252525252525252525252525252525E5%25252525252525252525252525252525258F%2525252525252525252525252525252525B0&WT.js=Yes&WT.jv=1.5&WT.ct=unknown&WT.bs=749x1203&WT.fi=No&WT.em=uri&WT.le=ISO-8859-1&WT.tv=8.0.2&WT.vt_f_tlh=1499142823&WT.mod=order&WT.act=order_load&WT.mobile=17612778318&WT.co=No&WT.vt_sid=2fbe451eaa7d89566da1497936556154.1499142769111&WT.co_f=2fbe451eaa7d89566da1497936556154 200 - - Mozilla/5.0+(iPhone;+CPU+iPhone+OS+10_0_2+like+Mac+OS+X)+AppleWebKit/602.1.50+(KHTML,+like+Gecko)+Mobile/14A456+unicom{version:iphone_c@5.3} - https://epay.10010.com/ecpay/pay/payAction.action dcswcvyn00v0kief66rvmqc9o_6d7n
# 02.logstash过滤器
https://github.com/logstash-plugins/logstash-patterns-core/tree/master/patterns
# 03.Grok Filter Plugin
https://github.com/logstash-plugins/logstash-patterns-core/blob/master/patterns/grok-patterns
# 04.测试grok filter
http://grokdebug.herokuapp.com/

# 05.Grok Basics例子
# The syntax for a grok pattern is %{SYNTAX:SEMANTIC}
55.3.244.1 GET /index.html 15824 0.043
%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}


input {
  file {
    path => "/var/log/http.log"
  }
}
filter {
  grok {
    match => { "message" => "%{IP:client} %{WORD:method} %{URIPATHPARAM:request} %{NUMBER:bytes} %{NUMBER:duration}" }
  }
}

	# output
	client: 55.3.244.1
	method: GET
	request: /index.html
	bytes: 15824
	duration: 0.043
# 06.