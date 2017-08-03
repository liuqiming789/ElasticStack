警告: posh-git support for PowerShell 2.0 is deprecated; you have version 2.0.
To download version 5.0, please visit https://www.microsoft.com/en-us/download/details.aspx?id=50395
For more information and to discuss this, please visit https://github.com/dahlbyk/posh-git/issues/163
To suppress this warning, change your profile to include 'Import-Module posh-git -Args $true'.
E:\GitHub> d:
D:\> cd .\installtools\ELK_ElasticStack
D:\installtools\ELK_ElasticStack> git clone git://github.com/mobz/elasticsearch-head.git
remote: Counting objects: 4067, done.
Cloning into 'elasticsearch-head'...
remote: Total 4067 (delta 0), reused 0 (delta 0), pack-reused 4067
Receiving objects: 100% (4067/4067), 2.10 MiB | 207.00 KiB/s, done.
Resolving deltas: 100% (2224/2224), done.



h4. Enable CORS in elasticsearch

When not running as a plugin of elasticsearch (which is not even possible from version 5) you must enable "CORS":http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-http.html in elasticsearch otherwise your browser will rejects requests which appear insecure.

In elasticsearch configuration;

* add @http.cors.enabled: true@
* you must also set @http.cors.allow-origin@ because no origin allowed by default. @http.cors.allow-origin: "*"@ is valid value, however it's considered as a security risk as your cluster is open to cross origin from *anywhere*.


h4. Basic Authentication

elasticsearch-head will add basic auth headers to each request if you pass in the "correct url parameters":#url-parameters
You will also need to add @http.cors.allow-headers: Authorization@ to the elasticsearch configuration

h4. x-pack

elasticsearch x-pack requires basic authentication _and_ CORS as described above. Make sure you have the correct CORS setup and then open es-head with a url like "http://localhost:9100/?auth_user=elastic&auth_password=changeme"


访问方法:
file:///D:/installtools/ELK_ElasticStack/elasticsearch-head/index.html?auth_user=elastic&auth_password=changeme

