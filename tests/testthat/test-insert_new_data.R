test_that("insert_new_data() inserts rows successfully", {
  con <- connect_db()

  # Create fake small dataset matching table structure
  fake_data <- tibble::tibble(
    index_ts = rep("FAKE_INDEX_TS", 2),
    date = Sys.Date() + 0:1,
    metric = c("close", "volume"),
    value = c(150.25, 1000000)
  )

  # Try inserting
  result <- insert_new_data(con = con, new_data = fake_data)
  expect_true(result)

  # Clean up: delete the inserted test data
  schema <- Sys.getenv("PG_SCHEMA")
  DBI::dbExecute(con, glue::glue_sql(
    "DELETE FROM {`schema`}.data_sp500 WHERE index_ts = 'FAKE_INDEX_TS'",
    .con = con
  ))

  DBI::dbDisconnect(con)
})


test_that("insert_new_data() fails gracefully with invalid data", {
  con <- connect_db()

  # Create incomplete dataset (missing required columns)
  bad_data <- tibble::tibble(
    date = Sys.Date(),
    value = 123.45
  )

  expect_error(
    insert_new_data(con, bad_data),
    regexp = ".*"
  )

  DBI::dbDisconnect(con)
})
