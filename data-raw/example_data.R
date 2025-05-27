## code to prepare `example_data` dataset goes here

# Step 1: Read the CSV file
schedule <- read.csv("data-raw/schedule.csv")

# Step 2: Save it as an R data object
usethis::use_data(schedule, overwrite = TRUE)
