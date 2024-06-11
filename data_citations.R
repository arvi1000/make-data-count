library(europepmc)
library(glue)
library(tidyverse)
library(httr)

target_file <- 'hits_by_data_citation_source.csv'

if(file.exists(target_file)) {
  # load from file if available
  data_sources <- read.csv(target_file)
} else {
  # otherwise build from api
  
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
  
  write.csv(data_sources, target_file, row.names = F)
}


# compare direct API and package results
get_response <- function(query, cursorMark='*', pageSize) {
  GET('https://www.ebi.ac.uk/europepmc/webservices/rest/search?',
      query = list(
        query=query,
        resultType='lite',
        cursorMark=cursorMark,
        pageSize=pageSize,
        format='json')
  )
}

atype <- data_sources[7, 1]
api_resp <- get_response(
  query = glue('(ACCESSION_TYPE:{atype})'),
  pageSize = 44)

api_resp$url
api_results <- content(api_resp)

pkg_res <- epmc_search('(ACCESSION_TYPE:chebi)', limit = 44)

# and those from file
api_results$resultList$result[[1]]

# Aha! Accession type is already in there!


epmc_search("PMC10669250")

httr::GET('https://www.ebi.ac.uk/europepmc/webservices/rest/search?', 
          query = list(query='PMC10669250',
                       resultType='lite',
                       format='json'))
            