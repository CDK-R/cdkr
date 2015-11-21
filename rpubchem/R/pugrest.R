.read.url <- function(url) {
  h = basicTextGatherer()
  status = curlPerform(url = url,
              writefunction = h$update)
  val <- h$value()
  if (str_detect(val, "Status: 404")) return(NULL)
  return(val)
}
.cids.for.aid <- function(aid) {
  url <- sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/cids/TXT', aid)
  h = basicTextGatherer()
  curlPerform(url = url,
              writefunction = h$update)
  cids <- as.integer(read.table(textConnection(h$value()), header=FALSE)[,1])
  return(cids)
}
