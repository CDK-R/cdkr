bit.importance <- function(actives, background) {
  bs.actives <- bit.spectrum(actives)
  bs.background <- bit.spectrum(background)

  m <- length(actives)
  n <- length(background)
  pa <- (m*bs.actives+bs.background)/(m+1)
  pb <- (n*bs.background+bs.actives)/(n+1)

  kl <- pa * log(pa/pb) + (1-pa) * log( (1-pa)/(1-pb) )
  kl[is.nan(kl)] <- NA
  return(kl)
}
