# 08-elasticsearch版本控制

一.版本控制:
	1.a用户 get -1,put +1
	2.b用户 get -1,put +1
	3.线程控制.

二.悲观锁和乐观锁
	1.悲观锁:
		发生并发冲突,屏蔽一切可能违法数据完整性的操作;
		影响并发量.
	2.乐观锁:
		只是在提交操作的时候检查是否违反数据完成性.
		会更改失败,返回失败.
三.elastic实现乐观锁

	1.内部版本控制:	_vertion自增长,修改数据之后,_vertion会自动增加1


	2.外部版本控制:
	(1)oracle数据同步到elastic
	(2)为了宝成_version与外部版本控制的数值一致,使用version_type=external
		检查数据当前的version值是否小于请求中的version
		