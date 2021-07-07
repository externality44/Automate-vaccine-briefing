library(magrittr)
library(tidyverse)
library(polite)
library(rvest)
library(lubridate)

##Scotland data 
url2 <- "https://www.gov.scot/publications/coronavirus-covid-19-daily-data-for-scotland/"
scot_bow <- polite::bow(url2)

tryCatch({
  message("Scraping latest Scotland vaccination statistics")
  
  page = read_html(url2)
  xpath = "/html/body/div[2]/article/div[3]/div/div/div[2]/div/div/ul[1]/li[6]"
  
  scot_scrape <- rvest::html_nodes(page, xpath = xpath) %>% 
                  rvest::html_text() 
  
  doses <- scot_scrape %>% stringr::str_remove_all(",") %>%  # formatting to extract the vaccination number
             stringr::str_split(" ", simplify = TRUE) %>% #splitting makes it easier to lift numbers
               stringr::str_subset("\\d+") %>% #extracting digits
                 as.numeric() # lifting both as numbers
  
  first_dose <- doses[1]  ###assigning the vaccination numbers to correct names 
  second_dose <- doses[2]  
  
  ##scraping publication date 
  page = read_html(url2)
  datexpath = "/html/body/div[2]/article/div[3]/div/div/div[2]/div/div/h2" 
  
  scrape_date <- html_node(page, xpath=datexpath) %>%
                  html_text() %>% str_split(pattern = " ") %>% 
                  unlist() %>% stringr::str_extract("^[0-9]+") %>% na.omit()
  
  pub_date <- paste0(scrape_date[1],"-", 
                     lubridate::month(Sys.Date()), "-", 
                     lubridate::year(Sys.Date())) %>% 
              lubridate::dmy()
  
  
  scotland <- data.frame(Region = "Scotland") %>%
               mutate("1st dose" = first_dose, #putting it all in a data frame
                       "2nd dose" = second_dose, 
                        "Total doses" = sum(doses), 
                          "Publication_date" = pub_date) 
  
})

if(!file.exists('data/scot_vaccine.csv')){
    write.csv(scotland, 'data/scot_vaccine.csv', row.names = FALSE) 
    } else {
  # Later: append to existing CSV
  write.table(scotland, 'data/scot_vaccine.csv',
              row.names = FALSE, col.names = FALSE,
              sep = ",", append = TRUE)
           }
