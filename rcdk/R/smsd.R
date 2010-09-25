get.mcs <- function(mol1, mol2, method = "MCSPlus") {
  isoType <- .jcall("org.openscience.cdk.smsd.interfaces.Algorithm",
                    "Lorg/openscience/cdk/smsd/interfaces/Algorithm;",
                    "valueOf", method)
  iso <- .jnew("org.openscience.cdk.smsd.Isomorphism",
               isoType, TRUE);
  .jcall(iso, "V", "init", mol1, mol2, TRUE, TRUE)
  .jcall(iso, "V", "setChemFilters", TRUE, TRUE, TRUE)
}

is.subgraph <- function(query, target) {
  if (class(query) == 'character') {
    query <- parse.smiles(query)
    do.aromaticity(query)
    do.typing(query)
  }

  if (!is.list(target)) target <- list(target)
  if (!all(unlist(lapply(target, class)) == 'jobjRef'))
    stop("targets must be a list of IAtomContainer objects or a single IAtomContainer object")
  
  method <- 'TurboSubStructure'
  isoType <- .jcall("org.openscience.cdk.smsd.interfaces.Algorithm",
                    "Lorg/openscience/cdk/smsd/interfaces/Algorithm;",
                    "valueOf", method)
  iso <- .jnew("org.openscience.cdk.smsd.Isomorphism",
               isoType, TRUE);
  unlist(lapply(target, function(x) {
    .jcall(iso, "V", "init", query, x, TRUE, TRUE)
    .jcall(iso, "V", "setChemFilters", FALSE, FALSE, FALSE)
    .jcall(iso, "Z", "isSubgraph")
  }))
}
