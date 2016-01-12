
################################################################################
# Save some example microboime data sets into a list of phyloseq objects
################################################################################

## ---- setup ----
library("biom")
library("phyloseq")
library("RCurl")
library("rdrop2")
all_data <- list()

## ---- from-phyloseq ---
all_data$enterotype <- get(data(enterotype))
all_data$global_patterns <- get(data(GlobalPatterns))
all_data$soilrep <- get(data(soilrep))
all_data$esophagus <- get(data(esophagus))

## ----  Waste not, want not paper ----

# not sure how to download directly from qiita, but I put some of the biome
# files on a public dropbox, which should be accessible to anyone
# Global Patterns (already included)
# cigarette smokers (http://qiita.microbio.me/study/description/524)
# long term diet (http://qiita.microbio.me/study/description/1010)
# bokulich (http://qiita.microbio.me/study/description/1689)
# restroom (http://qiita.microbio.me/study/description/1335)
# note: none of these have sample tables, and the others mentioned in the paper
# are not available from Qiita

# download the links to a temporary directory
biom_paths <- c("https://dl.dropboxusercontent.com/s/26fuy3cxy428ntp/145_otu_table.biom",
                "https://dl.dropboxusercontent.com/s/xfglsn14x09wlf4/220_otu_table.biom",
                "https://dl.dropboxusercontent.com/s/58pgbiivr2vu48s/246_otu_table.biom",
                "https://dl.dropboxusercontent.com/s/viuz6usj09qn8vm/306_otu_table.biom")
sapply(biom_paths, function(x) {
  download.file(x , dest = file.path(tempdir(), basename(x)),
                method = "libcurl")
})

# import these bioms into phyloseq objects
waste_not_physeq <- sapply(list.files(tempdir(), "*.biom", full = T), import_biom)
names(waste_not_physeq) <- c("diet", "restroom", "bokulich", "smokers")
all_data <- c(all_data, waste_not_physeq)

## ---- temporal-spatial-pregnancy ----
pregnancy_path <- "http://statweb.stanford.edu/~susan/papers/Pregnancy/PregnancyClosed15.Rdata"
tmp <- tempfile()
download.file(pregnancy_path, tmp)
all_data$pregnancy <- get(load(tmp))

## ---- save-and-upload ----
dir.create("data")
save(all_data, file = file.path(tempdir(), "microbiomeData.RData"))
drop_upload(file.path(tempdir(), "microbiomeData.RData"), "microbiomeData/data")
drop_share("microbiomeData/data/microbiomeData.RData")
