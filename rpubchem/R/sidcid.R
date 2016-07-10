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

.isinchikey <- function(s) { 
     (s==toupper(s))&(nchar(s) == 27)&(substr(s,15,15)=="-")&(substr(s,26,26)=="-") }

get.cid <- function(cid, quiet=TRUE) {
  url <- sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug_view/data/compound/%d/JSON', cid)
  page <- .read.url(url)
  if (is.null(page)) {
    warning(sprintf("No data found for %d", cid))
    return(NULL)
  }
  record <- fromJSON(content=page)$Record
  sections <- record$Section

  ## Identifiers
  ids <- .section.by.heading(sections, "Names and Identifiers")
  ids <- .section.by.heading(ids$Section, "Computed Descriptors")
  ivals <- lapply(ids$Section, .section.handler)
  ivals <- do.call(cbind, unlist(Filter(function(x) !is.null(x), ivals), recursive=FALSE))  

  ## Process chemprops
  props <- .section.by.heading(sections, "Chemical and Physical Properties")
  if (is.null(props)) {
    warning(sprintf("No phys/chem properties section for %d", cid))
    return(NULL)
  }
  
  computed <- .section.by.heading(props$Section, "Computed Properties")
  cvals <- lapply(computed$Section, .section.handler,
                  ignore= c("CACTVS Substructure Key Fingerprint",
                    "Compound Is Canonicalized",
                    "Covalently-Bonded Unit Count"))
  cvals <- do.call(cbind, unlist(Filter(function(x) !is.null(x), cvals), recursive=FALSE))
          
  experimental <- .section.by.heading(props$Section, "Experimental Properties")
  if (is.null(experimental)) {
    evals <- data.frame(pKa=NA,"Kovats Retention Index"=NA)
  } else {
    evals <- lapply(experimental$Section, .section.handler,
                    keep = c('pKa', "Kovats Retention Index"))
    evals <- unlist(Filter(function(x) !is.null(x), evals), recursive=FALSE)
    if (is.null(evals))
      evals <- data.frame(pKa=NA, "Kovats Retention Index"=NA)
    else
      evals <- do.call(cbind, evals)
  }
  return(data.frame(CID=cid, ivals, cvals, evals))
}

.get.cid.old  <- function(cid, quiet=TRUE, from.file=FALSE) {

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

get.cid.list <- function(sid,  quiet=TRUE) {
  return(.cmpd.id2id(sid, 'sid', 'cids', quiet))
}

get.sid.list <- function(cid, quiet=TRUE) {
  return(.cmpd.id2id(cid, 'cid', 'sids', quiet))    
}
