# this script gets a bunch of data from the works/?query.funder-name endpoint of cross ref 
library(tidyverse)
library(httr)
library(glue)
library(jsonlite)

# https://api.crossref.org/works?query.funder-name=”Wellcome Trust” 
# https://api.crossref.org/works?query.funder-name=”Wellcome”


get_cr_funder <- function(query, rows=500, cursor='*') {
  GET('https://api.crossref.org/works?',
      add_headers('User-Agent: MDC-EDA (mailto:as4341@columbia.edu)'),
      query = list(
        `query.funder-name` = glue('"{query}"')
        , rows = rows
        , cursor = cursor
        , mailto ='as4341@columbia.edu'
        )
  )
}



# setup
get_cr_all <- function(query, rows=500) {  
  # initial call
  resp <- get_cr_funder(query=query, rows=rows)
  results <- content(resp)
  total_items <- results$message$`total-results`
  items <- list()
  items <- c(items, results$message$items)
  next_cursor <- results$message$`next-cursor`
  
  # page thru
  remaining_pages <- ceiling((total_items-length(items))/rows) + 1
  for(i in 1:remaining_pages) {
    cat(glue('Page {i} of {remaining_pages}. {round(i/remaining_pages,2)}'),
        '\n')
    resp <- get_cr_funder(query=query, rows=rows, cursor = next_cursor)
    results <- content(resp)
    items <- c(items, results$message$items)
    next_cursor <- results$message$`next-cursor`
    
    Sys.sleep(0.1)
  }
  
  return(items)
}

wt_crossref <- get_cr_all('Wellcome Trust')
saveRDS(wt_crossref, 'local_data/wt_crossref.RDS')

# this is too big it seems
# write_json(wt_crossref, 
#            'local_data/wt_crossref.json', auto_unbox = TRUE)
# out_fl <- file('local_data/wt_crossref.json', 'w')
# stream_out(wt_crossref, out_fl, auto_unbox = TRUE)

# still super slowww
chunks <- data.frame(start=seq(1, length(wt_crossref), 10000))
chunks$end <- c(chunks$start[-1], length(wt_crossref))

for(i in 1:nrow(chunks)) {
  fl_name <- glue('local_data/wt_crossref_part{i}.json')
  write_json(wt_crossref[with(chunks, start[i]:end[i])],
             fl_name, 
             auto_unbox = TRUE)
  cat(glue('Chunk {fl_name} done', '\n'))
}
