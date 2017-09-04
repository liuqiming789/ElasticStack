1 数据映射
2 内存策略
3 模板设置
4 磁盘控制
5 性能测试

1.1 

分片:一个index下面一个type
ll /app/elk/elastic/elastic_data/nodes/0/indices/0uZP2dVOSIqt6KejIi7plA/

drwxr-xr-x 5 elk develop 4096 Aug 23 15:21 3
drwxr-xr-x 5 elk develop 4096 Aug 23 15:21 4
drwxr-xr-x 2 elk develop 4096 Aug 30 14:33 _state

drwxr-xr-x 5 elk develop 4096 Aug 23 15:17 1
drwxr-xr-x 5 elk develop 4096 Aug 23 15:17 2
drwxr-xr-x 2 elk develop 4096 Aug 30 14:33 _state

drwxr-xr-x 5 elk develop 4096 Aug 23 15:17 3
drwxr-xr-x 5 elk develop 4096 Aug 23 15:17 4
drwxr-xr-x 2 elk develop 4096 Aug 30 14:33 _state

drwxr-xr-x 5 elk develop 4096 Aug 30 14:23 0
drwxr-xr-x 5 elk develop 4096 Aug 30 14:15 1
drwxr-xr-x 2 elk develop 4096 Aug 30 14:33 _state

drwxr-xr-x 5 elk develop 4096 Aug 30 14:33 0
drwxr-xr-x 5 elk develop 4096 Aug 30 14:23 2
drwxr-xr-x 2 elk develop 4096 Aug 30 14:33 _state

1.2 准实时原理
1.2.1
lucene把每次生成的倒续索引交segment,然后一个commite文件记录索引内的所有segment,segment
存放来自in-memory buffer的数据;segment刷新到文件系统缓存
elasticsearch的内存不要超过30G;

1.2.2
默认1s间隔.调用/_refresh接口刷缓存中;

1.2.3 磁盘同步的translog控制
segment从文件系统缓存刷新到磁盘,然后commit 
清空translog
默认30分钟,512M阈值
主动调度/_flush接口



