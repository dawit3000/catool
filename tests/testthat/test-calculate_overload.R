test_that("Output columns are correct", {
  result <- calculate_overload_compensation(example_data, 1000)
  expect_true(all(c("ROW_AMOUNT", "TYPE", "AMOUNT") %in% names(result)))
})
