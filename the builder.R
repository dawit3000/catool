#----STEP 1: Step 1: Set Up the Package Structure
install.packages(c("usethis", "devtools"))
library(usethis)
library(devtools)

create_package("OverloadCompTool")  # choose your desired path

# Then inside the package
usethis::use_git()             # optional but recommended
usethis::use_readme_rmd()
usethis::use_mit_license("Your Name")
usethis::use_package("dplyr")
usethis::use_package("tibble")
usethis::use_package("lubridate")
usethis::use_package("stringr")
usethis::use_testthat()

#  -------------Step 2: Add Your Main Function(s)
# Then document and load
devtools::document()
devtools::load_all()
