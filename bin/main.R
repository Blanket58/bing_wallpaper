# preparation
packages<-.packages(all.available = TRUE)
repo <- "https://mirrors.tuna.tsinghua.edu.cn/CRAN/"
if(!any("RCurl" == packages)) install.packages("RCurl",repos = repo)
if(!any("XML" == packages)) install.packages("XML",repos = repo)
if(!any("stringr" == packages)) install.packages("stringr",repos = repo)
if(!any("jsonlite" == packages)) install.packages("jsonlite",repos = repo)
library(jsonlite)
library(RCurl, quietly = TRUE)
library(XML)
library(stringr)
modules<-readLines("../configs/modules.txt") %>% str_split(" +")
modules<-sapply(modules[-c(1,2)],function(x) x[1])
if(!any("pywin32" == modules)) system("pip install pywin32")
message("All dependencies have been successfully installed.\n")

# error class
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    list(message = message, call = call),
    class = c(subclass, "condition"),
    ...
  )
}
error1 <- condition(c("error1", "error"), "Error1: Conflict arguments, please check to be sure that there is only one option at 'true' status at a time.")
error2 <- condition(c("error2", "error"), "Error2: The option 'n_days_ago' will only be activated while option 'current' and option 'random' are at 'false' status.")
error3 <- condition(c("error3", "error"), "Error3: Invalid argument for option 'n_days_ago', it must be a positive integer.")
error4 <- condition(c("error4", "error"), "Error4: Invalid argument for option 'n_days_ago', number out of bound! Try again with a smaller one.")

myExit <- function() {
  for(i in 9:1) {
    cat(sprintf("This process will automatically exit in %s seconds.\r", i))
    Sys.sleep(1)
    flush.console()
  }
  cat("\n")
}

myStop <- function(x) {
  on.exit(myExit())
  stop(x)
}

# read option file
options <- fromJSON("../options.json")
option1 <- options$current %>% as.logical
option2 <- options$random %>% as.logical
option3 <- options$n_days_ago %>% as.integer

# config check
if(option1 && option2) myStop(error1)
if((option1 || option2) && !is.na(option3)) myStop(error2)
if(!is.na(option3)) {if(option3 <= 0) myStop(error3)}
message("Configs check passed.\nProgress begin.\n")

# begin
user_agent <- "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36"
handle <- getCurlHandle(followlocation=TRUE,autoreferer=TRUE,httpheader=list("user-agent"=user_agent))

initialize <- function(class) {
  parsed_doc <- character(0)
  f <- function(url) {
  parsed_doc <<- getURL(url, curl = handle) %>% htmlParse
  }
  structure(f, class = class)
}

crawl <- function(x, ...) {
  UseMethod("crawl")
}

crawl.current <- function(f, url) {
  message("Current mode.\n")
  f(url)
  parsed_doc <- environment(f)$parsed_doc
  xpath <- "//*[@id='bgLink']"
  link <- xpathSApply(parsed_doc, xpath, xmlGetAttr, "href")
  final_link <- paste0(url, link)
  tag_name <- unlist(str_split(part_link,"OHR."))[2] %>% str_split("_")
  tag_name <- unlist(tag_name)[1]
  return(list(final_link, tag_name))
}

crawl.random <- function(f, url) {
  message("Random mode.\n")
  namelist <- readLines("../configs/list.txt") %>% str_extract_all("^[[:alpha:]]+") %>% unlist
  f(url)
  parsed_doc <- environment(f)$parsed_doc
  page_xpath <- "/html/body/div[4]/span"
  total_pages <- xpathSApply(doc = parsed_doc,path = page_xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.integer
  while(TRUE){
    i <- sample(1:total_pages,1)
    url <- paste0("https://bing.ioliu.cn/?p=",i)
    #Random Picture
    parsed_doc <- getURL(url,curl = handle) %>% htmlParse
    xpath_count <- "//div[@class='item']"
    pic.num <- xpathSApply(doc = parsed_doc,path = xpath_count) %>% length
    j <- sample(1:pic.num,1)
    xpath <- paste0("//div[3]/div[",j,"]/div/img/@src")
    original_link <- xpathSApply(doc = parsed_doc,path = xpath) %>% str_split("\"")
    part_link <- str_split(original_link,"_")[[1]][-3]
    tag_name <- str_extract(part_link[1],"[[:alpha:]]+$")
    if(!any(tag_name == namelist)) break
  }
  final_link <- paste(paste(part_link, collapse = "_"), "1920x1080.jpg", sep = "_")
  return(list(final_link, tag_name))
}

crawl.n_days_ago <- function(f, url) {
  message(sprintf("%s days ago mode.\n", option3))
  f(url)
  parsed_doc <- environment(f)$parsed_doc
  pic_num<-ifelse(option3 %% 12 == 0, 12, option3 %% 12)
  page_num<-ifelse(option3 %% 12 == 0, option3 %/% 12, option3 %/% 12 +1)
  xpath<-paste0("//div[3]/div[",pic_num,"]/div/img/@src")
  page_xpath<-"//div[4]/span"
  total_pages <- xpathSApply(doc = parsed_doc,path = page_xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.integer
  if(page_num == 1) {
    original_link<-xpathSApply(doc = parsed_doc,path = xpath) %>% str_split("\"")
    part_link<-str_split(original_link,"_")[[1]][-3]
    tag_name<-str_extract(part_link[1],"[[:alpha:]]+$")
  } else {
    if(page_num <= total_pages){
      url<-paste0("https://bing.ioliu.cn/?p=",page_num)
      parsed_doc<-getURL(url,curl = handle) %>% htmlParse
      original_link<-xpathSApply(doc = parsed_doc,path = xpath) %>% str_split("\"")
      part_link<-str_split(original_link,"_")[[1]][-3]
      tag_name<-str_extract(part_link[1],"[[:alpha:]]+$")
    } else myStop(error4)
  }
  final_link <- paste(paste(part_link, collapse = "_"), "1920x1080.jpg", sep = "_")
  return(list(final_link, tag_name))
}

crawl.n_days_ago_safemode <- function(f, url) {
  message(sprintf("%s days ago SAFE mode.\n", option3))
  time <- floor(as.numeric(Sys.time()) * 1000)
  url_templet <- sprintf("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=%s&n=1&nc=%s&pid=hp", option3, time)
  json <- getURL(url_templet, curl = handle) %>% fromJSON
  part_link <- json[["images"]]$url
  final_link <- paste0(url, part_link)
  tag_name <- unlist(str_split(part_link,"OHR."))[2] %>% str_split("_")
  tag_name <- unlist(tag_name)[1]
  return(list(final_link, tag_name))
}

# run
run <- function(mode, url) {
  mode <- initialize(mode)
  data <- crawl(mode, url)
  raw_pic <- getBinaryURL(data[[1]], curl = handle)
  writeBin(raw_pic, paste0("../pictures/",data[[2]],".jpg"))
  writeBin(raw_pic, "../cache/cache.jpg")
}
url1 <- "https://cn.bing.com"
url2 <- "https://bing.ioliu.cn/?p=1"

{
if(option1)
  run("current", url1)
else if(option2)
  run("random", url2)
else if(option3 < 8)
  run("n_days_ago_safemode", url1)
else
  run("n_days_ago", url2)
}

# call python
system("python ../bin/set.py")
message("Done.\n")
