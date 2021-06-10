##### **Automate vaccination briefing** 








**Basic Information**
•	Team – Statistics team 
•	Category – Web scraping/ RAP/Automation 
•	Output – Automated emails everyday with vaccination numbers scraped from the web 

**Analysis specification** 
1.	Scrape vaccination data from 4 different sources 
2.	Run R scrape code through PowerBi Get data 
3.	Publish PowerBi and schedule Get data refreshes everyday 
4.	Set up flow to send out automated emails every day of PowerBi dashboard 

**Data Source specifications** 

| Region | Source link | Scrape type |
| ----- | -------------------------------------------------------------------------------- | ----- |
| England |	https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-vaccinations/ | Download excel link switched to data frame | 
| Northern Ireland |	https://covid-19.hscni.net/	| Text scrape tidied for use |
| Scotland |	https://www.gov.scot/publications/coronavirus-covid-19-daily-data-for-scotland/	| Span/Text scrape tidied for use |
| Wales |	https://public.tableau.com/views/RapidCOVID-19virology-Public/Headlinesummary	| Tableau dashboard JSON elements extracted |

