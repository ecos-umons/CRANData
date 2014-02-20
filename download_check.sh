#!/bin/bash

CWD=/data/cran/checks

DIR=`TZ=America/Montreal date +"%y-%m-%d-%H-%M"`
mkdir $CWD/$DIR

rsync -rtlzv --delete --include "check_summary.html" --exclude="*.html" cran.r-project.org::CRAN/web/checks/ $CWD/$DIR
