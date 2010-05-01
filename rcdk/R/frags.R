get.fragmenter <- function() {
  return(.jnew("org/openscience/cdk/tools/GenerateFragments"))
}

get.murcko.fragments <- function(mol, fragmenter, min.ring.size = 6, as.smiles = TRUE) {
  if (is.null(attr(mol, 'jclass')) ||
      attr(mol, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  
  if (missing(fragmenter)) {
    fragmenter <- get.fragmenter()
  }

  convert.implicit.to.explicit(mol)
  
  .jcall(fragmenter, "V", "generateMurckoFragments",
         .jcast(mol, "org/openscience/cdk/interfaces/IMolecule"),
         TRUE, TRUE, as.integer(min.ring.size))

  if (as.smiles) {
    frags <- .jcall(fragmenter, "[S", "getMurckoFrameworksAsSmileArray")
  } else {
    tmp <- .jcall(fragmenter, "Ljava/util/List;", "getMurckoFrameworks")
    nfrag <- .jcall(tmp, "I", "size")
    frags <- list()
    for (i in seq_len(nfrag)-1) {
      afrag <- .jcall(tmp, "Ljava/lang/Object;", "get", as.integer(i))
      afrag <- .jcast(tmp, "org/openscience/cdk/interfaces/IAtomContainer")
      frags[[i+1]] <- afrag
    }
  }
  return(frags)
}

.get.ring.fragments <- function(mol, fragmenter, as.smiles = TRUE) {
  if (is.null(attr(mol, 'jclass')) ||
      attr(mol, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  
  if (missing(fragmenter)) {
    fragmenter <- get.fragmenter()
  }

  convert.implicit.to.explicit(mol)
  
  .jcall(fragmenter, "V", "generateRingFragments",
         .jcast(mol, "org/openscience/cdk/interfaces/IMolecule"))

  if (as.smiles) {
    frags <- .jcall(fragmenter, "[S", "getRingFragmentsAsSmileArray")
  } else {
    tmp <- .jcall(fragmenter, "Ljava/util/List;", "getRingFragments")
    return(tmp)
  }
  return(frags)
}
