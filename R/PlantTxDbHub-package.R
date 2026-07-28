#' PlantTxDbHub: TxDb databases for plants
#'
#' @name PlantTxDbHub-package
#' @aliases PlantTxDbHub-package PlantTxDbHub
#'
#' @section Data sources and licensing:
#' The TxDb SQLite files distributed by this package are built from
#' publicly available genome annotation files, as recorded in
#' \code{inst/extdata/metadata.csv} (see the \code{DataProvider} and
#' \code{SourceUrl} columns):
#' \itemize{
#'   \item \strong{Ensembl Plants} (\url{https://plants.ensembl.org}) —
#'     \emph{Arabidopsis thaliana} (TAIR10), \emph{Glycine max} (Wm82 v2.1),
#'     and \emph{Oryza sativa} (IRGSP-1.0), release 62 GTF annotations.
#'     Ensembl data are freely available under their open data policy
#'     (\url{https://plants.ensembl.org/info/about/legal/disclaimer.html}).
#'   \item \strong{Phytozome} (\url{https://phytozome-next.jgi.doe.gov}) —
#'     \emph{Glycine max} (Wm82.a4.v1), Phytozome v14 GFF3 annotation.
#'     Phytozome data usage is subject to the JGI Data Usage Policy
#'     (\url{https://phytozome-next.jgi.doe.gov/help/policy.html}).
#' }
#' The underlying SQLite files are re-hosted on Zenodo for stable download
#' (see \code{Location_Prefix}/\code{RDataPath} in
#' \code{inst/extdata/metadata.csv}). Users should consult and comply with
#' the original data providers' license terms before redistributing derived
#' data. The R package code itself is released under the Artistic-2.0 license.
#'
#' @author Kabilan S
#' @keywords package
"_PACKAGE"
