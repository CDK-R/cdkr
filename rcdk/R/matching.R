matches <- function(query, target) {
  if (!is.list(targets)) target <- list(target)
  if (!all(unlist(lapply(target, class)) == 'jobjRef'))
    stop("targets must be a list of IAtomContainer objects or a single IAtomContainer object")

  ## make an SQT
  sqt <- new(J("org/openscience/cdk/smiles/smarts/SMARTSQueryTool"), query)
  matchings <- unlist(lapply(target, function(z) sqt$matches(z)))
  matchings
}
