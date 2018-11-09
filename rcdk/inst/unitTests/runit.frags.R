test.frag1 <- function() {
  m <- parse.smiles("c1(ccc(cc1C)CCC(C(CCC)C2C(C2)CC)C3C=C(C=C3)CC)C")[[1]]
  do.aromaticity(m)  
  do.typing(m)
  f <- get.murcko.fragments(m, as.smiles=TRUE, min.frag.size = 6, single.framework = TRUE)
  checkEquals(length(f), 1)
  checkEquals(length(f[[1]]$rings), 1)
  checkEquals(f[[1]]$rings, "c1ccccc1")
  checkEquals(f[[1]]$frameworks, "c1ccc(cc1)CCC(CC2CC2)C3C=CC=C3")
}

test.frag2 <- function() {
  ms <- parse.smiles(c('c1(ccc(cc1C)CCC(C(CCC)C2C(C2)CC)C3C=C(C=C3)CC)C',
                       'c1ccc(cc1)c2c(oc(n2)N(CCO)CCO)c3ccccc3',
                       'COc1ccc(cc1OCc2ccccc2)C(=S)N3CCOCC3'))
  lapply(ms, do.aromaticity)  
  lapply(ms, do.typing)
  f <- get.murcko.fragments(ms, as.smiles=TRUE, min.frag.size = 6, single.framework = TRUE)
  checkEquals(length(f), 3)

  fworks <- unlist(lapply(f, function(x) length(x$frameworks)))
  checkTrue(all(fworks == 1))
}

test.frag3 <- function() {
  ms <- parse.smiles(c('c1(ccc(cc1C)CCC(C(CCC)C2C(C2)CC)C3C=C(C=C3)CC)C',
                       'c1ccc(cc1)c2c(oc(n2)N(CCO)CCO)c3ccccc3',
                       'COc1ccc(cc1OCc2ccccc2)C(=S)N3CCOCC3'))
  lapply(ms, do.aromaticity)  
  lapply(ms, do.typing)
  f <- get.murcko.fragments(ms, as.smiles=FALSE, min.frag.size = 6, single.framework = TRUE)
  checkEquals(length(f), 3)

  fworks <- unlist(lapply(f, function(x) unlist(lapply(x$frameworks, .jclass))))
  checkTrue(all(fworks == "org.openscience.cdk.silent.AtomContainer2"))
}
