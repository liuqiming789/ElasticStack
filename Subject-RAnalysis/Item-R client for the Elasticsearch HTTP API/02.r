#https://github.com/ropensci/elastic
install.packages("elastic")
install.packages("devtools")
devtools::install_github("ropensci/elastic")
library('elastic')
connect(es_host = "172.28.11.167", es_user="elastic", es_pwd = "changeme", es_port = 9200)
Search(index = "dcsid-2017.08.03",size = 1)$hits$hits
