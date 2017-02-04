### Exercise 1 ###

# Load the httr and jsonlite libraries for accessing data
library("jsonlite")
library("httr")
library("dplyr")

## For these questions, look at the API documentation to identify the appropriate endpoint and information.
## Then send GET() request to fetch the data, then extract the answer to the question
response <- GET("http://data.unhcr.org/api/stats/time_series_years.json")
# For what years does the API have statistical data?
body <- content(response, "text")
years <- fromJSON(body)
years

# What is the "country code" for the "Syrian Arab Republic"?
country.response <- GET("http://data.unhcr.org/api/countries/list.json")
country.body <- content(country.response, "text")
country.codes <- fromJSON(country.body)
is.data.frame(country.codes)
country.codes <- filter(country.codes, name_en == "Syrian Arab Republic") %>% 
  select(country_code)
country.codes

# How many persons of concern from Syria applied for residence in the USA in 2013?
# Hint: you'll need to use a query parameter
# Use the `str()` function to print the data of interest
# See http://www.unhcr.org/en-us/who-we-help.html for details on these terms
query.params <- list(country_of_residence = "USA", country_of_origin = "SYR", year = 2013)
response <- GET("http://data.unhcr.org/api/stats/persons_of_concern.json", query = query.params)
usa.from.syr <- fromJSON(content(response, "text"))
str(usa.from.syr)

## And this was only 2013...


# How many *refugees* from Syria settled the USA in all years in the data set (2000 through 2013)?
# Hint: check out the "time series" end points
query.params <- list(population_type_code = "RF", country_of_residence = "USA", country_of_origin = "SYR")
response <- GET("http://data.unhcr.org/api/stats/time_series_all_years.json", query = query.params)
refugee.us <- fromJSON(content(response, "text"))
View(refugee.us)
refugee.us <- select(refugee.us, year, usa = value)

# Use the `plot()` function to plot the year vs. the value.
# Add `type="o"` as a parameter to draw a line
plot(refugee.us, type = "o")

# Pick one other country in the world (e.g., Turkey).
# How many *refugees* from Syria settled in that country in all years in the data set (2000 through 2013)?
# Is it more or less than the USA? (Hint: join the tables and add a new column!)
# Hint: To compare the values, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`
query.params <- list(population_type_code = "RF", country_of_residence = "CAN", country_of_origin = "SYR")
response <- GET("http://data.unhcr.org/api/stats/time_series_all_years.json", query = query.params)
refugee.can <- fromJSON(content(response, "text"))
View(refugee.can)
refugee.can <- select(refugee.can, year, can = value)
plot(refugee.can, type = "o")

us.can.refugees <- left_join(refugee.us, refugee.can, by = "year") %>% 
  mutate(usa = as.numeric(usa), can = as.numeric(can)) %>% 
  mutate(usa.greater = usa > can)
View(us.can.refugees)

## Bonus (not in solution):
# How many of the refugees in 2013 were children (between 0 and 4 years old)?
query.params <- list()

## Extra practice (but less interesting results)
# How many total people applied for asylum in the USA in 2013?
# - You'll need to filter out NA values; try using `is.na()`
# - To calculate a sum, you'll need to convert the data (which is a string) to a number; try using `as.numeric()`


## Also note that asylum seekers are not refugees
