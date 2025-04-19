#' Insert new stock data into the database
#'
#' This function inserts new stock data into the student's data_sp500 table inside their schema.
#' It automatically removes duplicates (already existing date/index_ts/metric) before inserting.
#'
#' @param con A valid DBI database connection.
#' @param new_data A tibble matching the table structure.
#'
#' @return The number of rows actually inserted.
#' @export
insert_new_data <- function(con, new_data) {

  if (missing(con) || missing(new_data)) {
    stop("Both 'con' and 'new_data' must be provided.")
  }

  schema <- Sys.getenv("PG_SCHEMA")

  # Load already existing combinations
  existing <- DBI::dbGetQuery(con, glue::glue_sql(
    "SELECT date, index_ts, metric FROM {`schema`}.data_sp500",
    .con = con
  ))

  # Prepare new_data (long format expected already)
  new_data_prepared <- new_data |>
    dplyr::semi_join(
      tibble::as_tibble(existing) |>
        dplyr::distinct(date, index_ts, metric),
      by = c("date", "index_ts", "metric")
      , negate = TRUE)  # Keep only rows NOT already existing

  if (nrow(new_data_prepared) == 0) {
    message("No new rows to insert.")
    return(0)
  }

  # Insert
  DBI::dbWriteTable(
    conn = con,
    name = DBI::Id(schema = schema, table = "data_sp500"),
    value = new_data_prepared,
    append = TRUE,
    row.names = FALSE
  )

  message(glue::glue("{nrow(new_data_prepared)} new rows inserted into {schema}.data_sp500"))

  return(nrow(new_data_prepared))
}
