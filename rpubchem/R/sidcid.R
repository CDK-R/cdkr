.extract.fields <- function(doc) {

  .itemNames <- c('IUPACName','CanonicalSmiles','MolecularFormula','MolecularWeight', 'TotalFormalCharge',
                  'XLogP', 'HydrogenBondDonorCount', 'HydrogenBondAcceptorCount',
                  'HeavyAtomCount', 'TPSA')
  docsums <- getNodeSet(doc, '/eSummaryResult/DocSum')
  ret <- lapply(docsums, function(docsum) {
    nodes <- Filter(function(x) xmlGetAttr(x, 'Name') %in% .itemNames, docsum['Item'])

    ## Need to handle Pubchem weirdness
    if (length(nodes) != length(.itemNames)) {
      tmp <- .itemNames
      tmp[2] <- 'CanonicalSmile'
      nodes <- Filter(function(x) xmlGetAttr(x, 'Name') %in% tmp, docsum['Item'])      
      if (length(nodes) != length(tmp)) stop("Pubchem eUtils XML format has changed (?)")
    }

    values <- sapply(nodes, xmlValue)
    values <- t(values)
    dat <- data.frame(values)
    names(dat) <- .itemNames

    ## set types appropriately
    types <- sapply(nodes, function(x) xmlGetAttr(x, 'Type'))
    for (i in 1:length(types)) {
      if (types[i] == 'String') dat[,i] <- as.character(dat[,i])
      else if (types[i] == 'Integer') dat[,i] <- as.integer(dat[,i])
      else if (types[i] == 'Float') dat[,i] <- as.numeric(dat[,i])    
    }

    ## Look for the CompoundIdList item
    cid <- NA
    cidl <- Filter(function(x) xmlGetAttr(x, 'Name') == 'CompoundIDList', docsum['Item'])
    if (length(cidl) > 0) {
      cid <- xmlValue(cidl['Item'][[1]])
    }
    return(cbind(CID=cid, dat))
  })
  return(do.call(rbind, ret))
}

get.sid <- function(sid, quiet=TRUE, from.file=FALSE) {
  
  datafile <- NA
  
  if (!from.file) {
    sidURL <- 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=rpubchem&db=pcsubstance&id='
    url <- paste(sidURL, paste(sid,sep='',collapse=','), sep='', collapse='')
    datafile <- tempfile(pattern = 'sid')
    .get.xml.file(url, datafile, quiet)
  } else {
    datafile <- sid
  }

  doc <- xmlParse(datafile)
  .extract.fields(doc)
}

get.cid <- function(cid, quiet=TRUE, from.file=FALSE) {

  datafile <- NA
  
  if (!from.file) {
    cidURL <- 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=rpubchem&db=pccompound&id='
    url <- paste(cidURL, paste(cid,sep='',collapse=','), sep='', collapse='')
    datafile <- tempfile(pattern = 'cid')
    .get.xml.file(url, datafile, quiet)
  } else {
    datafile <- cid
  }

  doc <- xmlParse(datafile)
  dat <- .extract.fields(doc)
  dat$CID <- cid
  return(dat)
}

get.cid.list <- function(sid,  quiet=TRUE, from.file=FALSE) {
  datafile <- NA
  
  if (!from.file) {
    sidURL <- 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=rpubchem&db=pcsubstance&id='
    url <- paste(sidURL, paste(sid,sep='',collapse=','), sep='', collapse='')
    datafile <- tempfile(pattern = 'sid')
    .get.xml.file(url, datafile, quiet)
  } else {
    datafile <- sid
  }

  doc <- xmlParse(datafile)
  
  docsums <- getNodeSet(doc, '/eSummaryResult/DocSum')
  ret <- lapply(docsums, function(docsum) {
    nodes <- Filter(function(x) xmlGetAttr(x, 'Name') == 'CompoundIDList', docsum['Item'])
    cids <- c(NA)
    if (length(nodes) > 0 && length(nodes[[1]][[1]])) {
      cids <- sapply(nodes[[1]]['Item'], xmlValue)
    }
    return(data.frame(SID=xmlValue(docsum[['Id']]), CID=cids))
  })
  ret <- do.call(rbind, ret)
  rownames(ret) <- NULL
  return(ret)
}

get.sid.list <- function(cid, quiet=TRUE, from.file=FALSE) {
  
  datafile <- NA
  
  if (!from.file) {
    cidURL <- 'http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=rpubchem&db=pccompound&id='
    url <- paste(cidURL, paste(cid,sep='',collapse=','), sep='', collapse='')
    datafile <- tempfile(pattern = 'cid')
    .get.xml.file(url, datafile, quiet)
  } else {
    datafile <- cid
  }
  
  doc <- xmlParse(datafile)
  docsums <- getNodeSet(doc, '/eSummaryResult/DocSum')
  ret <- lapply(docsums, function(docsum) {
    nodes <- Filter(function(x) xmlGetAttr(x, 'Name') == 'SubstanceIDList', docsum['Item'])
    ids <- NA
    if (length(nodes) > 0 && length(nodes[[1]][[1]]) > 0) {
      print(nodes[[1]])
      print(length(nodes[[1]][[1]]))
      ids <- sapply(nodes[[1]]['Item'], xmlValue)
    }
    return(data.frame(CID=xmlValue(docsum[['Id']]), SID=ids))
  })
  ret <- do.call(rbind, ret)
  rownames(ret) <- NULL
  return(ret)
  
}
