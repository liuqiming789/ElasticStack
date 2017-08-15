curl -XGET 'http://192.168.11.73:9200/_cluster/state?pretty'
curl -XGET 'http://192.168.11.74:9200/_cluster/state?pretty'
curl -XGET 'http://192.168.11.75:9200/_cluster/state?pretty'
##三个节点,端口要不要设置成9200,值得商榷

一.安装elastic-head


tar xvJf node-v6.11.2-linux-x64.tar.xz
export PATH=$PATH:/app/elk/node-v6.11.2-linux-x64/bin


git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
npm install
npm run start
http://192.168.11.73:9100/
http://192.168.11.73:9200/_plugin/head/

注1:
Removing /app/elk/elasticsearch-head/node_modules/phantomjs-prebuilt/lib/phantom
Copying extracted folder /tmp/phantomjs/phantomjs-2.1.1-linux-x86_64.tar.bz2-extract-1502416329498/phantomjs-2.1.1-linux-x86_64 -> /app/elk/elasticsearch-head/node_modules/phantomjs-prebuilt/lib/phantom
Writing location.js file
Done. Phantomjs binary available at /app/elk/elasticsearch-head/node_modules/phantomjs-prebuilt/lib/phantom/bin/phantomjs
elasticsearch-head@0.0.0 /app/elk/elasticsearch-head


注2:
[elk@bjxhm-hadoopelk-76 elasticsearch-head]$ npm run start

> elasticsearch-head@0.0.0 start /app/elk/elasticsearch-head
> grunt server


Running "connect:server" (connect) task
Waiting forever...
Started connect web server on http://localhost:9100



curl -XGET 'http://192.168.11.73:9200/_cluster/state?pretty'
curl -XGET 'http://192.168.11.74:9201/_cluster/state?pretty'
curl -XGET 'http://192.168.11.75:9202/_cluster/state?pretty'


注3:

tar -xvJf node-v6.11.2-linux-x64.tar.xz 
export PATH=$PATH:/app/elk/node-v6.11.2-linux-x64/bin/
cd /app/elk/elasticsearch-head/
npm install
npm run start
npm run proxy

[elk@bjxhm-hadoopelk-74 elasticsearch-head]$ npm run start

> elasticsearch-head@0.0.0 start /app/elk/elasticsearch-head
> grunt server

Running "connect:server" (connect) task
Waiting forever...
Started connect web server on http://localhost:9100


[elk@bjxhm-hadoopelk-74 elasticsearch-head]$ npm run proxy

> elasticsearch-head@0.0.0 proxy /app/elk/elasticsearch-head
> node proxy/index.js

creating proxy localhost:9200
	remote: http://localhost:9200
	local:  http://localhost:9101




注4:
npm config delete proxy


GET localhost:9200 /
GET localhost:9200 /_cluster/state
GET localhost:9200 /_stats
GET localhost:9200 /_nodes/stats
GET localhost:9200 /_nodes
GET localhost:9200 /_cluster/health
GET localhost:9200 /_cluster/state
GET localhost:9200 /_all
GET localhost:9200 /_cluster/health
GET localhost:9200 /_nodes
GET localhost:9200 /_nodes/stats
GET localhost:9200 /_stats
GET localhost:9200 /_all

