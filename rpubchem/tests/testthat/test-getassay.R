context("Get assay metadata")
test_that("Assay description retrieves related AIDs", {
  d <- get.assay.desc(1653)
  expect_true(length(d$aids) > 0, TRUE)
})

test_that("Assay description retrieves related PMIDs", {
  d <- get.assay.desc(1653)
  expect_true(length(d$pmids) > 0, TRUE)
})
