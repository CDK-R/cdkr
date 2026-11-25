# Select one dependency stack with R_LIBS_USER and run in a fresh R process.
# Usage: Rscript tools/downstream/diagnose-stack.R .release/diagnosis/new.rds
library(rcdk)
library(FastRet)
out <- commandArgs(trailingOnly = TRUE)
stopifnot(length(out) == 1L)
options(FastRet.cache_dir = file.path(tempdir(), "FastRet-diagnosis-cache"))
Sys.setenv(FASTRET_CACHE_DIR = getOption("FastRet.cache_dir"))

mol <- parse.smiles("[H+]")[[1]]
jfp <- rJava::.jnew("org/openscience/cdk/fingerprint/ExtendedFingerprinter",
    as.integer(1024), as.integer(6))
java_bits <- function() {
    fp <- rJava::.jcall(jfp, "Lorg/openscience/cdk/fingerprint/IBitFingerprint;",
        "getBitFingerprint", mol)
    bits <- rJava::.jcall(fp, "Ljava/util/BitSet;", "asBitSet")
    rJava::.jcall(bits, "S", "toString")
}
default_bits <- java_bits()
hydrogen_bits <- tryCatch({
    rJava::.jcall(jfp, "V", "setHashExplicitHydrogens", TRUE)
    java_bits()
}, error = function(e) conditionMessage(e))
klass <- rJava::.jcall(jfp, "Ljava/lang/Class;", "getClass")
resource <- rJava::.jcall(klass, "Ljava/net/URL;", "getResource",
    "/org/openscience/cdk/fingerprint/ExtendedFingerprinter.class")
origin <- rJava::.jcall(resource, "S", "toString")

ns <- asNamespace("FastRet")
X <- FastRet::RP[1:5, ]
features <- get("CDFeatures", ns)
fresh <- get("compute_cds", ns)(X$SMILES)
cached <- getCDs(X, verbose = 0)
res <- list(
    rcdk = as.character(packageVersion("rcdk")),
    rcdklibs = as.character(packageVersion("rcdklibs")),
    fingerprint_class_origin = origin,
    java_default_bits = default_bits,
    java_hydrogen_bits = hydrogen_bits,
    r_bits = get.fingerprint(mol, type = "extended")@bits,
    descriptor_classes = get.desc.names(),
    requested_classes = get("CDNames", ns),
    features = features,
    fresh = fresh[, features, drop = FALSE],
    cached = cached[, features, drop = FALSE]
)
saveRDS(res, out)
print(res[c("rcdk", "rcdklibs", "fingerprint_class_origin",
    "java_default_bits", "java_hydrogen_bits", "r_bits")])
cat("Discovered descriptors:", length(res$descriptor_classes),
    "requested:", length(res$requested_classes),
    "selected columns:", length(features), "\n")
