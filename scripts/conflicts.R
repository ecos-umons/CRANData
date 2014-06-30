library(extractoR.utils)

packages <- readRDS("rds/packages.rds")
packages$filename <- apply(packages, 1, function(x) {
  sprintf("%s_%s.rds", x[1], x[2])
})
packages <- packages[file.exists(file.path("namespaces", packages$filename)), ]

ReadNamespace <- function(package) {
  message(sprintf("Reading %s", package["filename"]))
  objects <- readRDS(file.path("namespaces", package["filename"]))
  if (length(objects)) {
    res <- data.frame(name=sapply(objects, function(o) o$name),
                      type=sapply(objects, function(o) o$type[1]))
    res$package <- package["package"]
    res$version <- package["version"]
    res[c("package", "version", "name", "type")]
  }
}

objects <- FlattenDF(apply(packages, 1, ReadNamespace))
conflicts <- table(unique(objects[c("package", "name")])$name)

res <- objects[objects$name %in% as.factor(names(conflicts[conflicts > 1])), ]
res$package <- factor(res$package)
res$version <- factor(res$version)
res$name <- factor(res$name)
res$type <- factor(res$type)

saveRDS(res, "conflicts.rds")
