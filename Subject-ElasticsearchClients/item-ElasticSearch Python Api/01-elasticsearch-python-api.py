# Official low-level client for Elasticsearch
# elasticsearch-py
# http://elasticsearch-py.rtfd.org/
# C:\Users\unicom>pip install elasticsearch
# Successfully installed elasticsearch-5.4.0 urllib3-1.22
from datetime import datetime
from elasticsearch import Elasticsearch

# Thread safety:By default we allow urllib3 to open up to 10 connections to each node, 
# if your application calls for more parallelism, use the maxsize parameter to raise the limit:

# allow up to 25 connections to each node
es = Elasticsearch([
       '192.168.11.73:9200',
       '192.168.11.74:9200',
       '192.168.11.75:9200',
       '192.168.11.76:9200',
       '192.168.11.77:9200'
    ], 
    maxsize=25)

# you can specify to sniff on startup to inspect the cluster and load
# balance across all nodes
es2 = Elasticsearch([
       '192.168.11.73:9200',
       '192.168.11.74:9200',
       '192.168.11.75:9200',
       '192.168.11.76:9200',
       '192.168.11.77:9200'
    ], 
    sniff_on_start=True)

# you can also sniff periodically and/or after failure:
es3 = Elasticsearch([
       '192.168.11.73:9200',
       '192.168.11.74:9200',
       '192.168.11.75:9200',
       '192.168.11.76:9200',
       '192.168.11.77:9200'],
       	 sniff_on_start=True,
         sniff_on_connection_fail=True,
         sniffer_timeout=60)

# SSL client authentication using client_cert and client_key

es4 = Elasticsearch(
    ['192.168.11.73', '192.168.11.74'],
    http_auth=('user', 'secret'),
    # port=443,
    # use_ssl=True,
    # ca_certs='/path/to/cacert.pem',
    # client_cert='/path/to/client_cert.pem',
    # client_key='/path/to/client_key.pem',
)

doc = {
    'author': 'kimchy',
    'text': 'Elasticsearch: cool. bonsai cool.',
    'timestamp': datetime.now(),
}

res = es.index(index="test-index", doc_type='tweet', id=1, body=doc)
print(res['created'])

res = es.get(index="test-index", doc_type='tweet', id=1)
print(res['_source'])

es.indices.refresh(index="test-index")

res = es.search(index="test-index", body={"query": {"match_all": {}}})

print("Got %d Hits:" % res['hits']['total'])

for hit in res['hits']['hits']:
    print("%(timestamp)s %(author)s: %(text)s" % hit["_source"])


es.indices.create(index='test-index', ignore=400)
# ignore 404 and 400
es.indices.delete(index='test-index', ignore=[400, 404])
