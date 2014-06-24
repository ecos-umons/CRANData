descfiles <- readRDS("rds/descfiles.rds")
filenames <- sprintf("%s_%s.rds", descfiles$package, descfiles$version)
res <- split(descfiles[c("key", "value")], filenames)

for (filename in names(res)) {
  if (!file.exists(file.path("descfiles", filename))) {
    message(sprintf("Writing %s", filename))
    saveRDS(res[[filename]], file.path("descfiles", filename))
  }
}
