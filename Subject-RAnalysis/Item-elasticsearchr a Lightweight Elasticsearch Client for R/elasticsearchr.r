#https://cran.r-project.org/web/packages/elasticsearchr/vignettes/quick_start.html

devtools::install_github("alexioannides/elasticsearchr")

es <- elastic("http://172.28.11.167:9200", "elastic", "changeme")

for_everything <- query('{
  "match_all": {}
}')

elastic("http://172.28.11.167:9200", "elastic", "changeme") %search% for_everything
这是另外一个包