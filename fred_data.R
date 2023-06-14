library("fredr")
library("WikipediR")
library("officer")

library("dplyr")
library("tidyr")
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

school_data <- read_csv(file.path(path_data_raw, "school_data.csv"))
View(school_data)


#Initial look 

str(school_data)
school_data_columns <- colnames(school_data)

#some zips are four digits long
#some columns need to be numerical (15-26)
#New columns need to be created with ratios
print(school_data[1:3,22])
print(15:26)

school_data[school_data_columns[15:26]] <- sapply(school_data[school_data_columns[15:26]],as.numeric)
sapply(school_data, class)

#How many zips have 5 digits vs 4 digits vs less, missing leading zero

x <- school_data %>%
  group_by(length(school_data[,9])) %>%
  summarise(count = count())


