# 09-elastic mapping
一.
1.映射: 创建索引的时候,预先定义字段的类型和相关属性
2.作用:使用索引建立更加完善和细致
3.分类:静态映射和动态映射
4.创建索引的时候,默认为指定了类型.
5.可以定义字段的属性:

二.可以定义的类型:
1.string,integer,long,float,double,date,boolean,binary

三.映射属性的方法
1.store:yes or on,不存储.
2.index:analyzed,not_analyzed,no 是否索引和分析
3.null_value:如果是空,设置默认值
4.boost:设置字段的权值,优先级.默认1.0
5.index_analyzer:设置一个索引时用的分析器
5.search_analyzer:搜索时候的分析器
6.analyzer:
	默认stardard分词器
	whitespace分析器
	simple分析器
	english分析器
7.include_in_all=false默认是ture,则不被索引到

8.index_name:定义字段的名称

四.动态映射:
1.文档中没有出现此过的字段,自动决定其类型,并且给字段添加映射
2.通过dynamic属性进行控制
3.true,false,strict三个值
4.type:"object"类型
五.例子
"mappings":{
	"类型":{
		"properties":{
			"列":{"type":"String","index"}
		}
	}
}


五.管理映射:
1.查看
get /索引/_mapping

2.查看类型的映射
get /索引/_mapping/类型

3.获取所有
get /_all/_mapping

4.更新
(1)现在索引起别名
PUT /索引/_aliases/别名A

5.删除
delete /索引/类型/_mapping 
delete /索引/_mapping 类型
