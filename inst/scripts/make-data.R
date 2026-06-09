## ----------------------------------------------------------------------------
## make-data.R – Creation of TxDb SQLite files for PlantTxDbHub
## ----------------------------------------------------------------------------
## This script documents how the three TxDb databases were built from
## Ensembl Plants GTF files (release 62). The resulting SQLite files were
## uploaded to Zenodo (DOI: 10.5281/zenodo.20606038) and are served via
## AnnotationHub through the PlantTxDbHub package.
## ----------------------------------------------------------------------------

## Requirements
## - R >= 4.0.0
## - Packages: txdbmaker, GenomicFeatures, GenomeInfoDb
## - GTF files downloaded from Ensembl Plants release 62:
##   Arabidopsis_thaliana.TAIR10.62.gtf.gz
##   Oryza_sativa.IRGSP-1.0.62.chr.gtf.gz
##   Glycine_max.Glycine_max_v2.1.62.chr.gtf.gz

library(txdbmaker)
library(GenomicFeatures)
library(GenomeInfoDb)

## 1. Arabidopsis thaliana (TAIR10) -------------------------------------------
gtf_arab <- "path/to/Arabidopsis_thaliana.TAIR10.62.gtf.gz"
chrominfo_arab <- data.frame(
  chrom = c("1","2","3","4","5","Mt","Pt"),
  length = c(30427671,19698289,23459830,18585056,26975502,366924,154478),
  is_circular = c(rep(FALSE,5), TRUE, TRUE)
)
arab_txdb <- makeTxDbFromGFF(
  file       = gtf_arab,
  format     = "gtf",
  dataSource = "Ensembl Plants release 62 GTF",
  organism   = "Arabidopsis thaliana",
  taxonomyId = 3702,
  chrominfo  = chrominfo_arab,
  metadata   = data.frame(
    name = c("Source","Ensembl release","GTF file","Genome assembly",
             "Creation date","Created by","Contact"),
    value = c("Ensembl Plants","62",basename(gtf_arab),"TAIR10",
              format(Sys.Date(),"%Y-%m-%d"),Sys.getenv("USER"),
              "Kabilan S <kabilan151414@gmail.com>")
  )
)
genome(seqinfo(arab_txdb)) <- "TAIR10"
saveDb(arab_txdb, "TxDb.Athaliana.TAIR10.v62.sqlite")

## 2. Oryza sativa (rice, IRGSP‑1.0) -----------------------------------------
gtf_rice <- "path/to/Oryza_sativa.IRGSP-1.0.62.chr.gtf.gz"
chrominfo_rice <- data.frame(
  chrom = c(as.character(1:12), "Mt", "Pt"),
  length = c(43270923,35937250,36413819,35502694,29958434,
             31248787,29697621,28443022,23012720,23207287,
             29021106,27531856,490520,134525),
  is_circular = c(rep(FALSE,12), TRUE, TRUE)
)
rice_txdb <- makeTxDbFromGFF(
  file       = gtf_rice,
  format     = "gtf",
  dataSource = "Ensembl Plants release 62 GTF",
  organism   = "Oryza sativa",
  taxonomyId = 4530,
  chrominfo  = chrominfo_rice,
  metadata   = data.frame(
    name = c("Source","Ensembl release","GTF file","Genome assembly",
             "Creation date","Created by","Contact"),
    value = c("Ensembl Plants","62",basename(gtf_rice),"IRGSP-1.0",
              format(Sys.Date(),"%Y-%m-%d"),Sys.getenv("USER"),
              "Kabilan S <kabilan151414@gmail.com>")
  )
)
genome(seqinfo(rice_txdb)) <- "IRGSP-1.0"
saveDb(rice_txdb, "TxDb.Osativa.IRGSP.v62.sqlite")

## 3. Glycine max (soybean, Wm82 v2.1) ---------------------------------------
gtf_soy <- "path/to/Glycine_max.Glycine_max_v2.1.62.chr.gtf.gz"
chrominfo_soy <- data.frame(
  chrom = c(as.character(1:20), "Mt", "Pt"),
  length = c(56831624,48577505,45779781,52389146,42234498,
             51416486,44630646,47837940,50189764,51566898,
             34766867,40091314,45874162,49042192,51756343,
             37887014,41641366,58018742,50746916,47904181,
             402545,152218),
  is_circular = c(rep(FALSE,20), TRUE, TRUE)
)
soy_txdb <- makeTxDbFromGFF(
  file       = gtf_soy,
  format     = "gtf",
  dataSource = "Ensembl Plants release 62 GTF",
  organism   = "Glycine max",
  taxonomyId = 3847,
  chrominfo  = chrominfo_soy,
  metadata   = data.frame(
    name = c("Source","Ensembl release","GTF file","Genome assembly",
             "Creation date","Created by","Contact"),
    value = c("Ensembl Plants","62",basename(gtf_soy),"Gmax_v2.1",
              format(Sys.Date(),"%Y-%m-%d"),Sys.getenv("USER"),
              "Kabilan S <kabilan151414@gmail.com>")
  )
)
genome(seqinfo(soy_txdb)) <- "Gmax_v2.1"
saveDb(soy_txdb, "TxDb.Gmax.Wm82.v62.sqlite")

## ----------------------------------------------------------------------------
## After creation, the three .sqlite files were uploaded to Zenodo:
##   https://zenodo.org/record/20606038
## The DOI (10.5281/zenodo.20606038) is used in the hub package's metadata.csv.
## ----------------------------------------------------------------------------
