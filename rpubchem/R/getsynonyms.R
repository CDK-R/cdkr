.check.cas <- function(cas)
{
  if (is.null(cas) || is.na(cas))
    return(NA)
  
  ## Input: character vector of CAS RNs
  ## Output: logical vector indicating valid CAS RNs
  
  # Check each element of CAS vector against CAS format with regex.
  cas.format <- regexpr("\\d{2,7}-\\d\\d-\\d", cas, perl=TRUE) > 0 & !is.na(cas)
  
  # If format matches, do checksum validation.
  cas[cas.format] <- sapply(cas[cas.format], function(x) {
    # remove non-numeric
    x <- gsub("[^0-9]", "", x)
    
    # list of integers
    names(x) <- x
    xl <- lapply(strsplit(x, ""), as.integer)
    
    # checksum validation
    sapply(xl, function(y) {
      cas.length <- length(y)
      actual.check.digit <- y[cas.length]
      y <- y[-cas.length]
      expected.check.digit <- sum(rev(y) * seq_along(y)) %% 10L
      expected.check.digit == actual.check.digit
    })
  })
  
  # return TRUE if format matches and checksum validated
  ifelse(cas.format, cas, FALSE)
}


get.synonyms <- function(name, idtype = NULL, quiet=TRUE)
{
  ## Input: character vector of compound names
  ## Output: data.frame with matched names, PubChem CIDs, synonyms and CAS flag
  ##
  ## API Documentation: https://pubchem.ncbi.nlm.nih.gov/pug_rest/PUG_REST.html
  ##
  ## USAGE POLICY: Please note that PUG REST is not designed for very large volumes
  ## (millions) of requests. We ask that any script or application not make more
  ## than 5 requests per second, in order to avoid overloading the PubChem servers.
  ## If you have a large data set that you need to compute with, please contact us
  ## for help on optimizing your task, as there are likely more efficient ways to
  ## approach such bulk queries.
  
  curlHandle <- getCurlHandle()
  out <- data.frame(stringsAsFactors=FALSE)
  
  for (compound in name) {
    tryCatch(
      {
        field = NULL
        if (is.null(idtype)) {
          field <- "name="
          endpoint <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/name/%s/synonyms/XML"
        } else if (idtype == 'inchikey') {
          field <- "inchikey="
          endpoint <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/inchikey/%s/synonyms/XML"
        } else if (idtype == 'cid') {
          field <- "cid="
          endpoint <- "https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/%s/synonyms/XML"
        } else stop("Invalid idtype specified")

        res <- dynCurlReader()
        curlPerform(##postfields=paste0(field, compound),
            url=sprintf(endpoint, URLencode(compound)),
            ##post=1L,
            curl=curlHandle, writefunction = res$update)
        doc <- xmlInternalTreeParse(res$value())
        rootNode <- xmlName(xmlRoot(doc))
        if (rootNode == "InformationList") {
          xpathApply(doc, "//x:Information", namespaces="x", function(x) {
            cid <- xpathSApply(x, "./x:CID", namespaces="x", xmlValue)
            synonym <- xpathSApply(x, "./x:Synonym", namespaces="x", xmlValue)
            df <- data.frame(Name=compound, CID=cid, Synonym=synonym, stringsAsFactors=FALSE)
            out <<- rbindlist(list(out, df))
          })
        } else if (rootNode == "Fault") {
          fault <- xpathApply(doc, "//x:Details", namespaces="x", xmlValue)
          if (!quiet) {
            print(paste(compound, fault[[1]], sep=": "))
          }
        }
      },
      error=function(e) {
        print(e)
      },
      finally=Sys.sleep(0.2) # See usage policy.
    )
  }
  
  # CAS validation
  if (nrow(out) > 0)
    out$CAS <- .check.cas(out$Synonym)
  
  # Cleanup
  rm(curlHandle)
  gc()
  out
}
