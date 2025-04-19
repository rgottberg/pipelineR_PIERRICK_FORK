test_that("log_summary() adds one row to summary_table", {
  summary_table <- build_summary_table()
  batch_id <- 1
  symbol <- "AAPL"
  updated_table <- log_summary(summary_table, batch_id, symbol, status = "ok", n_rows = 2, message = "Batch processed.")
  expect_equal(nrow(updated_table), 1)
})

test_that("log_summary() keeps correct column names", {
  summary_table <- build_summary_table()
  batch_id <- 1
  symbol <- "AAPL"
  updated_table <- log_summary(summary_table, batch_id, symbol, status = "ok", n_rows = 2, message = "Batch processed.")
  expected_cols <- c("batch_id", "symbol", "status", "n_rows", "message", "timestamp")
  expect_equal(colnames(updated_table), expected_cols)
})

test_that("log_summary() correctly stores provided values", {
  summary_table <- build_summary_table()
  batch_id <- 1
  symbol <- "AAPL"
  updated_table <- log_summary(summary_table, batch_id, symbol, status = "error", n_rows = 5, message = "Something went wrong.")

  expect_equal(updated_table$batch_id[1], 1)
  expect_equal(updated_table$symbol[1], "AAPL")
  expect_equal(updated_table$status[1], "error")
  expect_equal(updated_table$n_rows[1], 5)
  expect_equal(updated_table$message[1], "Something went wrong.")
})
