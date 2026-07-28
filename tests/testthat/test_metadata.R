context("metadata and core functions")

test_that("metadata.csv is present and well-formed", {
  md_path <- system.file("extdata", "metadata.csv", package = "PlantTxDbHub")
  expect_true(file.exists(md_path), label = "metadata.csv exists")

  md <- read.csv(md_path, stringsAsFactors = FALSE)
  required_cols <- c(
    "SpeciesID", "Title", "Description", "BiocVersion", "Genome",
    "SourceType", "SourceVersion", "SourceUrl", "Species", "TaxonomyId",
    "Coordinate_1_based", "DataProvider", "Maintainer", "RDataClass",
    "DispatchClass", "Location_Prefix", "RDataPath", "Tags"
  )
  expect_true(all(required_cols %in% names(md)),
    label = "metadata.csv has all required columns"
  )
  expect_gt(nrow(md), 0, label = "metadata.csv has at least one row")
  expect_true(anyDuplicated(md$SpeciesID) == 0,
    label = "SpeciesID values are unique"
  )
})

test_that("listPlantTxDbSpecies returns expected structure", {
  species <- listPlantTxDbSpecies()
  expect_s3_class(species, "data.frame")
  expect_named(species, c(
    "SpeciesID", "Species", "Genome",
    "SourceVersion", "DataProvider",
    "Filename", "Description"
  ))
  expect_gt(nrow(species), 0)
  expect_true(all(!is.na(species$SpeciesID) & !is.na(species$Filename)))
})

test_that("getTxDbProvenance returns correct columns", {
  prov <- getTxDbProvenance("Arabidopsis_TAIR10")
  expect_s3_class(prov, "data.frame")
  expect_named(prov, c("SpeciesID", "DataProvider", "SourceUrl", "SourceVersion"))
  expect_equal(prov$SpeciesID, "Arabidopsis_TAIR10")
  expect_equal(prov$DataProvider, "Ensembl Plants")
})

test_that("getTxDbPath errors for invalid or missing species", {
  skip_if_not_installed("BiocFileCache")

  expect_error(getTxDbPath("NotASpecies"), "Invalid species")

  tmp_cache <- tempfile("bfc")
  on.exit(unlink(tmp_cache, recursive = TRUE), add = TRUE)
  expect_error(
    getTxDbPath("Arabidopsis_TAIR10", dest_dir = tmp_cache),
    "has not been downloaded"
  )
})

test_that("downloadPlantTxDbs filters species correctly", {
  skip_if_not_installed("BiocFileCache")

  tmp_cache <- tempfile("bfc")
  on.exit(unlink(tmp_cache, recursive = TRUE), add = TRUE)

  path <- downloadPlantTxDbs(
    dest_dir = tmp_cache,
    download = FALSE,
    species = "Arabidopsis_TAIR10"
  )
  expect_true(dir.exists(path))

  expect_error(
    downloadPlantTxDbs(dest_dir = tmp_cache, download = FALSE, species = "NotASpecies"),
    "Invalid species"
  )
})

test_that("is_valid_sqlite distinguishes valid and invalid SQLite files", {
  skip_if_not_installed("RSQLite")
  skip_if_not_installed("DBI")

  tmp_valid <- tempfile(fileext = ".sqlite")
  tmp_invalid <- tempfile(fileext = ".txt")
  on.exit(unlink(c(tmp_valid, tmp_invalid)), add = TRUE)

  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = tmp_valid)
  DBI::dbDisconnect(con)
  expect_true(is_valid_sqlite(tmp_valid))

  writeLines("not a sqlite file", tmp_invalid)
  expect_false(is_valid_sqlite(tmp_invalid))
})

test_that("downloadPlantTxDbs can download a small file when online", {
  skip_on_cran()
  skip_if_offline()
  skip_if_not_installed("BiocFileCache")

  tmp_cache <- tempfile("bfc")
  on.exit(unlink(tmp_cache, recursive = TRUE), add = TRUE)

  path <- downloadPlantTxDbs(
    dest_dir = tmp_cache,
    species = "Arabidopsis_TAIR10",
    timeout = 1800
  )
  expect_true(dir.exists(path))

  db_path <- getTxDbPath("Arabidopsis_TAIR10", dest_dir = tmp_cache)
  expect_true(file.exists(db_path))
  expect_true(is_valid_sqlite(db_path))
})
