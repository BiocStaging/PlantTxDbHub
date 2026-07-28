# PlantTxDbHub

[![Version](https://img.shields.io/badge/version-0.99.4-blue)](https://github.com/kabilanbio/PlantTxDbHub)
[![Bioconductor](https://img.shields.io/badge/Bioconductor-submitted-brightgreen)](https://github.com/BiocStaging/PlantTxDbHub)

**PlantTxDbHub** provides ready‑to‑use **TxDb** (transcript database) annotations
for plant genomes. The databases are stored as SQLite files and can be
downloaded on demand using `downloadPlantTxDbs()`. The list of available
species and their download URLs is maintained in a curated CSV file
(`inst/extdata/metadata.csv`), making it easy for the community to
contribute new databases without modifying any R code.

Currently included species:  
  
- *Arabidopsis thaliana* (TAIR10, Ensembl release 62)  
- *Oryza sativa* (IRGSP‑1.0, Ensembl release 62)  
- *Glycine max* (Wm82 v2.1, Ensembl Plants release 62)  
- *Glycine max* (Wm82.a4.v1, Phytozome v14)

## Installation

# Install from Bioconductor:
```r
if (!require("BiocManager", quietly = TRUE))  
    install.packages("BiocManager")  
BiocManager::install("PlantTxDbHub")
```
# To install the developer version from GitHub:
```r
if (!require("remotes", quietly = TRUE))
    install.packages("remotes")
remotes::install_github("kabilanbio/PlantTxDbHub")
```

## Usage

```r
library(PlantTxDbHub)
library(GenomicFeatures)

# List available species
listPlantTxDbSpecies()

# Download all databases (cached for future use)
downloadPlantTxDbs()

# Download only Arabidopsis
downloadPlantTxDbs(species = "Arabidopsis_TAIR10")

# Get the path to a cached file
txdb_file <- getTxDbPath("Arabidopsis_TAIR10")

# Load the TxDb
txdb <- loadDb(txdb_file)

# Use standard TxDb methods
genes(txdb)
transcripts(txdb)
```

## Contributing new species

We welcome additions for other plant species! See the vignette for detailed
instructions. In short:

1. Host your SQLite file on a permanent public URL (e.g. Zenodo).
2. Fork this repository and add a row to `inst/extdata/metadata.csv` with:
   - `SpeciesID` – unique identifier (e.g. `Zea_mays_B73`)
   - `Title` – the exact filename of the SQLite file
   - `Location_Prefix` and `RDataPath` – the two parts of the download URL
   - Other metadata columns (see existing rows)
3. Submit a pull request. No R code changes needed!

