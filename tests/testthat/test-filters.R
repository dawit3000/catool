library(testthat)
library(dplyr)
library(catool)

test_that("get_instructor_schedule handles partial and case-insensitive matches", {
  df <- tibble(
    INSTRUCTOR = c("Smith, John", "LEE, Sarah", "Jones, Emily"),
    ENRLD = c(10, 8, 12),  # required for internal arrange()
    HRS = c(3, 3, 3)       # required by other functions
  )

  expect_equal(nrow(get_instructor_schedule("smith", df)), 1)
  expect_equal(nrow(get_instructor_schedule("LEE", df)), 1)
  expect_equal(nrow(get_instructor_schedule("emily", df)), 1)
  expect_warning(get_instructor_schedule("Not Found", df))
})

test_that("get_subject_schedule supports regex filtering", {
  df <- tibble(
    SUBJ = c("CSCI", "MATH", "STAT", "ENGL"),
    ENRLD = c(10, 15, 20, 12),  # required if filtered data gets arranged
    HRS = c(3, 3, 3, 3)         # add for completeness
  )

  expect_equal(nrow(get_subject_schedule("^MATH|^STAT", df)), 2)
  expect_equal(nrow(get_subject_schedule("csci", df)), 1)
  expect_warning(get_subject_schedule("XYZ", df))
})


test_that("filter_schedule applies multiple filters", {
  df <- tibble(
    INSTRUCTOR = c("Smith, John", "Smith, Jane", "Lee, Mike"),
    SUBJ = c("MATH", "STAT", "NURS"),
    ENRLD = c(14, 9, 7),
    HRS = c(3, 3, 3)
  )

  expect_equal(nrow(filter_schedule(df, subject_pattern = "MATH")), 1)
  expect_equal(nrow(filter_schedule(df, instructor_pattern = "Smith")), 2)
  expect_equal(nrow(filter_schedule(df, subject_pattern = "NURS", instructor_pattern = "Lee")), 1)
})
