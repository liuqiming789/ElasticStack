#10-elastic查询
一.查询
1.
基本查询:
组合查询:
过滤查询:

二.基本查询
(一)
1.指定索引和类型的搜索
get /index/type/_search?q="title:easy in perl"

2.没有index和type的搜索
get /_search?q="title:easy in perl"

(二)term查询:
可以查询某个字段里有多个关键字匹配的文档

1.term查询
get /index/type/_search
{
	"query":{
		"terms":{
			"title":{"easy in perl","easy in python"},
			"minmum_match":2
		}
	}
}

2.控制查询返回的数量
from 和 size相当msyql limit
get /index/type/_search
{	
	"from":1,
	"size":2
	"query":{
		"terms":{
			"title":{"easy in perl","easy in python"},
		}
	}
}


3.返回版本号:
get /index/type/_search
{	
	"version":true
	"query":{
		"terms":{
			"title":{"easy in perl","easy in python"},
		}
	}
}

(三)match查询
match查询给定字段会给分析器,terms查询没有

1.
get /index/type/_search
{	
	"query":{
		"match":{
			"title":{"easy in perl","easy in python"},
		}
	}
}

2.matich_all

get /index/type/_search
{	
	"query":{
		"match_all":{}
	}
}

3.match_phrase查询
slop定义关键字之间,间隔多少未知单词 
get /index/type/_search
{	
	"query":{
		"match_phrase":{
			"title":{"easy in perl","easy in python"},
			"slop":2
		}
	}
}

(四)指定返回字段
1.fields
2.partical_fields:{
	partial:{
		include:[],
		exclude:[]
	}
}

(五)排序
sort:{
	{
		fields:{order:"asc"}
	}

(六)前缀匹配

(七)控制范围
