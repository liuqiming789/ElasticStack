curl -XGET 'http://192.168.11.73:9200/_cluster/state?pretty'
curl -XGET 'http://192.168.11.74:9201/_cluster/state?pretty'
curl -XGET 'http://192.168.11.75:9202/_cluster/state?pretty'
##三个节点,端口要不要设置成9200,值得商榷

一.安装elastic-head
git clone git://github.com/mobz/elasticsearch-head.git
cd elasticsearch-head
npm install
npm run start
http://localhost:9100/
