rm(list=ls())
packages<-.packages(all.available=T)
if(!("RCurl" %in% packages)) install.packages("RCurl")
if(!("XML" %in% packages)) install.packages("XML")
if(!("stringr" %in% packages)) install.packages("stringr")
if(!("yaml" %in% packages)) install.packages("yaml")

### Error handle
library(yaml)
options<-unlist(read_yaml("../options.yaml"))
judge1<-options["current"] %in% c(1,TRUE)
judge2<-options["previous.random"] %in% c(1,TRUE)
n_days_ago<-as.numeric(options["previous.n_days_ago"])
if(!isTRUE(judge1) && !isTRUE(judge2) && (is.na(options["previous.n_days_ago"]) || n_days_ago != as.integer(n_days_ago) || n_days_ago <= 0)){
  cat("Warning:\nInappropriate configuration of file 'options.yaml'.\nPlease check manually.\nThis process will automatically exit in 5 seconds.")
  Sys.sleep(5)
}else{
  cat("Configs check passed.\nProgress begin.\n")
  library(RCurl)
  library(XML)
  library(stringr)
  user_agent<-"Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
  handle<-getCurlHandle(followlocation=TRUE,autoreferer=TRUE,httpheader=list("user-agent"=user_agent))
  namelist<-readLines("../configs/list.txt") %>% str_extract_all("^[[:alpha:]]+") %>% unlist  

  ## Current
  if(judge1){
    cat("Use today's image.\n")
    url<-"https://cn.bing.com"
    parsed.doc<-getURL(url,curl = handle) %>% htmlParse
    xpath<-"//*[@id='bgLink']"
    link<-xpathSApply(parsed.doc,xpath,xmlGetAttr,"href")
    final.link<-paste0(url,link)
    tag.name<-unlist(str_split(link,"&rf="))[2] %>% str_split("_")
    tag.name<-unlist(tag.name)[1]
  }else{
    cat("Use previous images.\n")
  }  

  ## Previous
  # Random
  if(judge1==FALSE && judge2){
    url<-"https://bing.ioliu.cn/?p=1"
    parsed.doc<-getURL(url,curl = handle) %>% htmlParse
    page.xpath<-"/html/body/div[4]/span"
    n<-xpathSApply(doc = parsed.doc,path = page.xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.numeric
    while(TRUE){
      i<-sample(1:n,1)
      url<-paste0("https://bing.ioliu.cn/?p=",i)
      #Random Picture
      parsed.doc<-getURL(url,curl = handle) %>% htmlParse
      xpath.count<-"//div[@class='item']"
      photo.num<-xpathSApply(doc = parsed.doc,path = xpath.count) %>% length
      j<-sample(1:photo.num,1)
      xpath<-paste0("//div[3]/div[",j,"]/div/img/@src")
      original.link<-xpathSApply(doc = parsed.doc,path = xpath) %>% str_split("\"")
      part.link<-str_split(original.link,"_")[[1]][-3]
      tag.name<-str_extract(part.link[1],"[[:alpha:]]+$")
      if(!(tag.name %in% namelist)) break
    }
  }

  # n_days_ago
  if(judge1==FALSE && judge2==FALSE){
    pic_num<-ifelse(n_days_ago %% 12 == 0,12,n_days_ago %% 12)
    page_num<-ifelse(n_days_ago %% 12 == 0,n_days_ago %/% 12,n_days_ago %/% 12 +1)
    url<-"https://bing.ioliu.cn/?p=1"
    parsed.doc<-getURL(url,curl = handle) %>% htmlParse
    xpath<-paste0("//div[3]/div[",pic_num,"]/div/img/@src")
    page.xpath<-"//div[4]/span"
    n<-xpathSApply(doc = parsed.doc,path = page.xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.numeric
    if(page_num == 1){
      original.link<-xpathSApply(doc = parsed.doc,path = xpath) %>% str_split("\"")
      part.link<-str_split(original.link,"_")[[1]][-3]
      tag.name<-str_extract(part.link[1],"[[:alpha:]]+$")
    }else{
      if(page_num <= n){
        url<-paste0("https://bing.ioliu.cn/?p=",page_num)
        parsed.doc<-getURL(url,curl = handle) %>% htmlParse
        original.link<-xpathSApply(doc = parsed.doc,path = xpath) %>% str_split("\"")
        part.link<-str_split(original.link,"_")[[1]][-3]
        tag.name<-str_extract(part.link[1],"[[:alpha:]]+$")
      }else{
        cat("Warning!\nNumber out of bound! Try again with a smaller one.")
        Sys.sleep(5)
      }
    }
  }

  # Download
  size<-"1920x1080.jpg"
  final.link<-ifelse(exists("final.link"),final.link,paste(paste(part.link,collapse = "_"),size,sep = "_"))
  jpgfile<-getBinaryURL(final.link)
  writeBin(jpgfile,paste0("../pictures/",tag.name,".jpg"))
  writeBin(jpgfile,"../cache/cache.jpg")  

  # Preparations for python
  modules<-readLines("../configs/modules.txt") %>% str_split(" +")
  modules<-sapply(modules[-c(1,2)],function(x) x[1])
  if(!("pywin32" %in% modules)) system("pip install pywin32")
  system("python ../bin/set.py")
  cat("Done.\n")
}
