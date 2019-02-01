rm(list=ls())
setwd("D:/bing_autowallpaper/bing_autowallpaper/Pictures")
packages<-.packages(all.available=T)
if(!("RCurl" %in% packages)){install.packages(RCurl)}
if(!("XML" %in% packages)){install.packages(XML)}
if(!("stringr" %in% packages)){install.packages(stringr)}
library(RCurl)
library(XML)
library(stringr)
#Random Page
url<-"https://bing.ioliu.cn/?p=1"
parsed.doc<-getURL(url) %>% htmlParse
page.xpath<-"/html/body/div[4]/span"
n<-xpathSApply(doc = parsed.doc,path = page.xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.numeric
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
size<-"1920x1200.jpg"
final.link<-paste(paste(part.link,collapse = "_"),size,sep = "_")
jpgfile<-getBinaryURL(final.link)
writeBin(jpgfile,paste0(tag.name,".jpg"))
setwd("D:/bing_autowallpaper/bing_autowallpaper/cache")
writeBin(jpgfile,"1.jpg")
