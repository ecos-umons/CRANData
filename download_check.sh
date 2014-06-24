#!/bin/bash

DATADIR=/data/cran
CWD=/data/extractoR
VAGRANT=/data/vagrant

DIR=$DATADIR/checks/`TZ=America/Montreal date +"%y-%m-%d-%H-%M"`
mkdir $DIR

rsync -rtlzv --delete --include "check_summary.html" --exclude="*.html" cran.r-project.org::CRAN/web/checks/ $DIR

cd $CWD

Rscript scripts/fetch.R &&
Rscript scripts/extract.R &&
Rscript scripts/content.R &&

cd $VAGRANT

Rscript scripts/update.R &&
vagrant ssh -c "Rscript /vagrant/scripts/install.R" &&
vagrant ssh -c "Rscript /vagrant/scripts/execute.R"

cd $DATADIR

Rscript scripts/descfiles.R &&
Rscript scripts/conflicts.R &&
Rscript scripts/clones.R
