# this script gets top institutions from the datacite records in MDC corpus
library(data.table)
library(tidyverse)

 mdc_datacite_only <-
  fread('local_data/mdc_datacite_only.csv') %>%
  as_tibble()
 
affil <- mdc_datacite_only %>%
  mutate(affiliations=trimws(affiliations)) %>%
  filter(nchar(affiliations)>0) %>%
  .$affiliations

clean_affil <- 
  affil %>%
  str_split(pattern="(;|https://)") %>%
  unlist %>%
  gsub("(\"|\\(|\\)|\'|$, |@|\n ?,?)", '', .) %>%
  trimws()

affil_tally <- clean_affil %>%
  table() %>%
  as_tibble

write.csv(affil_tally, 'rough_affiliation_tally.csv', row.names = F)
