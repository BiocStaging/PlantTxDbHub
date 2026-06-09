#' Download plant TxDb SQLite files from Zenodo
#'
#' Downloads the three plant transcript annotation databases
#' (Arabidopsis thaliana TAIR10, Glycine max Wm82, Oryza sativa IRGSP-1.0)
#' from Zenodo record 20606038. Files are stored in a persistent user
#' data directory and are re-downloaded automatically if corrupted.
#'
#' @param dest_dir A character string specifying where to save the SQLite files.
#'   Defaults to a package-specific user data directory (see
#'   [tools::R_user_dir()]).
#' @param timeout Numeric. Maximum download time in seconds per file.
#'   Default 300 (5 minutes).
#' @param download Logical. If `TRUE` (default), files are actually downloaded.
#'   If `FALSE`, the function only prepares the directory and returns its path
#'   without attempting any download.
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
#' # Actual download (requires internet)
#' downloadPlantTxDbs()
#' }
downloadPlantTxDbs <- function(dest_dir = tools::R_user_dir("PlantTxDbHub", "data"),
                               timeout = 300,
                               download = TRUE) {
  base_url <- "https://zenodo.org/record/20606038/files"
  files <- c(
    "TxDb.Athaliana.TAIR10.v62.sqlite",
    "TxDb.Gmax.Wm82.v62.sqlite",
    "TxDb.Osativa.IRGSP.v62.sqlite"
  )

  if (!dir.exists(dest_dir)) {
    ok <- dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)
    if (!ok || !dir.exists(dest_dir)) {
      stop("Failed to create directory: ", dest_dir,
           "\nPlease check permissions or provide a custom dest_dir.")
    }
  }

  if (download) {
    for (f in files) {
      dest <- file.path(dest_dir, f)
      if (!file.exists(dest) || !is_valid_sqlite(dest)) {
        if (file.exists(dest)) {
          message("File '", f, "' appears corrupted. Re-downloading...")
          unlink(dest)
        }
        message("Downloading: ", f)
        url <- paste0(base_url, "/", f, "?download=1")

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
