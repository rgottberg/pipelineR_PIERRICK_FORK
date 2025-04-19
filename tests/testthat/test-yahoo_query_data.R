test_that("yahoo_query_data() returns a tibble when valid symbols provided", {
  batch_list <- tibble::tibble(symbol = c("AAPL"), index_ts = c("AAPL_Index"))
  result <- yahoo_query_data(batch_list, from = Sys.Date() - 10, to = Sys.Date(), retry = FALSE)
  expect_s3_class(result, "tbl_df")
})

test_that("yahoo_query_data() returns NULL when invalid symbol provided", {
  batch_list <- tibble::tibble(symbol = c("INVALIDTICKER123"), index_ts = c("INVALID_Index"))
  result <- suppressWarnings(
    yahoo_query_data(batch_list, from = Sys.Date() - 10, to = Sys.Date(), retry = FALSE)
  )
  expect_true(is.null(result) || nrow(result) == 0)
})


test_that("yahoo_query_data() columns are correct when data is returned", {
  batch_list <- tibble::tibble(symbol = c("AAPL"), index_ts = c("AAPL_Index"))
  result <- yahoo_query_data(batch_list, from = Sys.Date() - 10, to = Sys.Date(), retry = FALSE)

  if (!is.null(result) && nrow(result) > 0) {
    expected_cols <- c("date", "open", "high", "low", "close", "volume", "close_adjusted", "symbol", "index_ts", "source")
    expect_true(all(expected_cols %in% colnames(result)))
  } else {
    succeed()
  }
})
