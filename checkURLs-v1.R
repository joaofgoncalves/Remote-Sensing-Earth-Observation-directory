
library(XML)
library(httr)
library(dplyr)

url <- "http://joaogoncalves.cc/Remote-Sensing-Earth-Observation-directory/"
doc <- htmlParse(url)
links <- xpathSApply(doc, "//a/@href")

links <- links[grepl("http",links)]

statusHTTP <- vector(mode="logical", length=length(links))

pb <- txtProgressBar(min=1,max=length(links),style=3)

for(i in 1:length(links)){
  
  tmp <- try(http_status(GET(links[i]))$category=="Success")
  
  if(inherits(tmp, "try-error")){
    tmp <- FALSE
  }   
  
  statusHTTP[i] <- tmp
  setTxtProgressBar(pb, i)
}

linksStatus <- data.frame(urls=links, status=statusHTTP, stringsAsFactors = FALSE)

linksStatus <- linksStatus %>% arrange(status)

write.csv(linksStatus,"D:/MyDocs/sites/RS_EO_stuff/RS-EO-site_linksStatus-20190216.csv",row.names = FALSE)
