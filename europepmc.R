library(europepmc)
check_len <- epmc_search('Wellcome', limit = 1)
total_results <- attr(check_len, 'hit_count')

# warning this takes FOREVER
wellcome_all <- epmc_search('Wellcome', limit = total_results)
write.csv(wellcome_all, 'wellcome_from_package.csv', row.names = F)
saveRDS(wellcome_all, 'wellcome_all.rds')
