# a funciton to fill in state codes
# dictionary is cached from ./munge/00-state name dictionary.R

state.code <- function(x, drop.state = T) {
  
  x$state <- tolower(x$state)
  dictionary = dictionary
  dictionary$state <- tolower(dictionary$state)
  
  key = match(x$state, dictionary$state)
  
  x$geocode = dictionary$code[key]
  
  # pos = which(is.na(key))
  
  # x$code[pos]
  
  
  if(drop.state == T) {
    x <- x %>% select(-state)
  }
  
  return(x) }


