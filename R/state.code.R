# a funciton to fill in state codes
#' A function to fill in iso3c codes for Mexico's states.
#' 
#' @param x a character vector of state names or numeric state codes
#' @param drop.state Drops the state column after inserting the `geocodes` column. \code{TRUE} by default.


state.code <- function(x) {
  
  x <- tolower(x)
  dictionary = dictionary
  dictionary$state <- tolower(dictionary$state)
  
  key = match(x, dictionary$state)
  
  x$geocode = dictionary$geocode[key]
  
  # pos = which(is.na(key))
  
  # x$code[pos]
  

  return(x) }



