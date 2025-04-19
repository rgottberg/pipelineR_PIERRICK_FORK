#' Log the result of processing a batch
#'
#' This function adds a new row to the summary table with details about the batch processing.
#'
#' @param summary_table The current summary table (a tibble).
#' @param batch_id The batch number.
#' @param symbol The symbol being processed.
#' @param status Processing status ("ok" or "error").
#' @param n_rows Number of rows fetched or inserted.
#' @param message Optional message (error, info, etc.).
#'
#' @return An updated summary table (tibble).
#' @export
log_summary <- function(summary_table, batch_id, symbol, status, n_rows = 0, message = "") {

  new_row <- tibble::tibble(
    batch_id = batch_id,
    symbol = symbol,
    status = status,
    n_rows = n_rows,
    message = message,
    timestamp = lubridate::now()
  )

  dplyr::bind_rows(summary_table, new_row)
}
