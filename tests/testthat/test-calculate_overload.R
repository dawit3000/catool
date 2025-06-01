library(testthat)
library(dplyr)
library(catool)

test_that("ol_comp returns all expected output columns", {
  # Define a test dataset including COURSE
  example_data <- tibble::tibble(
    COURSE = c("ENG101", "ENG102", "ENG103"),
    HRS = c(3, 3, 4),
    ENRLD = c(10, 5, 2),
    INSTRUCTOR = c("Smith, John", "Smith, John", "Smith, John")
  )

  # Run ol_comp
  result <- ol_comp(
    instructor_schedule = example_data,
    L = 3,
    U = 9,
    rate_per_cr = 1000,
    reg_load = 6
  )

  # Define expected column names
  expected_columns <- c(
    "COURSE", "HRS", "ENRLD", "INSTRUCTOR",
    "QUALIFIED_CR", "ROW_AMOUNT", "TYPE", "SUMMARY"
  )

  # Check that all expected columns are in the result
  expect_true(all(expected_columns %in% names(result)),
              info = paste(
                "Missing columns:\n",
                paste(setdiff(expected_columns, names(result)), collapse = ", ")
              ))
})
