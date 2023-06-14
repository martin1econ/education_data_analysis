library("tidyverse")
library("readxl")
library("rio")

install.packages("rio")

path_desktop <- file.path("C:", "Users", "Martin", "Desktop")
path_project <- file.path(path_desktop, "R_projects", "projects", "school_report")
path_data_raw <- file.path(path_project, "State_spending_on_kids.xlsx")

empty_list <- list()

empty_list <- import_list(path_data_raw)

print(empty_list[[1]])
