test.fp <- function() {
    mol <- parse.smiles("CCCCC")[[1]]
    fp <- get.fingerprint(mol, type='maccs')
    checkTrue(length(fp@bits) > 0)

    # Skip slow tests during CRAN check (use multiple detection methods)
    is_cran_check <- Sys.getenv("_R_CHECK_PACKAGE_NAME_", "") != "" ||
                     Sys.getenv("_R_CHECK_TIMINGS_", "") != "" ||
                     identical(Sys.getenv("NOT_CRAN"), "false")

    if (!is_cran_check) {
        fp <- get.fingerprint(mol, type='kr')
        checkTrue(length(fp@bits) > 0)
        fp <- get.fingerprint(mol, type='shortestpath')
        checkTrue(length(fp@bits) > 0)
    }
}

# Substructure test are inspired by the test for the substructure fingerprints in CDK
test.fp.substructures.binary <- function() {
    # Default patterns: functional groups
    mol <- parse.smiles("c1ccccc1CCC")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="bit")
    fp_bits <- fingerprint::fp.to.matrix(list(fp))

    checkEquals(length(fp), 307)
    checkEquals(fp_bits[1], 1)
    checkEquals(fp_bits[2], 1)
    checkEquals(fp_bits[274], 1)
    checkEquals(fp_bits[101], 0)

    # User defined patterns
    smarts <- c("c1ccccc1", "[CX4H3][#6]", "[CX2]#[CX2]")
    mol <- parse.smiles("c1ccccc1CCC")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="bit",
                          substructure.pattern = smarts)
    fp_bits <- fingerprint::fp.to.matrix(list(fp))

    checkEquals(length(fp), 3)
    checkEquals(length(fp@bits), 2)
    checkEquals(fp_bits[1], 1)
    checkEquals(fp_bits[2], 1)
    checkEquals(fp_bits[3], 0)

    mol <- parse.smiles("C=C=C")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="bit",
                          substructure.pattern = smarts)
    fp_bits <- fingerprint::fp.to.matrix(list(fp))

    checkEquals(length(fp), 3)
    checkEquals(length(fp@bits), 0)
    for (i_fp in 1:3) {
        checkEquals(fp_bits[i_fp], 0)
    }

    # Check for aromatic ring
    smarts <- "a:1:a:a:a:a:a1"
    mol <- parse.smiles("C1=CC=CC(=C1)CCCC2=CC=CC=C2")[[1]]
    set.atom.types(mol)
    do.aromaticity(mol)
    fp <- get.fingerprint(mol, type="substructure", fp.mode="bit",
                          substructure.pattern = smarts)
    fp_bits <- fingerprint::fp.to.matrix(list(fp))
    checkEquals(length(fp), 1)
    checkEquals(fp_bits[1], 1)
}

test.fp.substructures.count <- function() {
    # Default patterns: functional groups
    mol <- parse.smiles("c1ccccc1CCC")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="count")

    checkEquals(length(fp), 307)
    checkTrue(fingerprint::count(fp@features[[1]]) > 0)
    checkTrue(fingerprint::count(fp@features[[2]]) > 0)
    checkTrue(fingerprint::count(fp@features[[274]]) > 0)
    checkTrue(fingerprint::count(fp@features[[101]]) == 0)

    # User defined patterns
    smarts <- c("c1ccccc1", "[CX4H3][#6]", "[CX2]#[CX2]")
    mol <- parse.smiles("c1ccccc1CCC")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="count",
                          substructure.pattern = smarts)

    checkEquals(length(fp), 3)
    checkEquals(fingerprint::count(fp@features[[1]]), 1)
    checkEquals(fingerprint::count(fp@features[[2]]), 1)
    checkEquals(fingerprint::count(fp@features[[3]]), 0)

    mol <- parse.smiles("C=C=C")[[1]]
    fp <- get.fingerprint(mol, type="substructure", fp.mode="count",
                          substructure.pattern = smarts)

    checkEquals(length(fp), 3)
    for (i_fp in 1:3) {
        checkEquals(fingerprint::count(fp@features[[i_fp]]), 0)
    }

    # Check for aromatic ring
    smarts <- "a:1:a:a:a:a:a1"
    mol <- parse.smiles("C1=CC=CC(=C1)CCCC2=CC=CC=C2")[[1]]
    set.atom.types(mol)
    do.aromaticity(mol)
    fp <- get.fingerprint(mol, type="substructure", fp.mode="count",
                          substructure.pattern = smarts)

    checkEquals(length(fp), 1)
    checkEquals(fingerprint::count(fp@features[[1]]), 2)
}
