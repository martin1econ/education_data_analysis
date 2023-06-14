### Create ad hoc report creator 
### with gui for customization



library("fredr")
library("WikipediR")
library("officer")

library("dplyr")
library("tidyr")
library("stringr")
library("ggplot2")

#important variables
dmv_area = "Washington–Arlington–Alexandria"

#Paths

path_desktop <- file.path("C:", "Users", "Martin", "Desktop")
path_project <- file.path(path_desktop, "R_projects", "projects")
path_data_raw <- file.path(path_desktop, "R_projects", "raw_data", "school_data")

#API_keys

path_api_key <- file.path(path_project, "FRED_data", "fred_api_key.txt")
api_key <- read_file(path_api_key)

fredr_set_key(api_key)

#Load Dataset

fred_data <- fredr(
  series_id = "GDPALL24031",
  observation_start = as.Date("2005-01-01"),
  observation_end = as.Date("2015-01-01")
)
View(fred_data)

school_data <- read_csv(file.path(path_data_raw, "school_data.csv"), 
                        col_names = TRUE)
View(school_data)

#Initial look 

str(school_data)
school_data_columns <- colnames(school_data)

#select only one year (triplicates for three diff school years)
#some zips are four digits long
#some columns need to be numerical (15-26)
#New columns need to be created with ratios
#need to clean states

#Only grab 21-22 year
print(school_data_columns)

school_data_21_22 <- school_data %>%
  select("School Name", 
         "Location City [Public School] 2021-22",
         "Location State Abbr [Public School] 2021-22",
         "Location ZIP [Public School] 2021-22",
         "Total Students All Grades (Includes AE) [Public School] 2021-22",
         "Free Lunch Eligible [Public School] 2021-22",
         "Reduced-price Lunch Eligible Students [Public School] 2021-22",
         "Full-Time Equivalent (FTE) Teachers [Public School] 2021-22",
         "Male Students [Public School] 2021-22",
         "White Students [Public School] 2021-22",
         "Full-Time Equivalent (FTE) Teachers [Public School] 2021-22" 
         )
school_data_columns <- colnames(school_data_21_22)

str(school_data_21_22)

school_data_21_22[, 5:10] <- sapply(school_data_21_22[, 5:10],as.numeric)

sapply(school_data_21_22, class)

#change column names to something more manageable 
colnames(school_data_21_22) <- c("School_name","Location_city","Location_state",
                                 "Location_zip", "Total_students",
                                 "Free_lunch_eligible",
                                 "Reduced_price_lunch",
                                 "Full_time_staff", "Male_students",
                                 "White_students")
#how many NAs in state 
# seven rows at the end need to be deleted, it is data but metadata info

not_states <- school_data_21_22 %>%
  filter(is.na(Location_state))

#na states are not observations

school_data_21_22 <- school_data_21_22[0:102056,]

invalid_states <- school_data_21_22 %>%
  filter(Location_state == "†")
#states with † don't have any data except for school name, they can be dropped

school_data_21_22 <- school_data_21_22 %>%
  filter(Location_state != "†")

#How many zips have 5 digits vs invalid amount
invalid_zips <- school_data_21_22 %>%
  filter(nchar(Location_zip) < 5)

#research shows that the zipcodes with invalid amount of digits_
#_have leading zeroes that got cut off 
#add them back using stringr

school_data_21_22$Location_zip <- 
  str_pad(school_data_21_22$Location_zip, 5,"left", "0")


#clean location city so that cities have consistent formatting

school_data_21_22$Location_city <- str_to_lower(school_data_21_22$Location_city)

#How many different cities are there 
length(unique(school_data_21_22$Location_city))
length(unique(school_data_21_22$Location_zip))
length(unique(school_data_21_22$Location_state))
## Number of unique cities: 12409
## Number of unique zips: 22143
## Number of states: 50 + district of Culumbia

# Create new ratio columns 


