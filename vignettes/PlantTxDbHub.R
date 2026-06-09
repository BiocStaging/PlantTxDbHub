## ----setup, include = FALSE---------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

library(PlantTxDbHub)
library(GenomicFeatures)
library(GenomeInfoDb)

# Ensure databases are downloaded (only once)
db_dir <- downloadPlantTxDbs()


## ----download, eval = FALSE---------------------------------------------------
# library(PlantTxDbHub)
# downloadPlantTxDbs() # downloads into "plant_txdb_sqlite/"


## ----load_ath-----------------------------------------------------------------
# Point to the downloaded database
ath_file <- file.path(db_dir, "TxDb.Athaliana.TAIR10.v62.sqlite")
txdb_ath <- loadDb(ath_file)
txdb_ath


## ----cols---------------------------------------------------------------------
columns(txdb_ath)
keytypes(txdb_ath)


## ----genes_ath----------------------------------------------------------------
gene_gr <- genes(txdb_ath)
head(gene_gr)


## ----transcripts_ath----------------------------------------------------------
tx_gr <- transcripts(txdb_ath, columns = c("tx_name", "gene_id", "tx_biotype"))
head(tx_gr)


## ----exons_ath----------------------------------------------------------------
ex_gr <- exons(txdb_ath, columns = "exon_id")
head(ex_gr)


## ----filter_geneid------------------------------------------------------------
# Get the GRanges for a single gene
my_genes <- c("AT1G01010", "AT1G01020")
genes(txdb_ath, filter = list(gene_id = my_genes))


## ----filter_geneid_select-----------------------------------------------------
# Retrieve gene ranges + metadata
sel <- select(txdb_ath,
              keys = my_genes,
              columns = c("GENEID", "TXID", "TXBIOTYPE", "EXONID"),
              keytype = "GENEID")
head(sel)


## ----filter_biotype-----------------------------------------------------------
# Extract all gene IDs with gene_biotype "protein_coding"
gene_md <- select(txdb_ath,
                  keys = keys(txdb_ath, "GENEID"),
                  columns = c("GENEID", "GENEBIOTYPE"),
                  keytype = "GENEID")
pc_ids <- gene_md$GENEID[gene_md$GENEBIOTYPE == "protein_coding"]

# Subset the gene GRanges
pc_genes <- gene_gr[gene_gr$gene_id %in% pc_ids]
length(pc_genes)
head(pc_genes)


## ----chrom_ath----------------------------------------------------------------
gene_gr_nuc <- keepSeqlevels(gene_gr,
                             value = c("1", "2", "3", "4", "5"),
                             pruning.mode = "coarse")
seqlevels(gene_gr_nuc) <- paste0("Chr", seqlevels(gene_gr_nuc))
seqlevels(gene_gr_nuc)


## ----load_gmx-----------------------------------------------------------------
gmx_file <- file.path(db_dir, "TxDb.Gmax.Wm82.v62.sqlite")
txdb_gmx <- loadDb(gmx_file)
# Quick view
head(genes(txdb_gmx))


## ----load_osa-----------------------------------------------------------------
osa_file <- file.path(db_dir, "TxDb.Osativa.IRGSP.v62.sqlite")
txdb_osa <- loadDb(osa_file)
head(genes(txdb_osa))


## ----sessionInfo--------------------------------------------------------------
sessionInfo()

