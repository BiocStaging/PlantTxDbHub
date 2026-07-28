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

Install from Bioconductor:

```r
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("PlantTxDbHub")
```

To install the developer version from GitHub:

```r
if (!requireNamespace("remotes", quietly = TRUE))
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
```

## What changed vs. your pasted content

1. **Removed the merge conflict markers** (`<<<<<<< HEAD`, `=======`, `>>>>>>> cd187a6e...`) and the duplicated Installation code block that resulted from the unresolved merge.
2. **Kept a single, clean Installation section** with `##` subsection headers removed (using plain sentences "Install from Bioconductor:" / "To install the developer version from GitHub:") rather than the stray `#` top-level headers your `HEAD` version had — those would have flattened the README's structure the same way as the vignette issue found earlier.
3. **Used `requireNamespace()` instead of `require()`** for both `BiocManager` and `remotes` checks — this matches the version from the `origin` side of the conflict and is the more correct idiom (`require()` is discouraged for this kind of conditional-install check since it also attaches the namespace as a side effect).
4. Kept the two-`Glycine max` species list, consistent with the fix for checklist item 7 ("README only lists one Glycine max but README shows 2"). [1](#35-0) 

After saving this, run `git status` to confirm `README.md` no longer shows as "both modified"/conflicted, then `git add README.md`, commit, and push.

### Citations

**File:** README.md (L1-65)
```markdown
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

```
