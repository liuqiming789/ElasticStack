#Stable version from CRAN

install.packages("elastic")

#
#--- 在此連線階段时请选用CRAN的鏡子 ---
#还安装相依关系‘mime’, ‘openssl’, ‘R6’, ‘httr’, ‘curl’, ‘jsonlite’
#
#下载的二进制程序包在
#        C:\Users\unicom\AppData\Local\Temp\RtmpUbTEvJ\downloaded_packages里
-------------------------------------------------------------------------
#Development version from GitHub

install.packages("devtools")

#还安装相依关系‘memoise’, ‘whisker’, ‘digest’, ‘rstudioapi’, ‘git2r’, ‘withr’

devtools::install_github("ropensci/elastic")


#> devtools::install_github("ropensci/elastic")
#Downloading GitHub repo ropensci/elastic@master
#from URL https://api.github.com/repos/ropensci/elastic/zipball/master
#Installing elastic
#"C:/software/R/R-3.3.2/bin/x64/R" --no-site-file --no-environ --no-save --no-restore --quiet CMD INSTALL  \
#  "C:/Users/unicom/AppData/Local/Temp/RtmpOQesSw/devtools8146e361f07/ropensci-elastic-4cf739c" --library="C:/software/R/R-3.3.2/library" --install-tests 
#
#* installing *source* package 'elastic' ...
#** R
#** inst
#** tests
#** preparing package for lazy loading
#** help
#*** installing help indices
#** building package indices
#** installing vignettes
#** testing if installed package can be loaded
#*** arch - i386
#*** arch - x64
#* DONE (elastic)

-----------------------------------------------------------------------------
library('elastic')
-----------------------------------------------------------------------------
一.
1.链接
connect(es_port = 9200)

2.使用x-pack
connect(es_host = "172.28.11.167", es_path = "", es_user="elastic", es_pwd = "changeme", es_port = 9200, es_transport_schema  = "https")

#修改1

connect(es_host = "172.28.11.167", es_user="elastic", es_pwd = "changeme", es_port = 9200)

Search(index = "dcsid-2017.08.03",size = 1)$hits$hits