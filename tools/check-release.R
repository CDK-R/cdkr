# Run from the repository root with JAVA_HOME set to a usable JDK.
# Prerequisites in .release/lib: rcdklibs 2.14.1, revdepcheck, rcmdcheck.
# Staging keeps GitHub-only Remotes and revdep artifacts out of the CRAN package.
local_lib <- normalizePath(".release/lib", mustWork = TRUE)
.libPaths(c(local_lib, .libPaths()))
stopifnot(as.character(packageVersion("rcdklibs")) == "2.14.1")
sha <- "bf933d76929ab9a5835881a1a099e27eccfe849a"
stopifnot(packageDescription("rcdklibs")$RemoteSha == sha)
options(repos = c(CRAN = "https://cloud.r-project.org"))

run_dir <- tempfile(pattern = paste0(format(Sys.time(), "%Y%m%d-%H%M%S"), "-"),
    tmpdir = ".release")
dir.create(run_dir)
candidate <- file.path(run_dir, "candidate")
if (!dir.exists(candidate)) {
    dir.create(candidate)
    stopifnot(all(file.copy(
        list.files("rcdk", full.names = TRUE, all.files = TRUE, no.. = TRUE),
        candidate, recursive = TRUE
    )))
    desc <- file.path(candidate, "DESCRIPTION")
    d <- read.dcf(desc)
    d[1, "Remotes"] <- paste(d[1, "Remotes"],
        paste0("CDK-R/rcdklibs@", sha), sep = ", ")
    write.dcf(d, desc)
}

results <- file.path(run_dir, "results")
dir.create(results)
message("Release check artifacts: ", normalizePath(run_dir))
capture.output(sessionInfo(), file = file.path(results, "session-info.txt"))
check <- rcmdcheck::rcmdcheck(candidate, args = "--no-manual",
    check_dir = normalizePath(results), error_on = "never")
saveRDS(check, file.path(results, "package-check.rds"))
if (length(check$errors) || length(check$warnings)) {
    stop("Resolve package check errors and warnings before reverse-dependency checks.")
}
if (!"--revdeps" %in% commandArgs(trailingOnly = TRUE)) {
    quit(status = 0)
}

# revdep_check resumes its on-disk database after an interrupted run.
# Defaults include Depends, Imports, Suggests, and LinkingTo.
revdepcheck::revdep_check(candidate, cran = TRUE, bioc = TRUE,
    num_workers = 2, timeout = as.difftime(30, units = "mins"))
revdepcheck::revdep_report(candidate, all = TRUE, cran = TRUE, bioc = TRUE)
