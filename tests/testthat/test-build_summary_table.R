test_that("build_summary_table() returns a tibble", {
  summary_table <- build_summary_table()
  expect_s3_class(summary_table, "tbl_df")
})

test_that("build_summary_table() has correct column names", {
  summary_table <- build_summary_table()
  expected_cols <- c("batch_id", "symbol", "status", "n_rows", "message", "timestamp")
  expect_equal(colnames(summary_table), expected_cols)
})

test_that("build_summary_table() returns empty tibble", {
  summary_table <- build_summary_table()
  expect_equal(nrow(summary_table), 0)
})
