# After installing the patched RxnSim, run in separate R sessions for each stack.
library(RxnSim)
library(fingerprint)
cat("rcdk", as.character(packageVersion("rcdk")),
    "rcdklibs", as.character(packageVersion("rcdklibs")), "\n")

calc <- getFromNamespace(".calcDistance", "RxnSim")
empty <- new("fingerprint", nbit = 1024L, bits = integer(0))
nonempty <- new("fingerprint", nbit = 1024L, bits = 5L)
for (metric in c("tanimoto", "jaccard")) {
    stopifnot(calc(empty, empty, metric) == 1)
    stopifnot(calc(empty, nonempty, metric) == 0)
    stopifnot(calc(nonempty, empty, metric) == 0)
    stopifnot(calc(nonempty, nonempty, metric) == 1)
}
# Do not change the results of other metrics.
stopifnot(identical(calc(empty, empty, "cosine"),
    fingerprint::distance(empty, empty, method = "cosine")))

rct1 <- "C(=O)C1(=CC=CC=C1).O=O.[OH2]>>[H+].C(C1(C=CC=CC=1))([O-])=O.OO"
rct2 <- "C(C=CC1(=CC=CC=C1))=O.O=O.[OH2]>>[H+].C(=O)([O-])C=CC1(=CC=CC=C1).OO"
for (verbose in c(FALSE, TRUE)) {
    score <- rs.compute(rct1, rct2, verbose = verbose)
    stopifnot(is.finite(score), score >= 0, score <= 1)
}
stopifnot(abs(rs.compute(rct1, rct1) - 1) < 1e-12)
