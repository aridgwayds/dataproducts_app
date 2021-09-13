# Data Products
# Coursera 9/7/2021
# Week 4 Project - A. Ridgway
# global.r file for shiny app: Weather Events

library(dplyr);library(readr);library(stringr)
library(NLP);library(tm);library(wordcloud2);library(Rcpp)
library(tidyr);library(tidyverse);library(lubridate)
library(shiny);
corp_fn<-function(txtcol){
        corp <- VCorpus(VectorSource(txtcol))
        corp <- tm_map(corp, function(x) removePunctuation(x, preserve_intra_word_contractions = FALSE, preserve_intra_word_dashes = TRUE,ucp = FALSE,))
        corp <- tm_map(corp, content_transformer(tolower))
        corp <- tm_map(corp, removeNumbers)
        corp <- tm_map(corp, function(x)removeWords(x,stopwords(kind="SMART")))
}
matrix_fn<-function(corp){
        term.matrix <- TermDocumentMatrix(corp)
        term.matrix <- as.matrix(term.matrix)
        v<-sort(rowSums(term.matrix), decreasing = TRUE)
        d<-data.frame(word=names(v),freq=v) 
        #d<-d %>% filter(!grepl("\\W[A-z]",word)) %>% arrange(desc(freq))
        d<-d %>% arrange(desc(freq))
        #%>% mutate(rank_word=rank(desc(freq),ties.method="first"))
}

data_fn<-function(df,state){
        dataf<- df %>% filter(STATE==state)
}

url<-"https://www.ncei.noaa.gov/pub/data/swdi/stormevents/csvfiles/StormEvents_details-ftp_v1.0_d2019_c20210803.csv.gz"
df_raw = read_csv(url)
df_raw<-df_raw[,c(1,2,9,10,11,12,13,21,22,23,24,49,50)]
#data<-df_raw[,1:11]
# databk<-data
# data<-databk

data<- df_raw %>% mutate(date=as.Date(gsub(" ","",paste(str_sub(as.character(BEGIN_YEARMONTH),1,4),"-",str_sub(as.character(BEGIN_YEARMONTH),-2),"-",as.character(BEGIN_DAY)),"%Y-%m-%d")),
                       injuries=INJURIES_DIRECT+INJURIES_INDIRECT,
                       fatalities=DEATHS_DIRECT+DEATHS_INDIRECT,
                       harm=injuries+fatalities,
                       event=str_trim(str_to_lower(EVENT_TYPE))) %>%
        select("date","event","STATE","injuries","fatalities","harm") %>%
        filter(harm>0)

data<-data %>% 
        mutate(event=gsub(" ","-",event)) %>%
        mutate(event=gsub("/",",",event))

states<-sort(unique(data$STATE))


