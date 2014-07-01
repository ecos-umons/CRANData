library(hash)
library(extractoR.utils)

packages <- readRDS("rds/packages.rds")
packages$filename <- apply(packages, 1, function(x) {
  sprintf("%s_%s.rds", x[1], x[2])
})
packages <- packages[file.exists(file.path("functions", packages$filename)), ]

ReadFunctions <- function(package) {
  message(sprintf("Reading %s", package["filename"]))
  hashes <- readRDS(file.path("functions", package["filename"]))
  FlattenDF(unlist(lapply(names(hashes), function(h) {
    lapply(hashes[[h]], function(f) {
      data.frame(package=package["package"], version=package["version"],
                 hash=h, size=f$size, global=f$is.global,
                 loc=length(strsplit(f$body, "\\n")[[1]]))
    })
  }), recursive=FALSE))
}

functions <- FlattenDF(apply(packages, 1, ReadFunctions))
clones <- table(unique(functions[c("package", "hash")])$hash)

res <- functions[functions$hash %in% as.factor(names(clones[clones > 1])), ]
res$package <- factor(res$package)
res$version <- factor(res$version)
res$hash <- factor(res$hash)

saveRDS(res, "clones.rds")
