rm(list=ls())
setwd("D:/bing_autowallpaper-master/bing_autowallpaper-master/pictures")
packages<-.packages(all.available=T)
if(!("RCurl" %in% packages)) install.packages("RCurl")
if(!("XML" %in% packages)) install.packages("XML")
if(!("stringr" %in% packages)) install.packages("stringr")
library(RCurl)
library(XML)
library(stringr)
namelist<-readLines("../configs/list.txt") %>% str_extract_all("^[[:alpha:]]+") %>% unlist
#Random Page
url<-"https://bing.ioliu.cn/?p=1"
parsed.doc<-getURL(url) %>% htmlParse
page.xpath<-"/html/body/div[4]/span"
n<-xpathSApply(doc = parsed.doc,path = page.xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.numeric
while(TRUE){
  i<-sample(1:n,1)
  url<-paste0("https://bing.ioliu.cn/?p=",i)
  #Random Picture
  parsed.doc<-getURL(url) %>% htmlParse
  xpath.count<-"//div[@class='item']"
  photo.num<-xpathSApply(doc = parsed.doc,path = xpath.count) %>% length
  j<-sample(1:photo.num,1)
  xpath<-paste0("/html/body/div[3]/div[",j,"]/div/img/@src")
  original.link<-xpathSApply(doc = parsed.doc,path = xpath) %>% str_split("\"")
  part.link<-str_split(original.link,"_")[[1]][-3]
  tag.name<-str_extract(part.link[1],"[[:alpha:]]+$")
  if(!(tag.name %in% namelist)) break
}
size<-"1920x1200.jpg"
final.link<-paste(paste(part.link,collapse = "_"),size,sep = "_")
jpgfile<-getBinaryURL(final.link)
writeBin(jpgfile,paste0(tag.name,".jpg"))
writeBin(jpgfile,"../cache/1.jpg")
#preparations for python
modules<-readLines("../configs/modules.txt") %>% str_split(" +")
modules<-sapply(modules[-c(1,2)],function(x) x[1])
if(!("pywin32" %in% modules)) system("pip install pywin32")
file.remove("../configs/modules.txt")
