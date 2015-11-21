.load.pug.query <- function(query.filename) {
  path <- system.file('pugxml', query.filename, package='rpubchem')
  doc <- xmlParse(path)
  return(doc)
}
.xml2pugq <- function(xml) {
  s <- saveXML(xml)
  s <- gsub('<\\?xml version="1\\.0"\\?>', '', s)
  s <- gsub("\\n", "", s)
  return(s)
}
.get.poll.xml <- function(reqid) {
  d <- .load.pug.query("pug-poll.xml")
  n <- getNodeSet(d, "//PCT-Request_reqid")[[1]]
  xmlValue(n) <- reqid
  return(d)
}

.poll.pubchem <- function(reqid) {
  root <- NA
  pstring <- .xml2pugq(.get.poll.xml(reqid))
  reqid <- NA
  while(TRUE) {
    h = basicTextGatherer()
    curlPerform(url = 'http://pubchem.ncbi.nlm.nih.gov/pug/pug.cgi',
                postfields = pstring,
                writefunction = h$update)
    ## see if we got a waiting response
    root <- xmlRoot(xmlTreeParse(h$value(), asText=TRUE, asTree=TRUE))
    reqid <- xmlElementsByTagName(root, 'PCT-Waiting', recursive=TRUE)
    if (length(reqid) != 0) next
    break
  }
  return(root)
}
