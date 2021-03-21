#' Generate Bemis-Murcko Fragments
#' 
#' Fragment the input molecule using the Bemis-Murcko scheme
#' 
#' A variety of methods for fragmenting molecules are available ranging from
#' exhaustive, rings to more specific methods such as Murcko frameworks. Fragmenting a
#' collection of molecules can be a useful for a variety of analyses. In addition
#' fragment based analysis can be a useful and faster alternative to traditional 
#' clustering of the whole collection, especially when it is large.
#' 
#' Note that exhaustive fragmentation of large molecules (with many single bonds) can become
#' time consuming.
#' 
#' @param mols A list of `jobjRef` objects of Java class `IAtomContainer`
#' @param min.frag.size The smallest fragment to consider (in terms of heavy atoms)
#' @param as.smiles If `TRUE` return the fragments as SMILES strings. If not, then fragments
#' are returned as `jobjRef` objects
#' @param single.framework If `TRUE`, then a single framework (i.e., the framework consisting of the
#' union of all ring systems and linkers) is returned for each molecule. Otherwise, all combinations
#' of ring systems and linkers are returned
#' @return Returns a list with each element being a list with two elements: `rings` and
#' `frameworks`. Each of these elements is either a character vector of SMILES strings or a list of
#' `IAtomContainer` objects.
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @seealso [get.exhuastive.fragments()]
#' @export
#' @examples 
#' mol <- parse.smiles('c1ccc(cc1)CN(c2cc(ccc2[N+](=O)[O-])c3c(nc(nc3CC)N)N)C')[[1]]
#' mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=TRUE)
#' mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=FALSE)
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

#' @inherit get.murcko.fragments 
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @seealso [get.murcko.fragments()]
#' @export
#' @return returns a list of length equal to the number of input molecules. Each
#' element is a character vector of SMILES strings or a list of `jobjRef` objects.
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
