#' Download plant TxDb SQLite files from Zenodo
#'
#' This function downloads the three plant TxDb SQLite databases
#' (Arabidopsis thaliana TAIR10, Glycine max Wm82, Oryza sativa IRGSP‑1.0)
#' from the Zenodo record to a local directory.
#'
#' @param dest_dir A character string specifying the directory where the
#'   SQLite files should be stored. Defaults to `"plant_txdb_sqlite"` in the
#'   current working directory.
#'
#' @return Invisibly returns the path to the destination directory.
#' @export
#'
#' @examples
#' \dontrun{
#'   downloadPlantTxDbs()
#' }
downloadPlantTxDbs <- function(dest_dir = "plant_txdb_sqlite") {
  base_url <- "https://zenodo.org/record/20606038/files"
  files <- c(
    "TxDb.Athaliana.TAIR10.v62.sqlite",
    "TxDb.Gmax.Wm82.v62.sqlite",
    "TxDb.Osativa.IRGSP.v62.sqlite"
  )

  dir.create(dest_dir, showWarnings = FALSE, recursive = TRUE)

  for (f in files) {
    dest <- file.path(dest_dir, f)
    if (!file.exists(dest)) {
      download.file(
        url = paste0(base_url, "/", f, "?download=1"),
        destfile = dest,
        mode = "wb"
      )
    }
  }

  invisible(dest_dir)
}
