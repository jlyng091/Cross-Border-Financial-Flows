
##### Initialisation
library(data.table)
library(shiny)
library(shinydashboard)
library(googleVis)
library(dplyr)
library(tidyr)
library(DT)

# setwd("~/Desktop/NYCDSA/Projects/bank_flows/cbc")
counterparties.df <- fread(file = "./counterparty_accounting.csv")
counterparties.df <- counterparties.df %>% select(-V1)
gdp.df <- fread(file = "./gdp.csv")
gdp.df <- gdp.df %>% select(-V1)

##### Pre-processing percentage data
per_gdp <- counterparties.df %>% select(1, 2, 4, matches("Q4$")) %>%
  gather(key = "Year", value = "Stock.outstanding", -c(1:3))

gdp.df <- gdp.df %>% gather(key = "Year", value = "GDP_2010", -c(1))

gdp_normalised = inner_join(per_gdp, gdp.df, by = c("Counterparty.country", "Year")) %>% 
  mutate(Stock.outstanding = Stock.outstanding * 1000000) %>% 
  mutate(GDP_2010 = GDP_2010 * 1000000000) %>% 
  mutate(basis_points = Stock.outstanding / GDP_2010 * 100 * 100) %>% 
  select(-Stock.outstanding, -GDP_2010) %>% 
  spread(key = "Year", value = "basis_points")

##### Interactive list options
currencies = list(
  "US Dollars" = "USD",
  "Pounds Sterling" = "GBP",
  "Euros" = "EUR",
  "Japanese Yen" = "JPY",
  "Swiss Francs" = "CHF")

positions = list(
  "Claims Denominated In " = "Claims",
  "Liabilities Denominated In " = "Liabilities")

strategic = unique(counterparties.df$Parent.country[!grepl("^Non", counterparties.df$Parent.country) &
                                                      !grepl("^All", counterparties.df$Parent.country) &
                                                      !grepl("^Unalloc", counterparties.df$Parent.country) &
                                                      !grepl("^Consort", counterparties.df$Parent.country)])
strategic = strategic[order(strategic)]
