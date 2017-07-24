#-*-coding:utf8-*-
"""
date:20170602
"""
import json
import urllib2
import urllib

class HttpElasticSearch(object):

    def __init__(self, url):
        self.url = url
    
    def search_one_id(self, id_in):
        """
        从es查某id
        """
        fix_url = self.url + "_search"
        data ={"query":{}}
        data["query"]["match"] = {}
        data["query"]["match"]["id"] = id_in
        data = json.dumps(data)
        req = urllib2.Request(fix_url, data)
        req.get_method = lambda:'POST'
        out = json.loads(urllib2.urlopen(req, timeout=1000).read().strip())
        return out

    def search_title_regx(self, title_regx):
        """
        根据title的正则表达式
        查出相应的id
        """
        fix_url = self.url + "_search"
        data = {"query":{}}
        data["query"]["wildcard"] = {}
        data["query"]["wildcard"]["title"] = title_regx
        data["_source"] = ["id", "title"]
        data = json.dumps(data)
        req = urllib2.Request(fix_url, data)
        req.get_method = lambda:'POST'
        out = json.loads(urllib2.urlopen(req, timeout=1000).read().strip())
        return out
    
    def update_one_doc(self, id_in, update_body):
        """
        update_body is a dict:
        like {"viewCount":"5800"}
        """
        res = obj.search_one_id(id_in)
        if "hits" not in res or "hits" not in res["hits"] or "_type" not in res["hits"]["hits"][0]:
            return False 
        type_t = str(res["hits"]["hits"][0]["_type"])
        fix_url = self.url + type_t + "/" + id_in + "/_update"    
        data = {"doc":update_body}
        data = json.dumps(data)
        req = urllib2.Request(fix_url, data)
        req.get_method = lambda:'POST'
        out = json.loads(urllib2.urlopen(req, timeout=1000).read().strip())
        if "_shards" not in out or int(out["_shards"]["successful"]) != int(out["_shards"]["total"]):
            return False
        return True

if __name__ == "__main__":

    obj = HttpElasticSearch("host:port/你自己的索引/")
    #res = obj.search_one_id("docid")    
    #print obj.search_title_regx("Best Surprise*")   
    if obj.update_one_doc("d5b39859b8f4cd0fe01f0116af01a733",{"viewCount":"5900"}):
        print "hihi"