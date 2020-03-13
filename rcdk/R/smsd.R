#' get.mcs
#' 
#' 
#' @param mol1 Required. First molecule to compare. Should be a `jobjRef` representing an `IAtomContainer`
#' @param mol2 Required. Second molecule to compare. Should be a `jobjRef` representing an `IAtomContainer`
#' @param as.molecule Optional. Default \code{TRUE}.
#' @export
get.mcs <- function(mol1, mol2, as.molecule = TRUE) {
  if (as.molecule) {
    return(.jcall("org.guha.rcdk.util.Misc",
           "Lorg/openscience/cdk/interfaces/IAtomContainer;",
           "getMcsAsNewContainerUIT", mol1, mol2))
  } else {
    arr <- .jcall("org.guha.rcdk.util.Misc",
           "[[I",
           "getMcsAsAtomIndexMapping", mol1, mol2)
    do.call('rbind', lapply(arr, .jevalArray, rawJNIRefSignature = "[I"))
  }
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
