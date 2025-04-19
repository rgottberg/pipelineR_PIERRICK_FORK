devtools::install()

con <- pipelineR::connect_db()

message("Testing start_pipeline() on a small batch...")

pipelineR::start_pipeline(
  from = Sys.Date() - 5,
  to = Sys.Date(),
  batch_size = 100
)

message("✅ start_pipeline() completed without crash.")

