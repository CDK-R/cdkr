
## Taken from BMS package
.hexcode.binvec.convert <-
function (length.of.binvec) 
{
    if (length(length.of.binvec) > 1) 
        length.of.binvec = length(length.of.binvec)
    addpositions = 4 - length.of.binvec%%4
    positionsby4 = (length.of.binvec + addpositions)/4
    hexvec = c(0:9, "a", "b", "c", "d", "e", "f")
    hexcodelist = list(`0` = numeric(4), `1` = c(0, 0, 0, 1), 
        `2` = c(0, 0, 1, 0), `3` = c(0, 0, 1, 1), `4` = c(0, 
            1, 0, 0), `5` = c(0, 1, 0, 1), `6` = c(0, 1, 1, 0), 
        `7` = c(0, 1, 1, 1), `8` = c(1, 0, 0, 0), `9` = c(1, 
            0, 0, 1), a = c(1, 0, 1, 0), b = c(1, 0, 1, 1), c = c(1, 
            1, 0, 0), d = c(1, 1, 0, 1), e = c(1, 1, 1, 0), f = c(1, 
            1, 1, 1))
    return(list(as.hexcode = function(binvec) {
        incl = c(numeric(addpositions), binvec)
        dim(incl) = c(4, positionsby4)
        return(paste(hexvec[crossprod(incl, 2L^(3:0)) + 1], collapse = ""))
    }, as.binvec = function(hexcode) {
        return(unlist(hexcodelist[unlist(strsplit(hexcode, "", 
            fixed = TRUE), recursive = FALSE, use.names = FALSE)], 
            recursive = FALSE, use.names = FALSE)[-(1:addpositions)])
    }))
}
## Taken from BMS package
.hex2bin <-
function (hexcode) 
{
    if (!is.character(hexcode)) 
        stop("please input a character like '0af34c'")
    hexcode <- paste("0", tolower(hexcode), sep = "")
    hexobj <- .hexcode.binvec.convert(length(hexcode) * 16L)
    return(hexobj$as.binvec(hexcode))
}

## Convert base64 encoded CACTVS fp to fingerprint object
## As described in ftp://ftp.ncbi.nlm.nih.gov/pubchem/specifications/pubchem_fingerprints.txt
## last 7 bits are padding

#' Convert a Base64 encoded Pubchem 881-bit fingerprint to a \code{fingerprint} object
#'
#' Pubchem computes 881-bit structural keys using the CACTVS toolkit, which are made
#' available as Base64 encoded strings. This method converts the Pubchem string to
#' a \code{fingerprint} object, which can be manipulated using the \code{fingerprint}
#' package.
#'
#' @param cactvs A character string containing the Base64 encoded fingerprint
#' @return A \code{fingerprint} object
#' @seealso \code{\link{get.cid}}
#'
#' @export 
decodeCACTVS <- function(cactvs) {
  h <- base64decode(cactvs)
  bits <- unlist(lapply(h[-c(1:4)], function(x) .hex2bin(as.character(x))))
  bits <- bits[1:881]
  fp <- methods::new('fingerprint', nbit=881, bits=which(bits==1), provider='pubchem')
  return(fp)
}

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

    print(.itemNames)
    print(dat)
    
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
    sidURL <- 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?tool=rpubchem&db=pcsubstance&id='
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
  ivals.unlisted <- unlist(Filter(function(x) !is.null(x), ivals), recursive=TRUE)
  ivals <- do.call(cbind, as.list(ivals.unlisted)  )
  
  ## Process chemprops
  props <- .section.by.heading(sections, "Chemical and Physical Properties")
  if (is.null(props)) {
    warning(sprintf("No phys/chem properties section for %d", cid))
    return(NULL)
  }
  
  computed <- .section.by.heading(props$Section, "Computed Properties")
  cvals <- lapply(list(computed), .section.handler,
                  ignore= c(##"CACTVS Substructure Key Fingerprint",
                    "Compound Is Canonicalized",
                    "Covalently-Bonded Unit Count"))
  cvals <- do.call(cbind, as.list(unlist(Filter(function(x) !is.null(x), cvals), recursive=FALSE)))
  cols2remove <- which(names(cvals) %in% c("Compound Is Canonicalized",
                                           "Covalently-Bonded Unit Count"))
  cvals <- cvals[,-cols2remove]
  
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
