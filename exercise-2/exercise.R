### Exercise 2 ###

# Load the httr and jsonlite libraries for accessing data
library("httr")
library("jsonlite")
library("dplyr")

# Create a `base.uri` variable that holds the base uri. You wil then paste endpoints to this base.
base.uri <- "https://api.spotify.com"


## As you may have noticed, it often takes multiple queries to retrieve the desired information.
## This is a perfect situation in which writing a function will allow you to better structure your
## code, and give a name to a repeated task!


# Define a function `TopTrackSearch` that takes in an artist name as an argument,
# and returns the top 10 tracks (in the US) by that artist
TopTrackSearch <- function(artist) {
  artist.endpoint <- paste("/v1/artists/", artist, "/top-tracks", sep = "")
  body <- GET(paste(base.uri, artist.endpoint, sep = ""))
  return(body)
}



# What are the top 10 tracks by Beyonce?
TopTrackSearch("beyonce")

# Use the `flatten` function to flatten the data.frame -- note what differs!


# Use the `save()` function to save the flattened data frame to a file `beyonce.Rdata`


# Use your `dplyr` functions to get the number of the songs that appear on each album



### Bonus ###
# Write a function that allows you to specify a search type (artist, album, etc.), and a string,
# that returns the album/artist/etc. page of interest


# Search albums with the word "Sermon"
