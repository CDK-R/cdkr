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

.section.by.heading <- function(seclist, heading) {
  ret <- Filter(function(x) x$TOCHeading == heading, seclist)
  if (length(ret) == 0) return(NULL)
  return(ret[[1]])
}

.section.value <- function(seclist, heading) {
  sec <- .section.by.heading(seclist, heading)
  if (length(sec) == 0) return(NA)
  return( sec[[1]]$Information[[1]]$NumValue )
}

.section.handler <- function(sec, keep = NULL, ignore = NULL) {
  n <- sec$TOCHeading
  if (!is.null(ignore) && n %in% ignore) return(NULL)
  if (!is.null(keep) && !(n %in% keep)) return(NULL)


  ret <- lapply(sec$Information, function(info) {
    info.name <- info$Name
    if (info.name == n) info.name <- ''
    val <- NA
    if ("NumValue" %in% names(info)) val <- as.numeric(info$NumValue)
    else if ("StringValue" %in% names(info)) val <- info$StringValue
    else if ("BinaryValue" %in% names(info)) val <- info$BinaryValue
    else if ("DateValue" %in% names(info)) val <- info$DateValue
    else if ("Table" %in% names(info)) {
      return(.handle.json.table(info$Table))
    }
    ret <- data.frame(val=val, stringsAsFactors=FALSE)
    if (info.name != '') {
      names(ret) <- sprintf("%s.%s", n, info.name)
    } else {
      names(ret) <- n
    }
    return(ret)
  })
  return(ret)
}

.handle.json.table <- function(tbl) {
  cns <- tbl$ColumnName
  rows <- lapply(tbl$Row, function(row) {
    k <- as.character(row$Cell[[1]])
    v <- row$Cell[[2]][1] ## TODO check for units and store it somehow
    vtype <- names(row$Cell[[2]])[1]
    v <- switch(vtype,
                NumValue = as.numeric(v),
                BoolValue = as.logical(v),
                StringValue = as.character(v),
                DateValue = as.character(v),
                BinaryValue = as.character(v))
    df <- data.frame(v, stringsAsFactors=FALSE)
    names(df) <- k
    return(df)
  })
  rows <- do.call(cbind, rows)
}

.inchikey.2.cid <- function(key) {
  url <- sprintf("https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/%s/cids/JSON", key)
  page <- .read.url(url)
  if (is.null(page)) return(NULL)
  record <- fromJSON(content=page)
}

.cmpd.id2id <- function(id, src.type, dest.type, quiet=TRUE) {

  entity <- switch(src.type,
                   inchikey = 'compound',
                   cid = 'compound',
                   name = 'compound',
                   inchi = 'compound',
                   sid = 'substance',
                   aid = 'assay')
  if (is.null(entity)) {
    warning("Invalid src.type specified")
    return(NULL)
  }
  
  if (!(dest.type %in% c('sids', 'cids', 'aids'))) {
    warning("Invalid dest.type specified")
    return(NULL)
  }

  url <- sprintf("https://pubchem.ncbi.nlm.nih.gov/rest/pug/%s/%s/%s/%s/JSON",
                 entity, src.type, id, dest.type)
  if (!quiet)
    cat(url, '\n')
  page <- .read.url(url)
  if (is.null(page)) return(NULL)
  record <- fromJSON(content=page)
  if ('Fault' %in% names(record)) return(NULL)
  else if ('IdentifierList' %in% names(record)) {
    return(record$IdentifierList$CID[1])
  } else if ('InformationList' %in% names(record)) {
    info <- record$InformationList$Information[[1]]
    if (dest.type == 'sids') ret <- info$SID
    else if (dest.type == 'aids') ret <- info$AID
    else if (dest.type == 'cids') ret <- info$CID
    return(ret)
  } else {
    warning(sprintf("Unhandled response. Field names are: %s", paste0(names(record))))
    return(NULL)
  }
}

