library(timetraveleR)

packages <- readRDS("/data/cran/rds/packages.rds")
deps <- readRDS("/data/cran/rds/deps.rds")
rversions <- readRDS("rversions.rds")
res <- by(rversions, 1:nrow(rversions), function(v) {
  print(v)
  state <- Init(packages, deps, v$date)
  saveRDS(state, sprintf("%s.rds", v$version))
})
