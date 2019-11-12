# check R packages
packages <- .packages(all.available = TRUE)
repo <- 'https://mirrors.tuna.tsinghua.edu.cn/CRAN/'
if(!any('RCurl' == packages)) install.packages('RCurl', repos = repo)
if(!any('XML' == packages)) install.packages('XML', repos = repo)
if(!any('stringr' == packages)) install.packages('stringr', repos = repo)
if(!any('jsonlite' == packages)) install.packages('jsonlite', repos = repo)
if(!any('shiny' == packages)) install.packages('shiny', repos = repo)
if(!any('shinyjs' == packages)) install.packages('shinyjs', repos = repo)

# check py modules
library(stringr)
modules<-readLines('configs/modules.txt') %>% str_split(' +')
modules<-sapply(modules[-c(1,2)], function(x) x[1])
if(!any('pywin32' == modules)) system('pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pywin32')

message('Done!\n')
for(i in 3:1) {
  cat(sprintf("This process will automatically exit in %s seconds.\r", i))
  Sys.sleep(1)
  flush.console()
}
