#' Push the summary table to PostgreSQL
#'
#' This function writes the batch summary to the student's `pipeline_logs` table inside their schema.
#'
#' @param con A valid DBI database connection.
#' @param summary_table The tibble created during the pipeline (via build_summary_table and log_summary).
#' @param user_login Optional, defaults to Sys.getenv('user_login'). The login of the student (e.g., "paul", "fariba").
#'
#' @return Nothing. Pushes logs into the database.
#' @export
push_summary_table <- function(con, summary_table, user_login = Sys.getenv('user_login')) {

  if (is.null(con) || is.null(summary_table) || is.null(user_login) || user_login == "") {
    stop("Parameters 'con', 'summary_table', and 'user_login' must be provided.")
  }

  if (nrow(summary_table) == 0) {
    message("No logs to insert.")
    return(invisible(NULL))
  }

  # Add user_login column
  summary_table <- summary_table |>
    dplyr::mutate(user_login = user_login) |>
    dplyr::select(user_login, batch_id, symbol, status, n_rows, message, timestamp)

  schema <- Sys.getenv("PG_SCHEMA")

  DBI::dbWriteTable(
    conn = con,
    name = DBI::Id(schema = schema, table = "pipeline_logs"),
    value = summary_table,
    append = TRUE,
    row.names = FALSE
  )

  message("Summary table pushed to database ✅")

  invisible(NULL)
}
