library(magrittr)
library(tidyverse)
library(polite)
library(rvest)
library(readxl)
library(lubridate)

#polite scraping 
url <- "https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-vaccinations/"
eng_bow <- polite::bow(url)

tryCatch({
  message("Scraping latest England vaccination statistics")
  today <- toString(lubridate::day(lubridate::today()))
    
  eng_scrape <- 
    polite::scrape(eng_bow) %>% 
    rvest::html_nodes("a") %>% # Find all links
    rvest::html_attr("href") %>% # Extract the urls
    stringr::str_subset("COVID-19-daily") %>% #only get the daily files 
    stringr::str_subset(today) # Pull the first file (latest)
  
  filename <- basename(eng_scrape) #get file name
  
  # Download latest file 
  for(i in 1:length(eng_scrape)){
    if(!file.exists(paste0(filename[i]))){
      download.file(paste0(eng_scrape[i], sep=""),
                    paste(dest = filename[i], sep=""), 
                    mode = 'wb')}}
})

#getting publication date out 
pub_date <- readxl::read_excel(path=paste0(filename[i]), range = "C7", col_names = FALSE) %>%
                             .[[1]] %>% lubridate::dmy()

#giving consistent column names 
names <- c("Region", "", "1st dose", "2nd dose","", "Total doses")
eng_vacc <- readxl::read_xlsx(path=paste0(filename[i]),
                              range = "B14:G22", col_names = names) %>% 
                    dplyr::select("Region", "1st dose", "2nd dose", "Total doses")%>%
                    dplyr::mutate(Publication_date = pub_date) %>%
                    na.omit() 

if(!file.exists('data/eng_vaccine.csv')){
  write.csv(eng_vacc, 'data/eng_vaccine.csv', row.names = FALSE) 
} else {
  # Later: append to existing CSV
  write.table(eng_vacc, 'data/eng_vaccine.csv',
              row.names = FALSE, col.names = FALSE,
              sep = ",", append = TRUE)
}
