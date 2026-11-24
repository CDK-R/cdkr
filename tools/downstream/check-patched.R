# Run from this repository root with R_LIBS_USER selecting baseline or candidate.
# Sources must first be extracted and patched under .release/patches/.
label <- commandArgs(trailingOnly = TRUE)
stopifnot(length(label) == 1L, label %in% c("old", "new"))
# Match revdepcheck's default treatment of optional suggested packages.
Sys.setenv("_R_CHECK_FORCE_SUGGESTS_" = "false")
cat("rcdk", as.character(packageVersion("rcdk")),
    "rcdklibs", as.character(packageVersion("rcdklibs")), "\n")
if (label == "old") {
    stopifnot(packageVersion("rcdk") == "3.8.2",
        packageVersion("rcdklibs") == "2.9")
} else {
    stopifnot(packageVersion("rcdklibs") == "2.14.1")
}
for (pkg in c("RxnSim", "FastRet")) {
    out <- file.path(".release", "results", paste0(pkg, "-patched-", label))
    dir.create(out, showWarnings = FALSE)
    result <- rcmdcheck::rcmdcheck(file.path(".release", "patches", pkg),
        args = c("--no-manual", "--no-build-vignettes"),
        check_dir = normalizePath(out), error_on = "never")
    saveRDS(result, paste0(out, ".rds"))
    if (length(result$errors)) stop(pkg, ": check errors")
}
