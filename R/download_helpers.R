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

#' Download plant TxDb SQLite files from Zenodo (or other sources)
#'
#' Downloads plant transcript annotation databases based on the internal
#' metadata file `inst/extdata/metadata.csv`. Each file can reside on a
#' different server; the download URL is constructed from the
#' `Location_Prefix` and `RDataPath` columns.
#'
#' @param dest_dir A character string specifying where to save the SQLite files.
#'   Defaults to a package‑specific user data directory (see
#'   [tools::R_user_dir()]).
#' @param timeout Numeric. Maximum download time in seconds per file.
#'   Default 300 (5 minutes).
#' @param download Logical. If `TRUE` (default), files are actually downloaded.
#'   If `FALSE`, the function only prepares the directory and returns its path
#'   without attempting any download.
#' @param species Character vector. Which species to download. Choose from
#'   the `SpeciesID` values returned by [listPlantTxDbSpecies()], e.g.
#'   `"Arabidopsis_TAIR10"`. Default is `NULL`, downloading all available
#'   databases.
#'
#' @return Invisibly returns the normalized path to the destination directory.
#' @export
#' @importFrom utils download.file
#'
#' @examples
#' # Show the path without downloading
#' downloadPlantTxDbs(download = FALSE)
#'
#' \donttest{
#' # Download only the Arabidopsis database
#' downloadPlantTxDbs(species = "Arabidopsis_TAIR10")
#'
#' # Download all three databases
#' downloadPlantTxDbs()
#' }
downloadPlantTxDbs <- function(dest_dir = tools::R_user_dir("PlantTxDbHub", "data"),
                               timeout = 30000,
                               download = TRUE,
                               species = NULL) {
  md <- .read_metadata()

  # Filter by species if requested
  if (!is.null(species) && !isTRUE(species)) {
    species <- match.arg(species, choices = md$SpeciesID, several.ok = TRUE)
    md <- md[md$SpeciesID %in% species, ]
  }

  if (nrow(md) == 0) {
    stop("No valid species selected. Available SpeciesIDs: ",
         paste(md$SpeciesID, collapse = ", "))
  }

  if (!dir.exists(dest_dir)) {
    ok <- dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
    if (!ok || !dir.exists(dest_dir)) {
      stop("Failed to create directory: ", dest_dir,
           "\nPlease check permissions or provide a custom dest_dir.")
    }
  }

  if (download) {
    for (i in seq_len(nrow(md))) {
      f <- md$Title[i]                     # filename, e.g. "TxDb.Athaliana.TAIR10.v62.sqlite"
      url <- paste0(md$Location_Prefix[i], md$RDataPath[i])
      dest <- file.path(dest_dir, f)

      if (!file.exists(dest) || !is_valid_sqlite(dest)) {
        if (file.exists(dest)) {
          message("File '", f, "' appears corrupted. Re-downloading...")
          unlink(dest)
        }
        message("Downloading: ", f)

        if (requireNamespace("curl", quietly = TRUE)) {
          curl::curl_download(url, dest, mode = "wb", quiet = FALSE,
                              handle = curl::new_handle(timeout = timeout))
        } else {
          old_timeout <- getOption("timeout")
          options(timeout = max(timeout, old_timeout))
          on.exit(options(timeout = old_timeout), add = TRUE)
          download.file(url, dest, mode = "wb")
        }

        if (!is_valid_sqlite(dest)) {
          stop("Downloaded file '", f, "' is invalid. Check the URL or network.")
        }
      }
    }
  }

  invisible(normalizePath(dest_dir))
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
