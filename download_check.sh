#!/bin/bash

CWD=./check

DIR=`date +"%y-%m-%d-%H-%M"`
mkdir $CWD/$DIR

rsync -rtlzv --delete --exclude="*.html" cran.r-project.org::CRAN/web/checks/ $CWD/$DIR
