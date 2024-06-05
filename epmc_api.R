library(tidyverse)
library(httr)

epmc <-
  POST('https://www.ebi.ac.uk/europepmc/webservices/rest/searchPOST?',
       body = list(
         query="Wellcome", 
         format="json"),
       encode="form"
  )

res <- content(epmc)

res$resultList[[1]][[1]] %>% names
res_df <- lapply(res$resultList[[1]], as_tibble) %>% bind_rows()

# copy to clipboard, less list columns
list_cols <- sapply(res_df, class) == 'list'
res_df[, !list_cols] %>%
  filter(pubType != 'preprint') %>%
  clipr::write_clip()
which(list_cols)
