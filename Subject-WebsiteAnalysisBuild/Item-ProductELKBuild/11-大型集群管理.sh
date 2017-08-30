https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html

Tribe node
A tribe node, configured via the tribe.* settings, is a special type of coordinating only node that can connect to multiple clusters and perform search and other operations across all connected clusters.
By default a node is a master-eligible node and a data node, plus it can pre-process documents through ingest pipelines. This is very convenient for small clusters but, as the cluster grows, it becomes important to consider separating dedicated master-eligible nodes from dedicated data nodes.

部落节点，通过部落来配置。*设置是一种特殊的协调节点，它可以连接到多个集群，并在所有连接的集群上执行搜索和其他操作。
默认情况下，一个节点是一个合格的节点和一个数据节点，而且它可以通过ingest管道预处理文档。这对于小集群非常方便，但是，随着集群的发展，考虑将专用的主节点从专用的数据节点分离出来变得非常重要。

A tribe node, configured via the tribe.* settings, is a special type of coordinating only node that can connect to multiple clusters and perform search and other operations across all connected clusters.

##################################################################################
https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-tribe.html

The tribe node works by retrieving the cluster state from all connected clusters and merging them into a global cluster state. With this information at hand, it is able to perform read and write operations against the nodes in all clusters as if they were local. Note that a tribe node needs to be able to connect to each single node in every configured cluster.

tribe:
    t1: 
        cluster.name:   cluster_one
    t2: 
        cluster.name:   cluster_two


The tribe node will create a node client to connect each cluster using unicast discovery by default
Any other settings for the connection can be configured under tribe.{name}, just like the cluster.name in the example.
The merged global cluster state means that almost all operations work in the same way as a single cluster: distributed search, suggest, percolation, indexing, etc.

The merged view cannot handle indices with the same name in multiple clusters. By default it will pick one of them, see later for on_conflict options.
Master level read operations (eg Cluster State, Cluster Health) will automatically execute with a local flag set to true since there is no master.\

Master level write operations (eg Create Index) are not allowed. These should be performed on a single cluster.

The tribe node can be configured to block all write operations and all metadata operations with:

tribe:
    blocks:
        write:    true
        metadata: true
The tribe node can also configure blocks on selected indices:

tribe:
    blocks:
        write.indices:    hk*,ldn*
        metadata.indices: hk*,ldn*

 This can be configured using the tribe.on_conflict setting. It defaults to any, but can be set to drop (drop indices that have a conflict), or prefer_[tribeName] to prefer the index from a specific tribe.


 path.scripts:   some/path/to/config 
network.host:   192.168.1.5 

tribe:
  t1:
    cluster.name:   cluster_one
  t2:
    cluster.name:   cluster_two
    network.host:   10.1.2.3 


The path.scripts setting is inherited by both t1 and t2.



The network.host setting is inherited by t1.



The t3 node client overrides the inherited from the tribe node

