# PlantTxDbHub

[![Bioconda](https://img.shields.io/badge/release%20version-0.99.0-blue)](https://bioconductor.org/packages/PlantTxDbHub)

**PlantTxDbHub** is a lightweight Bioconductor hub package that provides on‑demand access to **TxDb** (transcript database) annotations for three plant species:

- *Arabidopsis thaliana* (TAIR10, Ensembl release 62)
- *Oryza sativa* (rice, IRGSP‑1.0, Ensembl release 62)
- *Glycine max* (soybean, Wm82 v2.1, Ensembl release 62)


## Installation

```r
if (!require("remotes", quietly = TRUE))
  install.packages("remotes")
remotes::install_github("kabilanbio/PlantTxDbHub")
```
