# Internal helper – reads the master metadata CSV
.read_metadata <- function() {
  read.csv(
    system.file("extdata", "metadata.csv", package = "PlantTxDbHub"),
    stringsAsFactors = FALSE
  )
}

#' List available plant TxDb species
#'
#' Reads the internal metadata table (`inst/extdata/metadata.csv`) and
#' returns a concise list of available species identifiers and their
#' corresponding SQLite file names.
#'
#' @return A `data.frame` with columns `SpeciesID` (unique identifier used
#'   for download) and `Filename` (SQLite file name).
#' @export
#' @importFrom utils read.csv
#' @examples
#' listPlantTxDbSpecies()
listPlantTxDbSpecies <- function() {
  md <- .read_metadata()
  # The Title column currently holds the filename; adjust if your CSV uses a different column.
  data.frame(
    SpeciesID = md$SpeciesID,
    Filename  = md$Title,
    stringsAsFactors = FALSE
  )
}

#' Get the local path to a cached TxDb SQLite file
#'
#' Returns the full file path to a previously downloaded TxDb database.
#' If the file does not exist, the function stops with an error.
#'
#' @param species Character string. A species identifier as returned by
#'   [listPlantTxDbSpecies()] (e.g., `"Arabidopsis_TAIR10"`).
#' @param dest_dir Character string. The BiocFileCache directory.
#'   Defaults to the same cache used by [downloadPlantTxDbs()].
#'
#' @return Character string giving the complete file path.
#' @export
#'
#' @examples
#' getTxDbPath("Arabidopsis_TAIR10")
getTxDbPath <- function(species, dest_dir = tools::R_user_dir("PlantTxDbHub", "data")) {
  md <- listPlantTxDbSpecies()
  if (!species %in% md$SpeciesID) {
    stop("Invalid species. Choose from: ", paste(md$SpeciesID, collapse = ", "))
  }
  bfc <- BiocFileCache::BiocFileCache(dest_dir, ask = FALSE)
  res <- BiocFileCache::bfcquery(bfc, species, "rname", exact = TRUE)
  if (nrow(res) == 0) {
    stop("Species '", species, "' has not been downloaded. Run downloadPlantTxDbs(species = '", species, "') first.")
  }
  BiocFileCache::bfcrpath(bfc, rids = res$rid[1])
}

#' Download plant TxDb SQLite files from Zenodo (or other sources)
#'
#' Downloads plant transcript annotation databases based on the internal
#' metadata file `inst/extdata/metadata.csv`. Each file can reside on a
#' different server; the download URL is constructed from the
#' `Location_Prefix` and `RDataPath` columns.
#'
#' Files are cached using \pkg{BiocFileCache}.
#'
#' @param dest_dir A character string specifying the BiocFileCache location.
#'   Defaults to a package‑specific user data directory (see
#'   [tools::R_user_dir()]).
#' @param timeout Numeric. Maximum download time in seconds per file.
#'   Default 1800 (30 minutes). Passed to the underlying download mechanism
#'   via [options("timeout")].
#' @param download Logical. If `TRUE` (default), files are actually downloaded.
#'   If `FALSE`, the function only prepares the cache directory and returns its
#'   path without attempting any download.
#' @param species Character vector. Which species to download. Choose from
#'   the `SpeciesID` values returned by [listPlantTxDbSpecies()], e.g.
#'   `"Arabidopsis_TAIR10"`. Default is `NULL`, downloading all available
#'   databases.
#'
#' @return Invisibly returns the BiocFileCache directory path.
#' @export
#' @importFrom BiocFileCache BiocFileCache bfcadd bfcquery bfccache bfcdownload bfcrpath
#'
#' @examples
#' # Show the cache path without downloading
#' downloadPlantTxDbs(download = FALSE)
#'
#' \donttest{
#' # Download only the Arabidopsis database
#' downloadPlantTxDbs(species = "Arabidopsis_TAIR10")
#'
#' # Download all available databases
#' downloadPlantTxDbs()
#' }
downloadPlantTxDbs <- function(dest_dir = tools::R_user_dir("PlantTxDbHub", "data"),
                               timeout = 1800,
                               download = TRUE,
                               species = NULL) {
  md <- .read_metadata()

  if (!is.null(species) && !isTRUE(species)) {
    species <- match.arg(species, choices = md$SpeciesID, several.ok = TRUE)
    md <- md[md$SpeciesID %in% species, ]
  }

  if (nrow(md) == 0) {
    stop("No valid species selected. Available SpeciesIDs: ",
         paste(md$SpeciesID, collapse = ", "))
  }

  bfc <- BiocFileCache::BiocFileCache(dest_dir, ask = FALSE)

  if (download) {
    old_timeout <- getOption("timeout")
    options(timeout = timeout)
    on.exit(options(timeout = old_timeout), add = TRUE)

    for (i in seq_len(nrow(md))) {
      rname <- md$SpeciesID[i]
      url <- paste0(md$Location_Prefix[i], md$RDataPath[i])

      res <- BiocFileCache::bfcquery(bfc, rname, "rname", exact = TRUE)
      if (nrow(res) == 0) {
        message("Adding to cache: ", rname)
        rid <- BiocFileCache::bfcadd(bfc, rname = rname, fpath = url)
      } else {
        rid <- res$rid[1]
      }

      dest <- BiocFileCache::bfcrpath(bfc, rids = rid)

      if (!is_valid_sqlite(dest)) {
        message("Cached file '", basename(dest), "' appears corrupted. Re-downloading...")
        BiocFileCache::bfcdownload(bfc, rid, ask = FALSE)
        dest <- BiocFileCache::bfcrpath(bfc, rids = rid)

        if (!is_valid_sqlite(dest)) {
          stop("Downloaded file '", basename(dest), "' is invalid after re-download. Check the URL or network.")
        }
      }
    }
  }

  invisible(BiocFileCache::bfccache(bfc))
}

is_valid_sqlite <- function(path) {
  if (!requireNamespace("RSQLite", quietly = TRUE) ||
      !requireNamespace("DBI", quietly = TRUE))
    return(file.exists(path))

  tryCatch({
    db <- DBI::dbConnect(RSQLite::SQLite(), dbname = path,
                         flags = RSQLite::SQLITE_RO)
    on.exit(DBI::dbDisconnect(db), add = TRUE)
    DBI::dbGetQuery(db, "SELECT name FROM sqlite_master LIMIT 1")
    TRUE
  }, error = function(e) FALSE)
}
