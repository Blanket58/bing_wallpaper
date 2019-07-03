library(shiny, quietly = TRUE)
library(shinyjs, quietly = TRUE, warn.conflicts = FALSE)
library(RCurl, quietly = TRUE, warn.conflicts = FALSE)
library(XML, quietly = TRUE)
library(stringr, quietly = TRUE)

handle <- getCurlHandle(
  followlocation = TRUE,
  autoreferer = TRUE,
  httpheader = list(
    "User-Agent" = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.109 Safari/537.36",
    "Accept" = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3",
    "Accept-Language" = "zh-CN,zh;q=0.9",
    "Connection" = "keep-alive"
))

parsed_doc <- getURL("https://bing.ioliu.cn/?p=1", curl = handle) %>% htmlParse
links <- xpathSApply(parsed_doc, "//div[3]/*/div/img", xmlGetAttr, "src")
page <- xpathSApply(parsed_doc, "//div[4]/span", xmlValue)
page_now <- str_extract(page, "^\\d+") %>% as.integer
page_total <- str_extract(page, "\\d+$") %>% as.integer

for(i in 1:12) {
  assign(paste0("url",i), links[i])
}
opts <- list(filename = "templet.html",
             url1 = url1,
             url2 = url2,
             url3 = url3,
             url4 = url4,
             url5 = url5,
             url6 = url6,
             url7 = url7,
             url8 = url8,
             url9 = url9,
             url10 = url10,
             url11 = url11,
             url12 = url12,
             page = page)


# UI---------------------

ui <- shinyUI(fluidPage(
  useShinyjs(),
  do.call(htmlTemplate, args = opts)
))

# server-----------------

server <- shinyServer(function(input, output, session) {
  page_jump <- function(action, page_now) {
    base_url <- "https://bing.ioliu.cn/?p="
    if(page_now == 1) {
      url <- paste0(base_url, switch(action, back = page_now, forward = page_now + 1))
    } else if(page_now == page_total) {
      url <- paste0(base_url, switch(action, back = page_now - 1, forward = page_now))
    } else {
      url <- paste0(base_url, switch(action, back = page_now - 1, forward = page_now + 1))
    }
    parsed_doc <- getURL(url, curl = handle) %>% htmlParse
    links <<- xpathSApply(parsed_doc, "//div[3]/*/div/img", xmlGetAttr, "src")
    page <<- xpathSApply(parsed_doc, "//div[4]/span", xmlValue)
    page_now <<- str_extract(page, "^\\d+") %>% as.integer
    page_total <<- str_extract(page, "\\d+$") %>% as.integer
  }

  observeEvent(input$last_url, {
    page_jump("back", page_now)
    for(i in 1:12) {
      runjs(sprintf("document.getElementById('url%s').src = '%s';", i, links[i]))
    }
    html("page", page)
  })
  observeEvent(input$next_url, {
    page_jump("forward", page_now)
    for(i in 1:12) {
      runjs(sprintf("document.getElementById('url%s').src = '%s';", i, links[i]))
    }
    html("page", page)
  })
  onStop(function() stopApp())
})

shinyApp(ui,server)
