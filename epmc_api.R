library(tidyverse)
library(httr)
library(jsonlite)

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

# intial call
page_size <- 500 #apparently 1000 is the max
query_text <- 'Wellcome'
epmc <- get_response(query=query_text, pageSize=page_size)
res <- content(epmc)
wellcome_results <- res$resultList$result
next_cursor <- res$nextCursorMark
total_hits <- res$hitCount

# page thru for rest of results
remaining_pages <- ceiling((total_hits - length(wellcome_results)) / page_size)
for(i in 1:remaining_pages) {
  epmc <- get_response(query=query_text,
                       cursorMark = next_cursor, pageSize = page_size)
  res <- content(epmc)
  wellcome_results <- c(wellcome_results, res$resultList$result)
  next_cursor <- res$nextCursorMark
  Sys.sleep(.1)
  cat('Result count: ', length(wellcome_results), 'of ', total_hits, 
      round(100*length(wellcome_results)/total_hits, 1), '%\n')
}

# save in JSON format----
# note that if you don't pass auto_unbox=TRUE to toJSON then the results
# end up as lists themselves. So upon reading the file back in, you get
# [{"id":["38760645"],"source":["MED"],"pmid":["38760645"] ...
# instead of how the object is returned from the code above, which is:
# [{"id":"38760645","source":"MED","pmid":"38760645"
write_json(wellcome_results, 'local_data/wellcome_results.json', auto_unbox = TRUE)

# save as flat file ----
wellcome_df <- wellcome_results %>% lapply(unlist) %>% bind_rows

# put these first and alpha sort after that
# "id", "source", "pmid", "doi", "title", "authorString", "journalTitle", "pubYear" 
new_col_order <- c(
  names(wellcome_df)[1:8],  
  sort(names(wellcome_df)[-(1:8)])
)
wellcome_df <- wellcome_df[, new_col_order]
write.csv(wellcome_df, 
          file = 'local_data/wellcome_results_tabular.csv', row.names = F)
