#' Insert new data into the student's PostgreSQL table
#'
#' This function inserts new rows into the `data_sp500` table in the specified schema.
#' It assumes that the data has already been filtered by `check_existing_data()`.
#'
#' @param con A valid DBI database connection.
#' @param schema The schema name (e.g., \"student_paul\").
#' @param new_data A tibble containing the new rows to insert. Must match the database structure.
#'
#' @return True if all is well, otherwise an error is raised.
#' @export
insert_new_data <- function(con, schema = Sys.getenv("PG_SCHEMA"), new_data) {

  if (is.null(con) || is.null(new_data)) {
    stop("Both 'con' and 'new_data' must be provided.")
  }

  if (nrow(new_data) == 0) {
    message("No new data to insert.")
    return(invisible(NULL))
  }

  # Write the new data to the PostgreSQL table
  DBI::dbWriteTable(
    conn = con,
    name = DBI::Id(schema = schema, table = "data_sp500"),
    value = new_data,
    append = TRUE,
    row.names = FALSE
  )

  message(nrow(new_data), " new rows inserted into ", schema, ".data_sp500")

  return(TRUE)
}
