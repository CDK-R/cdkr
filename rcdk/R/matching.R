matches <- function(query, targets) {
  if (!is.list(targets)) targets <- list(targets)
  if (!all(unlist(lapply(targets, class)) == 'jobjRef'))
    stop("targets must be a list of IAtomContainer objects or a single IAtomContainer object")

  ## make an SQT
  sqt <- new(J("org/openscience/cdk/smiles/smarts/SMARTSQueryTool"), query)
  matchings <- unlist(lapply(targets, function(z) sqt$matches(z)))
  matchings
}
