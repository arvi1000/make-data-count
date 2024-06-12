library(tidyverse)

mdc_datacite <- data.table::fread('local_data/mdc_datacite_only.csv') %>% as_tibble
epmc_wellcome <- data.table::fread('local_data/wellcome_results_tabular.csv') %>% as_tibble


epmc_with_data <- epmc_wellcome %>% 
  filter(if_any(starts_with('tmAccessionTypeList.accessionType'), ~ !is.na(.)))

 
set.seed(123)
sample_rows <- sample(1:nrow(mdc_datacite), 2000)
sample_rows_w <- sample(1:nrow(epmc_with_data), 2000)

write.csv(mdc_datacite[sample_rows,], 'mdc_datacite_only_sample.csv', row.names = F)
write.csv(epmc_with_data[sample_rows_w, ], 'epmc_wellcome_sample.csv', row.names = F)
write.csv(epmc_with_data, 'local_data/epmc_wellcome_with_data_full.csv', row.names = F)
