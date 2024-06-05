library(tidyverse)
library(httr)

get_response <- function(cursorMark='*', pageSize=100) {
  GET('https://www.ebi.ac.uk/europepmc/webservices/rest/search?',
      query = list(
        query='Wellcome',
        resultType='lite',
        cursorMark=cursorMark,
        pageSize=pageSize,
        format='json')
  )
  
}

# intial call
page_size <- 500
epmc <- get_response()
res <- content(epmc)
wellcome_results <- res$resultList$result
next_cursor <- res$nextCursorMark
total_hits <- res$hitCount

# page thru for rest of results
remaining_pages <- ceiling((total_hits - length(wellcome_results)) / page_size)
for(i in 1:remaining_pages) {
  epmc <- get_response(cursorMark = next_cursor, pageSize = page_size)
  res <- content(epmc)
  wellcome_results <- c(wellcome_results, res$resultList$result)
  next_cursor <- res$nextCursorMark
  Sys.sleep(.1)
  cat('Result count: ', length(wellcome_results), 'of ', total_hits, 
      round(100*length(wellcome_results)/total_hits, 1), '%\n')
}
