get.murcko.fragments <- function(mols, min.frag.size = 6, as.smiles = TRUE, single.framework = FALSE) {
  if (!is.list(mols)) mols <- list(mols)
  klasses <- unlist(lapply(mols, function(x) attr(x, "jclass")))
  if (!all(klasses ==  "org/openscience/cdk/interfaces/IAtomContainer")) {
    stop("Must supply an IAtomContainer object")
  }

  fragmenter <- .jnew("org/openscience/cdk/fragment/MurckoFragmenter",
                      single.framework, as.integer(min.frag.size))
  
  ret <- lapply(mols, function(x) {
    .jcall(fragmenter, "V", "generateFragments", x)
    if (as.smiles) {
      rings <- .jcall(fragmenter, "[S", "getRingSystems")
      frames <- .jcall(fragmenter, "[S", "getFrameworks")
    } else {
      rings <- .jcall(fragmenter, "[Lorg/openscience/cdk/interfaces/IAtomContainer;", "getRingSystemsAsContainers")
      frames <- .jcall(fragmenter, "[Lorg/openscience/cdk/interfaces/IAtomContainer;", "getFrameworksAsContainers")
    }
    return(list(rings = rings, frameworks = frames))    
  })
  return(ret)
}

get.exhaustive.fragments <- function(mols, min.frag.size = 6, as.smiles = TRUE) {
  if (!is.list(mols)) mols <- list(mols)
  klasses <- unlist(lapply(mols, function(x) attr(x, "jclass")))
  if (!all(klasses ==  "org/openscience/cdk/interfaces/IAtomContainer")) {
    stop("Must supply an IAtomContainer object")
  }

  fragmenter <- .jnew("org/openscience/cdk/fragment/ExhaustiveFragmenter", as.integer(min.frag.size))

  ret <- lapply(mols, function(x) {
    .jcall(fragmenter, "V", "generateFragments", x)
    if (as.smiles) {
      fragments <- .jcall(fragmenter, "[S", "getFragments")
    } else {
      fragments <- .jcall(fragmenter, "[Lorg/openscience/cdk/interfaces/IAtomContainer;", "getFragmentsSystemsAsContainers")
    }
    return(fragments)    
  })
  return(ret)
}
