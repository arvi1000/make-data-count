library(europepmc)
library(httr)

# get results for one id from the package and the api
package_result <- epmc_search("PMC10669250")
direct_api_result <-
  GET('https://www.ebi.ac.uk/europepmc/webservices/rest/search?', 
      query = list(query='PMC10669250',
                   resultType='lite',
                   format='json')
  ) |>
  content()

# compare fields returned
package_result |> names()
# [1] "id"                    "source"                "pmcid"                 "title"                 "authorString"          "journalTitle"          "issue"                
# [8] "journalVolume"         "pubYear"               "journalIssn"           "pubType"               "isOpenAccess"          "inEPMC"                "inPMC"                
# [15] "hasPDF"                "hasBook"               "hasSuppl"              "citedByCount"          "hasReferences"         "hasTextMinedTerms"     "hasDbCrossReferences" 
# [22] "hasLabsLinks"          "hasTMAccessionNumbers" "firstIndexDate"        "firstPublicationDate" 

direct_api_result$resultList$result[[1]] |> unlist() |> names()
# [1] "id"                                "source"                            "pmcid"                             "fullTextIdList.fullTextId"        
# [5] "title"                             "authorString"                      "journalTitle"                      "issue"                            
# [9] "journalVolume"                     "pubYear"                           "journalIssn"                       "pubType"                          
# [13] "isOpenAccess"                      "inEPMC"                            "inPMC"                             "hasPDF"                           
# [17] "hasBook"                           "hasSuppl"                          "citedByCount"                      "hasReferences"                    
# [21] "hasTextMinedTerms"                 "hasDbCrossReferences"              "hasLabsLinks"                      "hasTMAccessionNumbers"            
# [25] "tmAccessionTypeList.accessionType" "firstIndexDate"                    "firstPublicationDate"             
