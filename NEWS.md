# PlantTxDbHub 0.99.2

## BREAKING CHANGES

- The package no longer depends on `AnnotationHub`. Databases are now
  downloaded directly from the URLs specified in the metadata CSV file
  (`inst/extdata/metadata.csv`). Users should call `downloadPlantTxDbs()`
  instead of relying on AnnotationHub queries.

## NEW FEATURES

- Added `listPlantTxDbSpecies()` to display available species identifiers
  and their corresponding SQLite file names.
- `downloadPlantTxDbs()` gained a `species` argument, allowing users to
  download a subset of databases (e.g., `species = "Arabidopsis_TAIR10"`).
- Added a `download` parameter to `downloadPlantTxDbs()` (`download = FALSE`)
  to allow examination of the destination path without initiating a download.
- The download function now automatically re‑fetches corrupted SQLite files,
  using a new internal helper `is_valid_sqlite()` that validates the database
  integrity.
- The list of available species and their download URLs is now maintained in
  a single CSV file (`inst/extdata/metadata.csv`). This file can be easily
  extended by contributors without modifying R code.
- A contributing guide is included in the vignette, explaining how to add
  new plant TxDb databases.

## IMPROVEMENTS

- Downloads are now more robust: when `curl` is available it is used with a
  configurable timeout; otherwise `download.file()` is used with a raised
  timeout.
- The default cache directory uses `tools::R_user_dir("PlantTxDbHub", "data")`,
  keeping files in a persistent but unobtrusive location.
- Vignette updated to reflect the new workflow, including installation,
  species listing, selective download, and contribution instructions.

## BUG FIXES

- Fixed a timeout issue when downloading the large *Glycine max* database by
  increasing the default timeout to 30000 seconds and adding `curl` support.
- Removed non‑ASCII characters from source files to pass `R CMD check` without
  warnings.
- Fixed undocumented dependencies (`GenomicFeatures`, `GenomeInfoDb`) by
  adding them to `Suggests`.
  
# PlantTxDbHub 0.99.1

- Minor correction in Description.

# PlantTxDbHub 0.99.0

- First release of the package.
- Provided TxDb annotation databases for three plant species via AnnotationHub
  (concept only; not yet functional in the current release).
- Included a vignette demonstrating retrieval and use of TxDb objects.
