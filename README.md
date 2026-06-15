# PlantTxDbHub

[![Version](https://img.shields.io/badge/version-0.99.1-blue)](https://github.com/kabilanbio/PlantTxDbHub)
[![Bioconductor](https://img.shields.io/badge/Bioconductor-submitted-brightgreen)](https://github.com/BiocStaging/PlantTxDbHub)

**PlantTxDbHub** provides ready‑to‑use **TxDb** (transcript database) annotations
for plant genomes. The databases are stored as SQLite files and can be
downloaded on demand using the package's `downloadPlantTxDbs()` function.
The list of available species and their download URLs is maintained in a
curated CSV file (`inst/extdata/metadata.csv`), making it easy for the
community to contribute new databases without modifying any R code.

Currently included species:

- *Arabidopsis thaliana* (TAIR10, Ensembl release 62)  
- *Oryza sativa* (IRGSP‑1.0, Ensembl release 62)  
- *Glycine max* (Wm82 v2.1, Ensembl release 62)

## Installation

```r
if (!require("remotes", quietly = TRUE))
    install.packages("remotes")
remotes::install_github("kabilanbio/PlantTxDbHub")
```

## Usage

```r
library(PlantTxDbHub)

# List available species
listPlantTxDbSpecies()

# Download all databases (cached for future use)
db_dir <- downloadPlantTxDbs()

# Download only Arabidopsis
downloadPlantTxDbs(species = "Arabidopsis_TAIR10")

# Load a downloaded TxDb
txdb <- GenomicFeatures::loadDb(file.path(db_dir, "TxDb.Athaliana.TAIR10.v62.sqlite"))

# Use standard TxDb methods
genes(txdb)
transcripts(txdb)
```

## Contributing new species

We welcome additions for other plant species! See the [vignette](vignettes/PlantTxDbHub.Rmd)
for detailed instructions. In short:

1. Host your SQLite file on a permanent public URL (e.g. Zenodo).
2. Fork this repository and add a row to `inst/extdata/metadata.csv` with:
   - `SpeciesID` – unique identifier (e.g. `Zea_mays_B73`)
   - `Title` – the exact filename of the SQLite file
   - `Location_Prefix` and `RDataPath` – the two parts of the download URL
   - Other metadata columns (see existing rows)
3. Submit a pull request. No R code changes needed!

## Package status

This package is currently under review for inclusion in Bioconductor.
Check the [BiocStaging repository](https://github.com/BiocStaging/PlantTxDbHub)
for build reports and review progress.

## License

Artistic-2.0
