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
