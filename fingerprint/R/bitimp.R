bit.importance <- function(actives, database) {
  bs.actives <- bit.spectrum(actives)
  bs.database <- bit.spectrum(database)

  m <- length(actives)
  n <- length(database)
  pa <- (m*bs.actives+bs.database)/(m+1)
  pb <- (n*bs.database+bs.actives)/(n+1)

  kl <- pa * log(pa/pb) + (1-pa) * log( (1-pa)/(1-pb) )
  kl[is.nan(kl)] <- NA
  return(kl)
}
