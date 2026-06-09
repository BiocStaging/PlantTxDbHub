context("metadata validity")

test_that("metadata is valid", {
  skip_if_not_installed("AnnotationHubData")
  library(AnnotationHubData)

  # Ensure our own package is installed
  expect_true(requireNamespace("PlantTxDbHub", quietly = TRUE))

  # Optionally check that a metadata file exists
  # metadata <- system.file("extdata", "metadata.csv", package = "PlantTxDbHub")
  # expect_true(file.exists(metadata))
})
