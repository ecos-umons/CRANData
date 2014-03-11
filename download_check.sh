#!/bin/bash

DATADIR=/data/cran/checks
CWD=/data/extractoR

DIR=$DATADIR/`TZ=America/Montreal date +"%y-%m-%d-%H-%M"`
mkdir $DIR

rsync -rtlzv --delete --include "check_summary.html" --exclude="*.html" cran.r-project.org::CRAN/web/checks/ $DIR

cd $CWD

Rscript scripts/fetch.R && Rscript scripts/extract.R
