D:\installtools\ELK_ElasticStack\elasticsearch-5.4.3\bin>elasticsearch-plugin.bat list
license
WARNING: plugin [license] is incompatible with version [5.4.3]; was designed for version [2.4.4]
x-pack

D:\installtools\ELK_ElasticStack\elasticsearch-5.4.3\bin>elasticsearch-plugin.bat remove license
-> removing [license]...


[2017-08-02T15:08:07,230][WARN ][o.e.b.ElasticsearchUncaughtExceptionHandler] [etk-1] uncaught exception in thread [main]
org.elasticsearch.bootstrap.StartupException: java.lang.IllegalArgumentException: plugin [license] is incompatible with version [5.4.3]; was designed
for version [2.4.4]
        at org.elasticsearch.bootstrap.Elasticsearch.init(Elasticsearch.java:127) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.bootstrap.Elasticsearch.execute(Elasticsearch.java:114) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.cli.EnvironmentAwareCommand.execute(EnvironmentAwareCommand.java:67) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.cli.Command.mainWithoutErrorHandling(Command.java:122) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.cli.Command.main(Command.java:88) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:91) ~[elasticsearch-5.4.3.jar:5.4.3]
        at org.elasticsearch.bootstrap.Elasticsearch.main(Elasticsearch.java:84) ~[elasticsearch-5.4.3.jar:5.4.3]

        