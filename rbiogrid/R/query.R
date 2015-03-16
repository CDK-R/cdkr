get.organisms <- function() {
  key <- get.access.key()
  if (is.null(key)) stop("Must provide a non-NULL access key")
  url <- sprintf('http://webservice.thebiogrid.org/organisms/?accesskey=%s&format=tab2', key)
  resp <- GET(url)
  if (resp$status_code != 200) {
    warning(paste("Error retrieving organism list: HTTP Code ", resp$status_code, sep=' ', collapse=''))
    return(NULL)
  }
  page <- content(resp)
  tbl <- read.table(textConnection(page), header=FALSE, as.is=TRUE, sep='\t')
  names(tbl) <- c('taxid', 'organism')
  return(tbl)
}


get.interactions <- function(geneList, species = 9606,
                             searchNames = TRUE, searchSynonyms = TRUE, searchIds = FALSE, searchBiogridIds = FALSE,
                             taxId = 'All',
                             selfInteractionsExcluded = TRUE,
                             includeInteractorInteractions = FALSE, 
                             includeEvidence = TRUE,
                             verbose = FALSE) {
  key <- get.access.key()
  if (is.null(key)) stop("Must provide a non-NULL access key")

  args <- as.list(environment())
  qs <- sapply(names(args), function(an) {
    if (an %in% c('key', 'verbose')) return("")
    val <- args[[an]]
    if (is.logical(val)) val <- tolower(as.character(val))
    else val <- as.character(val)
    return(sprintf("%s=%s", an, val))
  })
  qs <- paste(qs, collapse='&', sep='')
  url <- sprintf('http://webservice.thebiogrid.org/interactions/?accesskey=%s&%s&format=json', key, qs)
  if (verbose)
    cat('URL:',url, '\n', file=stderr())

  cached.doc <- .get.cache(url)
  if (!is.null(cached.doc)) {
    if (verbose) cat("Found in cache\n", file=stderr())
    return(cached.doc)
  }
  
  resp <- GET(url)
  if (resp$status_code != 200) {
    warning(paste("Error retrieving interactions. HTTP Error", resp$status_code, collapse=' ', sep=''))
    return(NULL)
  } else {
    page <- content(resp)
    page <- do.call(rbind, lapply(page, as.data.frame))
    .set.cache(url, page)
    return(page)
  }
}
