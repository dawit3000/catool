library(testthat)
library(dplyr)
library(OverloadCompTool)

test_that("Output columns are correct", {
  # Define a minimal test dataset
  example_data <- tibble::tibble(
    HRS = c(3, 3, 4),
    ENRLD = c(10, 5, 2),
    INSTRUCTOR = c("Smith, John", "Smith, John", "Smith, John")
  )

  # Run the function
  result <- calculate_overload_compensation(
    example_data,
    L = 3,
    U = 9,
    rate_per_cr = 1000,
    reg_load = 6
  )

  # Print the result to inspect columns
  print(result)

  # Define the expected columns based on the function's output
  expected_columns <- c(
    "HRS", "ENRLD", "INSTRUCTOR", "Overload Pay by Course", "Summary", "Total Compensation (USD)"
  )

  # Check if all expected columns are present (accounting for possible name shortening or formatting differences)
  actual_columns <- names(result)

  # Ensure the expected columns are in the result, considering possible slight name changes
  expect_true(all(expected_columns %in% actual_columns),
              info = paste("Expected columns:", paste(expected_columns, collapse = ", "),
                           "\nActual columns:", paste(actual_columns, collapse = ", ")))
})
