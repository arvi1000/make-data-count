library(jsonlite)
wellcome_results <- read_json('local_data/wellcome_results (bad format).json')

wr2 <- wellcome_results |> 
  lapply(
    function(x) lapply(x, unlist, recursive = FALSE)
  )

write_json(wr2, 'local_data/wellcome_results.json', auto_unbox = TRUE)
