library(data.table)
library(clipr)
library(tidyverse)

# load data ----
fls <- list.files('data-v1.1/', full.names = T)
dats <- lapply(fls, fread)
dat <- rbindlist(dats)
rm(dats); gc()

# eda ----
nrow(dat) |> prettyNum(big.mark = ",")

cardinality <- data.table(
  col = names(dat), 
  unique_vals = sapply(dat, function(x) length(unique(x)))
  )

cardinality %>% write_clip

dat_dt <- dat
dat <- as_tibble(dat)

dat %>%
  group_by(repository) %>%
  tally() %>%
  arrange(-n)

dat %>%
  group_by(source) %>%
  tally() %>%
  arrange(-n) %>%
  mutate(pct = n / nrow(dat) )

# filter out CZI ----
dat_datacite <- dat %>% filter(source=='datacite')
write.csv(dat_datacite, 'mdc_datacite_only.csv', row.names = F)
