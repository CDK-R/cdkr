#' matches 
#' 
#' @param query Required. A SMARTSQuery
#' @param target Required. The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param return.matches Optional. Default \code{FALSE}
#' @export
#' @aliases match-SMARTS
matches <- function(query, target, return.matches=FALSE) {
  if (!is.list(target)) target <- list(target)
  if (!all(unlist(lapply(target, class)) == 'jobjRef'))
    stop("targets must be a list of IAtomContainer objects or a single IAtomContainer object")

  dcob <- get.chem.object.builder()

  ## make an SQT
  sqt <- new(J("org/openscience/cdk/smiles/smarts/SMARTSQueryTool"), query, dcob)
  matchings <- unlist(lapply(target, function(z) sqt$matches(z)))

  matchings <- lapply(target, function(z) {
    status <- sqt$matches(z)
    if (status) {
      mappings <- sqt$getUniqueMatchingAtoms()
      mappings <- lapply(1:mappings$size(), function(i) {
        atomIndices <- mappings$get(as.integer(i-1))
        atomIndinces <- .javalist.to.rlist(atomIndices)
        sapply(atomIndices, .jsimplify)
      })
    } else{
      mappings <- NULL
    }
    return(list(match=status, mapping=mappings))
  })

  if (!return.matches) return(unlist(lapply(matchings, "[", 1)))
  else {
    return(matchings)
  }
}
