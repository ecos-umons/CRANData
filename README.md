CRANData
========

This repository contains data extracted from CRAN using
[extractoR](https://github.com/maelick/extractoR).


Data stored in rds directory
----------------------------

Includes information on:

* packages
* package versions
* package description files
* package dependencies
* package dates
* package maintainers

Data stored in checks directory
-------------------------------

Contains two daily snapshots of
[CRAN "R CMD check" results](http://cran.r-project.org/web/checks/)
consisting of rds files and check\_summary.html. When rds files were
not present in CRAN checks directory, check\_results.rds has been
reconstructed using check\_summary.html. Both scripts for
reconstructing check\_result.rds and for extracting the snapshots are
included in the repository.
