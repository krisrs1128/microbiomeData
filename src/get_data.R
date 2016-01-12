
################################################################################
# Save some example microboime data sets into a list of phyloseq objects
################################################################################

## ---- setup ----
library("biom")
library("phyloseq")
path <- "~/Documents/data/microbiomeData" # path to repository
data_path <- "~/Google Drive/microbiomeData/data" # path to data
setwd(path)
all_data <- list()

## ---- from-phyloseq ---
all_data$enterotype <- get(data(enterotype))
all_data$global_patterns <- get(data(GlobalPatterns))
all_data$soilrep <- get(data(soilrep))
all_data$esophagus <- get(data(esophagus))

## ----  Waste not, want not paper ----

# not sure how to download directly from qiita, but links are included. Include
# the downloaded files in the "data_path" directory
# Global Patterns (already included)
# cigarette smokers (http://qiita.microbio.me/study/description/524)
# long term diet (http://qiita.microbio.me/study/description/1010)
# bokulich (http://qiita.microbio.me/study/description/1689)
# restroom (http://qiita.microbio.me/study/description/1335)
# note: none of these have sample tables, and the others mentioned in the paper
# are not available from Qiita
waste_not_names <- paste0(data_path, "/", c("306_", "145_", "246_", "220_"), "otu_table.biom")
waste_not_physeq <- sapply(waste_not_names, import_biom)
names(waste_not_physeq) <- c("smokers", "diet", "bokulich", "restroom")
all_data <- c(all_data, waste_not_physeq)

## ---- temporal-spatial-pregnancy ----
pregnancy_path <- "http://statweb.stanford.edu/~susan/papers/Pregnancy/PregnancyClosed15.Rdata"
tmp <- tempfile()
download.file(pregnancy_path, tmp)
all_data$pregnancy <- get(load(tmp))

## ---- save-and-upload ----
dir.create("data")
save(all_data, file = file.path(data_path, "microbiomeData.RData"))
