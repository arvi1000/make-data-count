library(data.table)
library(clipr)

dat <- fread('Make Data Count Citation Corpus.csv')

nrow(dat) |> prettyNum(big.mark = ",")

cardinality <- data.table(
  col = names(dat), 
  unique_vals = sapply(dat, function(x) length(unique(x)))
  )

cardinality |> write_clip()
