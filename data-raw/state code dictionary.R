## code to prepare and edit the state code dictionary

options(stringsAsFactors = F)

# 1. start w the old wide form codebook we used in prior years

mpi.state.codes <- read.csv("./data-raw/mpi.state.codes.csv")

# 2. names of states is list Harry made of all the state name versions,
# including the weird R translation output

names.of.states <- read.csv("./data-raw/names of states.csv")

# 3. make a simple dictionary from these tables

library(dplyr)
dictionary <- names.of.states %>%
  left_join(mpi.state.codes, by = "state.long") %>%
  select(state.x, code, state.new) %>%
  rename(state = state.x,
         geocode = code,
         state.iep = state.new) %>%
  filter(state != "State") # random row in here


# 4. fill in some NAs

national <- c("National", "United States of Mexico")
mex.state <- c("Mexico state")


dictionary$geocode <- ifelse(dictionary$state %in% national, "National", dictionary$geocode) 
dictionary$geocode <- ifelse(dictionary$state %in% mex.state, "MEX", dictionary$geocode) 

dictionary$state.iep <- ifelse(dictionary$geocode == "National", "National", dictionary$state.iep)
dictionary$state.iep <- ifelse(dictionary$geocode == "MEX", "Estado de México", dictionary$state.iep)


# 5. add INEGI's numeric codes

tmp <- data.frame(state = mpi.state.codes$inegi.code,
                  geocode = mpi.state.codes$code,
                  state.iep = mpi.state.codes$state.new) %>%
  filter(complete.cases(.)) # this has some NAs at the bottom from region rows



dictionary <- rbind(dictionary, tmp)

# 6. use the data in state.code()

usethis::use_data(dictionary, internal = T, overwrite = T)
