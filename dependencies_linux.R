dependencies <- c("DBI",
                  "dplyr",
                  "glue",
                  "lubridate",
                  "RPostgres",
                  "tibble",
                  "tidyquant",
                  "tidyr",
                  "pak")

#linux dependencies
pak::pkg_sysreqs(dependencies,sysreqs_platform = "ubuntu")
