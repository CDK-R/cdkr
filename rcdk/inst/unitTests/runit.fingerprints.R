test.fp <- function() {
    mol <- parse.smiles("CCCCC")[[1]]
    fp <- get.fingerprint(mol, type='maccs')
    checkTrue(length(fp@bits) > 0)
    fp <- get.fingerprint(mol, type='kr')
    checkTrue(length(fp@bits) > 0)
    fp <- get.fingerprint(mol, type='shortestpath')
    checkTrue(length(fp@bits) > 0)
}

test.fp.explicit.hydrogens <- function() {
    proton <- parse.smiles("[H+]")[[1]]
    classes <- c(standard = "Fingerprinter", extended = "ExtendedFingerprinter",
                 graph = "GraphOnlyFingerprinter",
                 hybridization = "HybridizationFingerprinter")
    for (type in names(classes)) {
        # Check the legacy proton fingerprint and finite self-similarity.
        fp <- get.fingerprint(proton, type = type)
        checkTrue(length(fp@bits) > 0)
        checkEquals(1, fingerprint::distance(fp, fp, method = "tanimoto"))

        # Verify the R wrapper matches Java with explicit hydrogen hashing.
        mol <- parse.smiles("[H]C([H])([H])C")[[1]]
        jfp <- .jnew(paste0("org/openscience/cdk/fingerprint/", classes[[type]]),
                     as.integer(1024), as.integer(6))
        .jcall(jfp, "V", "setHashExplicitHydrogens", TRUE)
        bits <- .jcall(jfp, "Lorg/openscience/cdk/fingerprint/IBitFingerprint;",
                       "getBitFingerprint", mol)
        bits <- .jcall(bits, "Ljava/util/BitSet;", "asBitSet")
        bits <- .jcall(bits, "S", "toString")
        expected <- as.numeric(strsplit(gsub("[{}]", "", bits), ",")[[1]]) + 1
        checkEquals(expected, get.fingerprint(mol, type = type)@bits)
    }
    checkEquals(847, get.fingerprint(proton, type = "extended")@bits)
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

