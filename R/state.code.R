# a funciton to fill in state codes
#' A function to fill in iso3c codes for Mexico's states.
#' 
#' @param x dataframe with a column of state names called \code{state}
#' @param drop.state Drops the state column after inserting the `geocodes` column. \code{TRUE} by default.


state.code <- function(x, state, drop.state = T) {
  
  x$state <- tolower(x$state)
  dictionary = dictionary
  dictionary$state <- tolower(dictionary$state)
  
  key = match(x$state, dictionary$state)
  
  x$geocode = dictionary$geocode[key]
  
  # pos = which(is.na(key))
  
  # x$code[pos]
  
  
  if(drop.state == T) {
    x <- x %>% select(-state)
  }
  
  return(x) }



