## Test urls
## https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/1653/description/JSON
## https://pubchem.ncbi.nlm.nih.gov/bioassay/1653#section=By-Depositor
.join <- function (x, delim = ",") 
  paste(x, sep = "", collapse = delim)

.uniqify <- function(x) {
  u <- unique(x)
  nx <- rep(0, length(x))
  for (i in u) {
    cnt <- length(which(x == i))
    k <- 0
    for (j in 1:length(x)) {
      if (x[j] == i) {
        if (k != 0) {
          nx[j] <- paste(x[j], k, sep='.', collapse='')
        } else {
          nx[j] <- x[j]
        }
        k <- k + 1
      }
    }
  }
  unlist(nx)
}

.gunzip <- function(iname, oname) {
  icon <- gzfile(iname, open='r')
  ocon <- file(oname, open='w')
  while (TRUE) {
    lines <-readLines(icon, n=100)
    if (length(lines) == 0) break
    lines <- paste(lines, sep='', collapse='\n')
    writeLines(lines, con = ocon)
  }
  file.remove(iname)
  close(icon)
  close(ocon)
}

get.assay.summary <- function(aid) {
  urlcon <- url(sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/summary/JSON', as.integer(aid)))
  j <- fromJSON(content=.join(readLines(urlcon), '\n'))
  close(urlcon)
  j <- j[[1]][[1]][[1]]
  j$Comment <- .join(j$Comment, '\n')
  j$Protocol <- .join(j$Protocol, '\n')
  j$Description <- .join(j$Description, '\n')
  return(j)
}

get.assay.desc <- function(aid) {
  url <- sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/description/XML', as.integer(aid))
  tmpdest <- tempfile(pattern = 'adesc')

  status <- try(download.file(url, destfile=tmpdest, method='curl', mode='wb', quiet=TRUE),
                silent=TRUE)

  if (class(status) == 'try-error') {
    return(NULL)
  }

  xmlfile <- strsplit(tmpdest, '\\.')[[1]][1]
  xml <- xmlTreeParse(xmlfile, asTree=TRUE)
  root <- xmlRoot(xml)

  desc.short <- xmlElementsByTagName(root, 'PC-AssayDescription_name', recursive=TRUE)
  desc.short <- xmlValue(desc.short[[1]])

  desc.comments <- xmlElementsByTagName(root, 'PC-AssayDescription_comment_E', recursive=TRUE)
  desc.comments <- lapply(desc.comments, xmlValue)
  desc.comments <- paste(desc.comments, sep=' ', collapse='')

  xref.aids <- xmlElementsByTagName(root, 'PC-XRefData_aid', recursive=TRUE)
  xref.aids <- as.numeric(sapply(xref.aids, xmlValue))

  xref.pmids <- xmlElementsByTagName(root, 'PC-XRefData_pmid', recursive=TRUE)
  xref.pmids <- as.numeric(sapply(xref.pmids, xmlValue))
  
  result.types <- xmlElementsByTagName(root, 'PC-ResultType', recursive=TRUE)

  type.name <- list()
  type.desc <- list()
  type.unit <- list()
  
  counter <- 1
  repcounter <- 1
  for (aType in result.types) {
    name <- xmlElementsByTagName(aType, 'PC-ResultType_name', recursive=TRUE)
    name <- xmlValue(name[[1]])

    tdesc <- xmlElementsByTagName(aType, 'PC-ResultType_description_E', recursive=TRUE)
    if (length(tdesc) > 0)
      tdesc <- xmlValue(tdesc[[1]])
    else tdesc <- NA

    unit <- xmlElementsByTagName(aType, 'PC-ResultType_unit', recursive=TRUE)

    if (length(unit) != 0) {
      unit <- xmlGetAttr(unit[[1]], name='value')
      if (unit == 'ugml') unit <- 'ug/mL'
      else if (unit == 'm') unit <- 'M'
      else if (unit == 'um') unit <- 'uM'
    } else unit <- 'NA'

    type.name[[counter]] <- name
    type.desc[[counter]] <- tdesc
    type.unit[[counter]] <- unit
    counter <- counter+1
  }

  type.name <- .uniqify(type.name)
  type.info <- data.frame(Name=I(unlist(type.name)),
                          Description=I(unlist(type.desc)),
                          Units=I(unlist(type.unit)))

  unlink(tmpdest)
  
  list(assay.desc=desc.short,
       assay.comments=desc.comments,
       aids=sort(xref.aids), pmids=sort(xref.pmids),
       types=type.info)
}


find.assay.id <- function(query, quiet=TRUE) {
  searchURL <- 'https://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?tool=rpubchem&db=pcassay&term='
  url <- URLencode(paste(searchURL,query,sep='',collapse=''))
                                        #tmpdest <- tempfile(pattern = 'search')
  tmpdest <- 'srch'

  ## first get the count of results
  status <- try(download.file(url, destfile=tmpdest, method='internal', mode='wb', quiet=quiet),
                silent=TRUE)
  if (class(status) == 'try-error') {
    stop("Couldn't perform search")
  }
  xml <- xmlTreeParse(tmpdest)
  root <- xmlRoot(xml)
  count <- xmlValue(xmlElementsByTagName(root, "Count", recursive=TRUE)[[1]])

  if (count == 0) {
    stop("No assays for this search term")
  }

  ## now get the results
  url <- sprintf("%s&retmax=%s", url, count)
  status <- try(download.file(url, destfile=tmpdest, method='internal', mode='wb', quiet=quiet),
                silent=TRUE)

  if (class(status) == 'try-error') {
    stop("Couldn't perform search")
  }
  xml <- xmlTreeParse(tmpdest)
  root <- xmlRoot(xml)
  idlist <- xmlElementsByTagName(root, 'IdList', recursive=TRUE)
  if (length(idlist) != 1) {
    stop("Error parsing Entrez output")
  }
  ids <- xmlElementsByTagName(idlist[[1]], 'Id', recursive=TRUE)
  ids <- sort(as.numeric(unlist(lapply(ids, xmlValue))))

  unlink(tmpdest)
  
  ids
}

#' Retreive CID's for the given bioassay
#'
#' @param aid The bioassay ID
#' @param quiet If \code{TRUE} verbose output is provided
#' @return A vector of CIDs
#' @seealso \code{\link{get.sids.by.aid}}, \code{\link{get.sid.list}}
#' @examples
#' get.cids.by.aid(2044)
get.cids.by.aid <- function(aid, quiet=TRUE) {
  .ids.for.aid(aid,'cid',quiet)
}

#' Retreive SID's for the given bioassay
#'
#' @param aid The bioassay ID
#' @param quiet If \code{TRUE} verbose output is provided
#' @return A vector of SIDs
#' @seealso \code{\link{get.cids.by.aid}}
#' @examples
#' get.sids.by.aid(2044)
get.sids.by.aid <- function(aid, quiet=TRUE) {
  .ids.for.aid(aid,'sid', quiet)
}
get.assay <- function(aid, cid=NULL, sid=NULL, quiet=TRUE) {
  ## Lets see how many SID's we're going to pull down
  as <- get.assay.summary(aid)
  nsid <- as$SIDCountAll
  if (nsid > 8000 || !is.null(cid) || !is.null(sid)) {
    if (!is.null(cid) && !is.null(sid)) cid <- NULL
    .getAssay(aid, cid=cid, sid=sid, quiet)
  } else {
    .getAssayDirect(aid, quiet)
  }
}

## only one of cid or sid should be non-null. If both are non-null, use cid
## if both are null, retrieve entire assay in chunked mode by cid
.getAssay <- function(aid, cid=NULL, sid=NULL, quiet=TRUE) {
  idtype <- NA
  if (!is.null(cid)) {
    ids <- cid
    idtype <- 'cid'
  } else if (!is.null(sid)) {
    ids <- sid
    idtype <- 'sid'
  } else {
    ## if no cid/sid was specified this means that the assay was too big to get
    ## in one go, so instead we'll be chunking all the cids
    ids <- .ids.for.aid(aid, 'cid', quiet)
    idtype <- 'cid'
  }

  chunk.size <- 1000
  if (!quiet) cat("Will process AID", aid, "in", as.integer(length(ids)/chunk.size)+1, "chunks\n")
  it <- ihasNext(ichunk(ids, chunk.size))
  nchunk <- 1
  chunks <- list()
  while (itertools::hasNext(it)) {
    achunk <- unlist(nextElem(it))
    url <- sprintf("https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/CSV?%s=%s",
                   as.integer(aid), idtype, .join(achunk, ","))
    if (!quiet) cat(" retrieving chunk", nchunk, "\n")
    page <- .read.url(url)
    if (!is.null(page)) {
      dat <- read.csv(textConnection(page), header=TRUE, row.names=NULL, fill=TRUE)
      chunks[[nchunk]] <- .clean.bioassay.csv(aid, dat, add.metadata=FALSE, quiet)
    }
    nchunk <- nchunk + 1
  }
  dat <- do.call(rbind, chunks)
  .add.assay.metadata(aid, dat)
}

.getAssayDirect <- function(aid, quiet=TRUE) {
  url <- sprintf("https://pubchem.ncbi.nlm.nih.gov/rest/pug/assay/aid/%d/CSV", as.integer(aid))
  if (!quiet) cat("URL:", url, "\n")
  page <- .read.url(url)
  dat <- read.csv(textConnection(page), header=TRUE, row.names=NULL, fill=TRUE, check.names=FALSE)
  .clean.bioassay.csv(aid, dat, quiet=quiet)
}

.clean.bioassay.csv <- function(aid, dat, add.metadata=TRUE, quiet=TRUE) {
  ## remove meta data rows
  rowtypes <- dat[1,]
  rows.to.drop <- which(is.na(dat[,2]))
  dat <- dat[-rows.to.drop,]
  if (nrow(dat) == 0) return(dat)  
  for (i in 1:length(rowtypes)) {
    val <- switch(EXPR=as.character(rowtypes[i]),
                  STRING = as.character(dat[,i]),
                  FLOAT = as.numeric(dat[,i]),
                  INTEGER = as.integer(dat[,i]))
    if (!is.null(val)) dat[,i] <- val
  }
  ## get rid of underscores in the names
  n <- names(dat)
  names(dat) <- gsub('_', '\\.', n)
  
  ## lets get the descriptions and set col names and
  ## attributes
  if (add.metadata) {
    dat <- .add.assay.metadata(aid, dat, quiet)
  }
  dat[,-1]
}

.add.assay.metadata <- function(aid, assay.data, quiet=FALSE) {
  if (!quiet) cat('Processing descriptions for',aid,'\n')  
  desc <- get.assay.desc(aid)
  if (is.null(desc)) warning("couldn't get description data'")
  
  attr(assay.data, 'description') <- desc$assay.desc
  attr(assay.data, 'comments') <- desc$assay.comments
  types <- list()
  for (i in 1:nrow(desc$types)) {
    types[[desc$types[i,1]]] <- c(desc$types[i,2], desc$types[i,3])
  }
  attr(assay.data, 'types') <- types
  return(assay.data)
}



.get.xml.file <- function(url, dest, quiet) {
  status <- try(download.file(url, destfile=dest, method='internal', mode='wb', quiet=quiet),
                silent=TRUE)

  if (class(status) == 'try-error') {
    print(status)
    stop("Error in the download")
  }
}



#####################################
##
## Contributed code
##
#####################################

.find.compound.count <- function (compounds, quiet = TRUE) {
  ## If list of Compounds, collapse into OR combined querystring
  query <- paste (compounds, collapse ="+OR+")

  if (!quiet) cat('Query: ', query, '\n')

  ## Create search URL and download result
  searchURL <- "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pccompound&tool=rpubchem&term="
  url <- URLencode(paste(searchURL, query, sep = "", collapse = ""))
  tmpdest <- "srch"
  status <- try(download.file(url, destfile = tmpdest, method = "internal",
                              mode = "wb", quiet = quiet), silent = TRUE)
  if (class(status) == "try-error") {
    stop("Couldn't perform search")
  }

  ## Parse XML and return vector of counts for each Term in Query Strings
  xml <- xmlTreeParse(tmpdest)
  root <- xmlRoot(xml)

  ##
  ## Results are scattered across two lists:
  ## 1) TranslationStack/TermSet for Hits
  ## 2) ErrorList for Misses
  ## 
  termlist <- sub ("([^[]*).*", "\\1", 
                   sapply(xmlElementsByTagName(root, "Term", recursive = TRUE), xmlValue),
                   perl=TRUE)
  hitlist <- sapply(xmlElementsByTagName(root, "Count", recursive = TRUE), xmlValue)
  counts <- sapply (compounds, function(x) {
    if (length(which(termlist==x))==1) {
      as.integer(hitlist[which(termlist==x)+1])
    } else {
      0
    }
  })

  unlink(tmpdest)
  counts
}
