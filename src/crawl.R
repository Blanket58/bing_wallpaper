# preparation
library(yaml, quietly = TRUE)
library(jsonlite, quietly = TRUE)
library(RCurl, quietly = TRUE)
library(XML, quietly = TRUE)
library(stringr, quietly = TRUE)

# error class
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    list(message = message, call = call),
    class = c(subclass, "condition"),
    ...
  )
}
error1 <- condition(c("error1", "error"), "There must be at least one option is true.")
error2 <- condition(c("error2", "error"), "Conflict arguments, please check to be sure that there is only one option is true at one time.")
error3 <- condition(c("error3", "error"), "The option 'n_days_ago' will only be activated when option 'current' and option 'random' are false.")
error4 <- condition(c("error4", "error"), "Invalid argument for option 'n_days_ago', it must be a positive integer.")
error5 <- condition(c("error5", "error"), "Invalid argument for option 'n_days_ago', number out of bound! Try again with a smaller one.")

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

# read config file
config <- read_yaml("config.yaml")

# config check
if(is.logical(config$n_days_ago)) {
  if(!any(unlist(config))) myStop(error1)
  if(sum(unlist(config)) != 1) myStop(error2)
} else if(is.integer(config$n_days_ago) && config$n_days_ago > 0) {
  if(config$current && config$random) myStop(error3)
} else {
  myStop(error4)
}
message("Configs check passed.\nProgress begin.\n")

# begin
handle <- getCurlHandle(
  followlocation = TRUE,
  autoreferer = TRUE,
  httpheader = list(
    "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36",
    "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
    "Accept-Language" = "zh-CN,zh;q=0.9",
    "Connection" = "keep-alive"
))

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
  tag_name <- unlist(str_split(link,"OHR."))[2] %>% str_split("_")
  tag_name <- unlist(tag_name)[1]
  return(list(final_link, tag_name))
}

crawl.random <- function(f, url) {
  message("Random mode.\n")
  namelist <- gsub('.jpg', '', list.files(path = 'pictures', pattern = '*.jpg'))
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
  days <- config$n_days_ago
  message(sprintf("%s days ago mode.\n", days))
  f(url)
  parsed_doc <- environment(f)$parsed_doc
  pic_num <- ifelse(days %% 12 == 0, 12, days %% 12)
  page_num <- ifelse(days %% 12 == 0, days %/% 12, days %/% 12 +1)
  xpath <- paste0("//div[3]/div[",pic_num,"]/div/img/@src")
  page_xpath <- "//div[4]/span"
  total_pages <- xpathSApply(doc = parsed_doc,path = page_xpath,fun = xmlValue) %>% str_extract(" \\d+") %>% as.integer
  if(page_num == 1) {
    original_link <- xpathSApply(doc = parsed_doc,path = xpath) %>% str_split("\"")
    part_link <- str_split(original_link,"_")[[1]][-3]
    tag_name <- str_extract(part_link[1],"[[:alpha:]]+$")
  } else {
    if(page_num <= total_pages){
      url <- paste0("https://bing.ioliu.cn/?p=",page_num)
      parsed_doc <- getURL(url,curl = handle) %>% htmlParse
      original_link <- xpathSApply(doc = parsed_doc,path = xpath) %>% str_split("\"")
      part_link <- str_split(original_link,"_")[[1]][-3]
      tag_name <- str_extract(part_link[1],"[[:alpha:]]+$")
    } else myStop(error5)
  }
  final_link <- paste(paste(part_link, collapse = "_"), "1920x1080.jpg", sep = "_")
  return(list(final_link, tag_name))
}

crawl.n_days_ago_safemode <- function(f, url) {
  message(sprintf("%s days ago SAFE mode.\n", config$n_days_ago))
  time <- floor(as.numeric(Sys.time()) * 1000)
  url_templet <- sprintf("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=%s&n=1&nc=%s&pid=hp", config$n_days_ago, time)
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
  writeBin(raw_pic, paste0("pictures/",data[[2]],".jpg"))
  writeBin(raw_pic, "cache/cache.jpg")
}
url1 <- "https://cn.bing.com"
url2 <- "https://bing.ioliu.cn/?p=1"

{
  if(config$current)
    run("current", url1)
  else if(config$random)
    run("random", url2)
  else if(config$n_days_ago < 8)
    run("n_days_ago_safemode", url1)
  else if(config$n_days_ago >= 8)
    run("n_days_ago", url2)
}

message("Done.")
