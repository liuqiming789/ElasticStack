2017-10-30:
	1.清理索引,磁盘空间不足
	get _cat/indices?v
	delete risklog-2017.10.0*?pretty
	delete risklog-2017.10.1*?pretty

    # 76G   64G  8.5G  89% /app
    # 76G   68G  4.4G  94% /app
    # 76G   61G   11G  85% /app
    # 76G   61G   11G  86% /app
    # 76G   72G   17M 100% /app

    # 76G   27G   46G  37% /app
    # 76G   26G   46G  37% /app
    # 76G   25G   48G  35% /app
    # 76G   38G   34G  53% /app
    # 76G   27G   45G  38% /app

    2.red状态的索引
    get risklog-2017.10.22/_stats?pretty
  	# "_shards": {
    # "total": 10,
    # "successful": 4,
    # "failed": 0
  	# }
    get risklog-2017.10.22/_shard_stores?status=red&pretty
    # shards": "0" node-5 ,"1" node-5,"3" node-5
    get risklog-2017.10.22/_shard_stores?status=green&pretty
    # shards": "2"(node-2 primary,node-4 replica),"4"(node-2 primary,node-3 replica)
    GET risklog-2017.10.22/_recovery?human&pretty
    # 获取上次还原的信息
    GET risklog-2017.10.22/_refresh?pretty

    3.green状态的索引
    get risklog-2017.10.23/_shard_stores?status=green&pretty
    #shards:
    #0:node-1 node-4
    #1:node-1 node-3
    #2:node-1 node-4
    #3:node-1 node-3
    #4:node-1 node-4
