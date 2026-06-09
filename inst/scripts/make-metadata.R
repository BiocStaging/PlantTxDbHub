## ----------------------------------------------------------------------------
## make-metadata.R – Create metadata.csv for PlantTxDbHub
## ----------------------------------------------------------------------------
## This script generates inst/extdata/metadata.csv describing the three TxDb
## resources (Arabidopsis, rice, soybean). The SQLite files are hosted on
## Zenodo (record ID: 20606038 – replace with your actual record).
## ----------------------------------------------------------------------------

## Variables to adjust --------------------------------------------------------
zenodo_record <- "20606038"          # <-- REPLACE with your Zenodo record ID
location_prefix <- "https://zenodo.org/record/"

# Define the three resources ------------------------------------------------
metadata <- data.frame(
  Title = c(
    "TxDb.Athaliana.TAIR10.v62.sqlite",
    "TxDb.Gmax.Wm82.v62.sqlite",
    "TxDb.Osativa.IRGSP.v62.sqlite"
  ),
  Description = c(
    "Ensembl Plants TAIR10 release 62 GTF-derived TxDb",
    "Ensembl Plants Wm82 v2.1 release 62 GTF-derived TxDb",
    "Ensembl Plants IRGSP-1.0 release 62 GTF-derived TxDb"
  ),
  BiocVersion = rep("3.20", 3),               # current Bioconductor release
  Genome = c("TAIR10", "Gmax_v2.1", "IRGSP-1.0"),
  SourceType = rep("GTF", 3),
  SourceVersion = rep("62", 3),               # Ensembl release number
  SourceUrl = c(
    "https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-62/gtf/arabidopsis_thaliana/Arabidopsis_thaliana.TAIR10.62.gtf.gz",
    "https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-62/gtf/glycine_max/Glycine_max.Glycine_max_v2.1.62.chr.gtf.gz",
    "https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-62/gtf/oryza_sativa/Oryza_sativa.IRGSP-1.0.62.chr.gtf.gz"
  ),
  Species = c("Arabidopsis thaliana", "Glycine max", "Oryza sativa"),
  TaxonomyId = c(3702, 3847, 4530),           # corrected rice taxid
  Coordinate_1_based = rep(TRUE, 3),
  DataProvider = rep("Ensembl Plants", 3),
  Maintainer = rep("Kabilan S <kabilan151414@gmail.com>", 3),
  RDataClass = rep("TxDb", 3),
  DispatchClass = rep("SQLiteFile", 3),
  Location_Prefix = rep(location_prefix, 3),
  RDataPath = sprintf("%s/files/%s?download=1", zenodo_record, c(
    "TxDb.Athaliana.TAIR10.v62.sqlite",
    "TxDb.Gmax.Wm82.v62.sqlite",
    "TxDb.Osativa.IRGSP.v62.sqlite"
  )),
  Tags = c(
    "AnnotationHub, TxDb, Arabidopsis_thaliana, TAIR10",
    "AnnotationHub, TxDb, Glycine_max, Gmax_v2.1",
    "AnnotationHub, TxDb, Oryza_sativa, IRGSP-1.0"
  ),
  stringsAsFactors = FALSE
)

## Write metadata.csv to inst/extdata/ ---------------------------------------
output_dir <- "inst/extdata"
if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)
write.csv(metadata, file = file.path(output_dir, "metadata.csv"),
          row.names = FALSE, quote = TRUE)

cat("metadata.csv written to", file.path(output_dir, "metadata.csv"), "\n")

## Optional: Manual validation hint -----------------------------------------
cat("\nTo validate metadata.csv, run the following in R:\n")
cat("  m <- read.csv('inst/extdata/metadata.csv')\n")
cat("  str(m)  # check column types\n")
cat("  # Ensure all required columns are present and correctly formatted.\n")
