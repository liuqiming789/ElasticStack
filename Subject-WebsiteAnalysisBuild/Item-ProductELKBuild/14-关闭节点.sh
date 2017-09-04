关闭节点的API允许关闭集群中的一个或多个（或者全部）节点。下面是一个关闭 _local 节点的例子：
$ curl -XPOST 'http://localhost:9200/_cluster/nodes/_local/_shutdown' 
也可以通过各自的节点ID来关闭指定的节点（或者像这里说明 的别的选项）:
$ curl -XPOST 'http://localhost:9200/_cluster/nodes/nodeId1,nodeId2/_shutdown' 
集群的主节点也可以使用下面的方法来关闭：
$ curl -XPOST 'http://localhost:9200/_cluster/nodes/_master/_shutdown' 
最后，可以使用如下的任意一种方法来关闭所有的节点：
$ curl -XPOST 'http://localhost:9200/_shutdown' $ curl -XPOST 'http://localhost:9200/_cluster/nodes/_shutdown' $ curl -XPOST 'http://localhost:9200/_cluster/nodes/_all/_shutdown' 
延迟
默认情况下，关闭命令会延迟1秒(1s)之后执行。可以通过设置 delay 参数 来指定延迟的时间。比如：
$ curl -XPOST 'http://localhost:9200/_cluster/nodes/_local/_shutdown?delay=10s' 
禁用关闭命令
关闭的API可以通过设置节点里的 action.disable_shutdown 选项来禁用

curl -XPOST 'http://192.168.11.73:9200/_cluster/nodes/node-1/_shutdown'
curl -XPOST 'http://192.168.11.73:9200/_cluster/nodes/_local/_shutdown'


Nodes shutdownedit
The _shutdown API has been removed. Instead, setup Elasticsearch to run as a service
 (see Install Elasticsearch with RPM, Install Elasticsearch with Debian Package, or Install Elasticsearch with Windows MSI Installer) 
 or use the -p command line option to write the PID to a file.
