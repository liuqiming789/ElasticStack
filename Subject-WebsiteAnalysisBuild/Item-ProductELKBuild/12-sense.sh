# /bin/kibana-plugin --install elastic/sense
# bin/kibana plugin -i sense -u file:///app/elk/package/sense-2.0.0-beta7.tar.gz

bin/kibana-plugin help install
bin/kibana-plugin install file:///app/elk/package/sense-2.0.0-beta7.tar.gz

# Retrieving metadata from plugin archive
# Error: end of central directory record signature not found
#     at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:179:14
#     at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:539:5
#     at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/fd-slicer/index.js:32:7
#     at FSReqWrap.wrapper [as oncomplete] (fs.js:682:17)
# Plugin installation was unsuccessful due to error "Error retrieving metadata from plugin archive"

mkdir sense
cp /app/elk/package/sense-2.0.0-beta7.tar.gz .
bin/kibana-plugin install file:///app/elk/kibana-5.5.1-linux-x86_64/sense/sense-2.0.0-beta7.tar.gz

mkdir -p kibana/sense
mv kibana-5.5.1-linux-x86_64/sense/sense-2.0.0-beta7.tar.gz kibana/sense/
../kibana-5.5.1-linux-x86_64/bin/kibana-plugin install file:///app/elk/kibana/sense/sense-2.0.0-beta7.tar.gz

#方向1
gunzip sense-2.0.0-beta7.tar.gz
bin/kibana-plugin install file:///app/elk/kibana/sense/sense-2.0.0-beta7.tar
Retrieving metadata from plugin archive
Error: end of central directory record signature not found
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:179:14
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:539:5
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/fd-slicer/index.js:32:7
    at FSReqWrap.wrapper [as oncomplete] (fs.js:682:17)
Plugin installation was unsuccessful due to error "Error retrieving metadata from plugin archive"

# 方向2
[elk@bjxhm-hadoopelk-76 kibana-5.5.1-linux-x86_64]$ mkdir sense
Retrieving metadata from plugin archive
Error: end of central directory record signature not found
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:179:14
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/yauzl/index.js:539:5
    at /app/elk/kibana-5.5.1-linux-x86_64/node_modules/fd-slicer/index.js:32:7
    at FSReqWrap.wrapper [as oncomplete] (fs.js:682:17)
Plugin installation was unsuccessful due to error "Error retrieving metadata from plugin archive"

