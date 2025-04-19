test_that("split_batch() returns a list", {
  df <- tibble::tibble(symbol = letters[1:10], index_ts = 1:10)
  batches <- split_batch(df, batch_size = 3)
  expect_type(batches, "list")
})

test_that("split_batch() divides data into correct number of batches", {
  df <- tibble::tibble(symbol = letters[1:10], index_ts = 1:10)
  batches <- split_batch(df, batch_size = 3)
  expect_equal(length(batches), ceiling(nrow(df) / 3))
})

test_that("split_batch() handles batch_size larger than dataset", {
  df <- tibble::tibble(symbol = letters[1:5], index_ts = 1:5)
  batches <- split_batch(df, batch_size = 10)
  expect_equal(length(batches), 1)
})

test_that("split_batch() returns tibbles inside list", {
  df <- tibble::tibble(symbol = letters[1:6], index_ts = 1:6)
  batches <- split_batch(df, batch_size = 2)
  expect_true(all(purrr::map_lgl(batches, tibble::is_tibble)))
})
