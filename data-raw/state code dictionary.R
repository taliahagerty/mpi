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

# and the ISO codes themselves

tmp <- dictionary %>%
  select(geocode, state.iep) %>%
  distinct()

tmp <- data.frame(state = tmp$geocode,
                  geocode = tmp$geocode,
                  state.iep = tmp$state.iep)

dictionary <- rbind(dictionary, tmp)

# 6. add the state names copied from the 2019 FF data

state <- c("aguascalientes",      "baja california" ,   "baja california sur",
           "campeche"           , "coahuila"        ,   "colima"             ,
           "chiapas"             ,"chihuahua"       ,   "ciudad de mexico"   ,
            "durango"           ,  "guanajuato"     ,    "guerrero"           ,
            "hidalgo"           ,  "jalisco"        ,    "mexico"             ,
            "michoacan"       ,    "morelos"        ,    "nayarit"            ,
            "nuevo leon"      ,    "oaxaca"         ,    "puebla"             ,
            "queretaro"       ,    "quintana roo"   ,    "san luis potosi"    ,
            "sinaloa"           ,  "sonora"         ,    "tabasco"            ,
            "tamaulipas"      ,    "tlaxcala"       ,    "veracruz"           ,
            "yucatan"           ,  "zacatecas"  )


tmp <- data.frame(state, 
                  geocode = mpi.state.codes$code[1:32],
                  state.iep = mpi.state.codes$state.new[1:32])

dictionary <- rbind(dictionary, tmp) 
dictionary <- dplyr::distinct(dictionary)

# 7. add the state names copied from the GTD

tmp <- tribble(
  ~state, ~geocode, ~state.iep,
  "federal", "DIF", "Ciudad de México",
  "guerrero ", "GRO", "Guerrero",
  "mexican federal district", "DIF", "Ciudad de México",
  "mexico city federal district", "DIF", "Ciudad de México",
  "federal district", "DIF", "Ciudad de México",
  "veracruz ", "VER", "Veracruz",
  "oaxaca ", "OAX", "Oaxaca",
  "quintana", "ROO", "Quintana Roo",
  "nuevo leon ", "NLE", "Nuevo León",
  "queretaro ", "QUE", "Querétaro",
  "m,xico", "MEX",  "Estado de México")

dictionary <- rbind(dictionary, tmp) 
dictionary <- dplyr::distinct(dictionary)


# 8. add the state names copied from the Lantia and Etellekt

tmp <- tribble(
  ~state, ~geocode, ~state.iep,
  "edomex", "MEX",  "Estado de México",
  "cdmx",   "DIF",  "Ciudad de México",
  "q. roo", "ROO" , "Quintana Roo",
  "chih"  , "CHH",   "Chihuahua",
  "dgo" ,      "DUR",       "Durango",
  "coah",      "COA",      "Coahuila",
  "tamps",     "TAM",    "Tamaulipas",
  "mich" ,     "MIC",     "Michoacán",        
  "chis",      "CHP",       "Chiapas",
  "camp",      "CAM",      "Campeche",
  "vera cruz", "VER",      "Veracruz",
  "nl",        "NLE",    "Nuevo León",
  "gto",       "GUA",    "Guanajuato",         
  "qr",        "ROO",  "Quintana Roo",
  "qro",       "ROO",  "Quintana Roo")  
  
dictionary <- rbind(dictionary, tmp) 
dictionary <- dplyr::distinct(dictionary)


# use the data in state.code()

usethis::use_data(dictionary, internal = T, overwrite = T)
