#' Fetch list of symbols from a PostgreSQL schema
#'
#' This function queries the student's database schema to retrieve the list of
#' distinct `symbol` and `index_ts` from the `data_sp500` table.
#'
#' @param con A valid DBI database connection.
#' @param schema A character string specifying the schema name. Defaults to the environment variable `PG_SCHEMA`.
#'
#' @return A tibble with columns `symbol` and `index_ts`.
#' @export
fetch_symbols <- function(con, schema = Sys.getenv("PG_SCHEMA")) {

  if (missing(con) || missing(schema)) {
    stop("Both 'con' and 'schema' must be provided.")
  }

  query <- glue::glue_sql(
    "SELECT DISTINCT symbol, index_ts FROM {`schema`}.data_sp500",
    .con = con
  )

  result <- DBI::dbGetQuery(con, query)

  if (nrow(result) == 0) {
    warning("No symbols found in the database.")
  }

  tibble::as_tibble(result)
}
