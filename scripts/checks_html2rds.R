library(reshape2)
library(XML)

Strip <- function(s) {
  gsub("^[[:space:]]*|[[:space:]]*$", "", s)
}

Flavors <- function(doc) {
  table <- xpathSApply(doc, "//table[not(@id)]", xmlChildren)
  flavors <- sapply(table[-1], function(x) xpathSApply(x, "./td", xmlValue)[1])
  gsub(" ", "", flavors)
}

Packages <- function(filename) {
  doc <- htmlTreeParse(filename, useInternalNodes=T)
  flavors <- Flavors(doc)
  table <- xpathSApply(doc, "//table[@id='summary_by_package']/tr/td", xmlValue)
  res <- matrix(Strip(table), ncol=length(flavors) + 4, byrow=TRUE)
  colnames(res) <- c("Package", "Version", flavors, "Maintainer", "Priority")
  res <- melt(as.data.frame(res, stringsAsFactors=FALSE),
              id.vars=c("Package", "Version", "Maintainer", "Priority"),
              variable.name="Flavor", value.name="Status")
  res$Status <- gsub("\\*", "", res$Status)
  res[res$Status != "", ]
}

for (path in dir("./checks", full.names=TRUE)) {
  target <- file.path(path, "check_results.rds")
  if (!file.exists(target)) {
    source <- file.path(path, "check_summary.html")
    message(sprintf("Reading %s", source))
    saveRDS(Packages(source), target)
  }
}
