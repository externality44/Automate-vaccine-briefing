##vaccination run script 
library(magrittr)
library(tidyverse)
library(polite)
library(stringr)
library(rvest)
library(rjson)
library(httr)
library(readxl)

#running all the web scraping R files 
#each file appends to a csv for that region 
source("01-scrape-eng.R")
source("02-scrape-scot.R")
source("03-scrape-wales.R")
source("04-scrape-NI.R")
