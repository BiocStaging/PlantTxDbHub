# zzz.R – Package startup hooks

.onLoad <- function(libname, pkgname) {
  # For now, no automatic actions.
  # Future: set up AnnotationHub datacache environment here.
  invisible()
}

.onUnload <- function(libpath) {
  # Clean up if needed (e.g., close a database connection)
  invisible()
}
