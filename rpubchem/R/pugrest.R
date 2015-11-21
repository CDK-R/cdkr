.read.url <- function(url) {
  h = basicTextGatherer()
  status = curlPerform(url = url,
              writefunction = h$update)
  val <- h$value()
  if (str_detect(val, "Status: 404")) return(NULL)
  return(val)
}
.ids.for.aid <- function(aid, type='cid', quiet=TRUE) {
  if (!(type %in% c('cid', 'sid'))) stop("type must be 'cid' or 'sid'")
  url <- sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/%ss/TXT', aid, type)
  if (!quiet) cat("URL:", url, "\n")
  h = basicTextGatherer()
  curlPerform(url = url,
              writefunction = h$update)
  cids <- as.integer(read.table(textConnection(h$value()), header=FALSE)[,1])
  return(cids)
}
