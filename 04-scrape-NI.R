library(magrittr)
library(tidyverse)
library(polite)
library(rvest)
library(lubridate)

##NI 
url4 <- "https://covid-19.hscni.net/"
NI_bow <- polite::bow(url4)

page = read_html(url4)
xpath = "/html/body/div[4]/div/div[2]"

NI_scrape <- html_node(page, xpath=xpath) %>%
              html_text() %>% str_remove_all("\n") %>% #getting the text
              str_squish() #removing extra whitespace

Doses <- NI_scrape %>% str_split(pattern = "[0-9]$ [A-Za-z]") %>% unlist()

total_doses <- Doses %>% #extracting the numbers then the specific number for relevant dose
  stringr::str_extract_all("[0-9,]+") %>% .[[1]] %>% .[1]

first_dose <- Doses %>% #extracting the numbers then the specific number for relevant dose
  stringr::str_extract_all("[0-9,]+") %>% .[[1]] %>% .[4]

second_dose <- Doses %>% #extracting the numbers then the specific number for relevant dose
  stringr::str_extract_all("[0-9,]+") %>% .[[1]] %>% .[6]


#scraping the last updated date 
datexpath = "/html/body/div[4]/div/div[3]"

scrape_date <- html_node(page, xpath=datexpath) %>%
                  html_text() %>% str_split(pattern = " ") %>% unlist() %>% 
                    stringr::str_extract("^[0-9]+$") %>% na.omit()

scrape_month <- html_node(page, xpath=datexpath) %>%
                  html_text() %>% str_split(pattern = " ") %>% unlist() %>% 
                    stringr::str_extract("[A-Za-z]+") %>% 
                      stringr::str_extract("January|February|March|April|May|June|
                                           July|August|September|October|November|December") %>% na.omit 

pub_date <- paste0(scrape_date,"-", 
                   match(scrape_month, month.name), "-", 
                     lubridate::year(Sys.Date())) %>% lubridate::dmy()  ##this will need updating in the new year 

NI <- data.frame(Region = "Northern Ireland") %>%
                  mutate("1st dose" = first_dose, #putting it all in a data frame
                         "2nd dose" = second_dose, 
                         "Total doses" = total_doses, 
                         "Publication_date" = pub_date) 

if(!file.exists('data/NI_vaccine.csv')){
  write.csv(NI, 'data/NI_vaccine.csv', row.names = FALSE) 
} else {
  # Later: append to existing CSV
  write.table(NI, 'data/NI_vaccine.csv',
              row.names = FALSE, col.names = FALSE,
              sep = ",", append = TRUE)
}
