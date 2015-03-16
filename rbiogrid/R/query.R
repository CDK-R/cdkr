#' Retrieve table of organisms and their taxonomy ID's
#' 
#' BioGRID supports protein protein interactions in multiple species.
#' By default queries consider all species, but can be restricted to
#' consider a specific species. This methods returns all species names
#' and their corresponding taxonomy ID
#'
#' @return A \code{data.frame} with two columns called "taxid" and "organism"
#' @keywords database
#' @seealso \code{link{set.access.key}}
#' @export
get.organisms <- function() {
  key <- get.access.key()
  if (is.null(key)) stop("Must provide a non-NULL access key")
  url <- sprintf('http://webservice.thebiogrid.org/organisms/?accesskey=%s&format=tab2', key)
  resp <- httr::GET(url)
  if (resp$status_code != 200) {
    warning(paste("Error retrieving organism list: HTTP Code ", resp$status_code, sep=' ', collapse=''))
    return(NULL)
  }
  page <- httr::content(resp)
  tbl <- read.table(textConnection(page), header=FALSE, as.is=TRUE, sep='\t')
  names(tbl) <- c('taxid', 'organism')
  return(tbl)
}

#' Retrieve interactions for one or more genes.
#' 
#' By default this function returns interactions for one or more gene
#' symbols, separated by the pipe ('|') symbol and considers Homo Sapiens
#' as the species. See \url{http://wiki.thebiogrid.org/doku.php/biogridrest#list_of_parameters}
#' for more details.
#'
#' @param geneList A character string with pipe delimited series of gene symbols
#' @param taxId The species to consider. By default Homo Sapiens (9606)
#' @param searchNames Use identifiers in \code{geneList} and search gene names
#' @param searchSynonyms Use identifiers in \code{geneList} and search gene synonyms
#' @param searchIds if \code{TRUE}, identifiers in \code{geneList} are searched for in Entrez Gene ID's.
#'                  For this to be used \code{searchNames} and \code{searchSynonyms} should be \code{FALSE}
#' @param searchBiogridIds if \code{TRUE}, identifiers in \code{geneList} are searched for in BioGRID ID's
#'                  For this to be used \code{searchNames}, \code{searchSynonyms} and \code{searchIds}
#'                  should be \code{FALSE}
#' @param selfInteractionsExcluded If \code{TRUE} ignore self interactions
#' @param includeInteractorInteractions If \code{TRUE}, then interactions between the interactors of the
#'                  query targets are included in the return value
#" @param includeEvidence If \code{TRUE} then include reported evidence for the interaction
#' @param verbose If \code{TRUE} intermediate output is printed such as URLs and interaction counts
#' @return A \code{data.frame} with interaction information
#' @seealso \code{link{get.organisms}}, \code{link{set.access.key}}
#' @keywords database
#' @export
get.interactions <- function(geneList, 
                             searchNames = TRUE, searchSynonyms = TRUE, searchIds = FALSE, searchBiogridIds = FALSE,
                             taxId = 9606,
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

  ## if it's not in the cache, first query for count of rows
  url <- sprintf('http://webservice.thebiogrid.org/interactions/?accesskey=%s&%s&format=count', key, qs)
  resp <- httr::GET(url)
  if (resp$status_code != 200) {
    warning(paste("Can't get count for", url, '\n', sep='', collapse=' '))
    return(NULL)
  }
  count <- as.integer(httr::content(resp))
  if (verbose) cat("Will retrieve", count, "interactions\n", file=stderr())

  url <- sprintf('http://webservice.thebiogrid.org/interactions/?accesskey=%s&%s&format=json', key, qs)
  resp <- httr::GET(url)
  if (resp$status_code != 200) {
    warning(paste("Error retrieving interactions. HTTP Error", resp$status_code, collapse=' ', sep=''))
    return(NULL)
  } else {
    page <- httr::content(resp)
    page <- do.call(rbind, lapply(page, as.data.frame))
    .set.cache(url, page)
    return(page)
  }
}

