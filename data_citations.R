library(europepmc)
library(glue)

# a list of data citation accession types, 
# scraped from https://europepmc.org/advancesearch
data_sources <- read.csv('ACCESSION_TYPES.csv')

record_count <- function(accession_type) {
  qry <- glue('(ACCESSION_TYPE:{accession_type})')
  check_len <- epmc_search(qry, limit = 1)
  total_results <- coalesce(attr(check_len, 'hit_count'), 0)
  return(total_results)
}

# this doesn't work for some reason
# hits <- lapply(data_sources, record_count)

data_sources$hit_count <- 0
for(i in 29:nrow(data_sources)) {
  data_sources$hit_count[i] <- record_count(data_sources$ACCESSION_TYPE[i])
}

write.csv(data_sources, 'hits_by_data_citation_source.csv', row.names = F)
