#' Start the full data pipeline
#'
#' This function connects to the database, fetches the list of symbols,
#' downloads new OHLCV data from Yahoo Finance in batches,
#' filters out already existing data, inserts the new data into the database,
#' and logs each batch processing result.
#'
#' @param from A Date indicating the start date for historical data (default: 7 days ago).
#' @param to A Date indicating the end date for historical data (default: today).
#' @param batch_size An integer indicating how many symbols to fetch per batch (default: 25).
#'
#' @return Nothing. Runs the full data pipeline.
#' @export
start_pipeline <- function(from = Sys.Date() - 7, to = Sys.Date(), batch_size = 25) {

  con <- connect_db()

  message("Connection to database established ✅")

  # Fetch tickers assigned to the user
  batch_indices <- fetch_symbols(con)

  if (nrow(batch_indices) == 0) {
    stop("No symbols available for this user.")
  }

  message(glue::glue("Fetched {nrow(batch_indices)} symbols."))

  summary_table <- build_summary_table()

  batches <- split_batch(batch_indices, batch_size)

  user_login <- Sys.getenv("user_login")

  start_time <- Sys.time()

  message("Starting pipeline...")

  batch_counter <- 1

  for (batch in batches) {

    message(glue::glue("\nProcessing batch {batch_counter}/{length(batches)}: {paste(batch$symbol, collapse = ', ')}"))

    tryCatch({

      new_data <- yahoo_query_data(
        batch_list = batch,
        from = from,
        to = to,
        retry = FALSE
      )

      if (is.null(new_data) || nrow(new_data) == 0) {
        message("No data returned for batch.")
        summary_table <- log_summary(summary_table, batch, 0, "error", "No data retrieved.")
      } else {
        push_new_data(con, new_data)
        summary_table <- log_summary(summary_table, batch, nrow(new_data), "ok", "Data pushed successfully.")
      }

    }, error = function(e) {
      message(glue::glue("Error while processing batch {batch_counter}: {e$message}"))
      summary_table <- log_summary(summary_table, batch, 0, "error", e$message)
    })

    Sys.sleep(sample(1:2, 1))  # Random small sleep to avoid API throttling
    batch_counter <- batch_counter + 1
  }

  end_time <- Sys.time()
  elapsed_time <- round(difftime(end_time, start_time, units = "mins"), 2)

  message(glue::glue("\nPipeline finished in {elapsed_time} minutes."))

  # Push the full summary table into the database
  push_summary_table(con, summary_table)

  DBI::dbDisconnect(con)

  message("Disconnected from database. ✅")

  invisible(NULL)
}
