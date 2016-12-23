.queryString <- "<PCT-Data>
  <PCT-Data_input>
    <PCT-InputData>
      <PCT-InputData_query>
        <PCT-Query>
          <PCT-Query_type>
            <PCT-QueryType>
              <PCT-QueryType_qas>
                <PCT-QueryActivitySummary>
                  <PCT-QueryActivitySummary_output value='summary-table'>0</PCT-QueryActivitySummary_output>
                  <PCT-QueryActivitySummary_type value='assay-central'>0</PCT-QueryActivitySummary_type>
                  <PCT-QueryActivitySummary_scids>
                    <PCT-QueryUids>
                      <PCT-QueryUids_ids>
                        <PCT-ID-List>
                          <PCT-ID-List_db>pccompound</PCT-ID-List_db>
                          <PCT-ID-List_uids>
                            <PCT-ID-List_uids_E>%s</PCT-ID-List_uids_E>
                          </PCT-ID-List_uids>
                        </PCT-ID-List>
                      </PCT-QueryUids_ids>
                    </PCT-QueryUids>
                  </PCT-QueryActivitySummary_scids>
                </PCT-QueryActivitySummary>
              </PCT-QueryType_qas>
            </PCT-QueryType>
          </PCT-Query_type>
        </PCT-Query>
      </PCT-InputData_query>
    </PCT-InputData>
  </PCT-Data_input>
</PCT-Data>"

.pollString <- '<PCT-Data>
  <PCT-Data_input>
    <PCT-InputData>
      <PCT-InputData_request>
        <PCT-Request>
          <PCT-Request_reqid>%s</PCT-Request_reqid>
          <PCT-Request_type value="status"/>
        </PCT-Request>
      </PCT-InputData_request>
    </PCT-InputData>
  </PCT-Data_input>
</PCT-Data>'

get.aid.by.cid <- function(cid, type='tested', quiet=TRUE) {

  if (!(type %in% c('tested','active','inactive')))
      stop("Invalid type specified")

  if (type == 'tested') type <- 'all'
  url <- sprintf('https://pubchem.ncbi.nlm.nih.gov/rest/pug/compound/cid/%d/aids/JSON?aids_type=%s', cid, type)
  if (!quiet) {
    cat("Retrieving from:", url, "\n")
  }
  page <- .read.url(url)
  if (is.null(page)) {
    warning(sprintf("No data found for %d", cid))
    return(NULL)
  }
  print(fromJSON(content=page))
  fromJSON(content=page)$InformationList$Information[[1]]$AID
}

get.aid.by.cid.old <- function(cid, type='raw', quiet=TRUE) {

  if (!(type %in% c('tested','active','inactive','discrepant','raw')))
      stop("Invalid type specified")
      
  url <- "http://pubchem.ncbi.nlm.nih.gov/pug/pug.cgi"

  ## perform query
  qstring <- gsub("\\n", "", sprintf(.queryString, cid))
  h = basicTextGatherer()
  curlPerform(url = 'http://pubchem.ncbi.nlm.nih.gov/pug/pug.cgi',
              postfields = qstring,
              writefunction = h$update)

  ## extract query id
  xml <- xmlTreeParse(h$value(), asText=TRUE, asTree=TRUE)
  root <- xmlRoot(xml)
  reqid <- xmlElementsByTagName(root, 'PCT-Waiting_reqid', recursive=TRUE)
  if (length(reqid) != 1) {
    if (!quiet) warning("Malformed request id document")
    return(NULL)
  }
  reqid <- xmlValue(reqid[[1]])

  ## start polling
  if (!quiet) cat("Starting polling using reqid:", reqid, "\n")
  root <- .poll.pubchem(reqid)

  ## OK, got the link to our result
  link <- xmlElementsByTagName(root, 'PCT-Download-URL_url', recursive=TRUE)
  if (length(link) != 1) {
    if (!quiet) warning("Polling finished but no download URL")
    return(NULL)
  }
  link <- xmlValue(link[[1]])
  if (!quiet) cat("Got link to download:", link, "\n")
  
  ## OK, get data file
  tmpdest <- tempfile(pattern = 'abyc')
  tmpdest <- paste(tmpdest, '.gz', sep='', collapse='')
  status <- try(download.file(link,
                              destfile=tmpdest,
                              method='internal',
                              mode='wb', quiet=TRUE),
                silent=TRUE)
  if (class(status) == 'try-error') {
    if (!quiet) warning(status)
    return(NULL)
  }

  ## OK, load the data
  dat <- read.csv(tmpdest,header=TRUE,fill=TRUE,row.names=NULL)
  unlink(tmpdest)

  valid.rows <- grep("^[[:digit:]]*$", dat[,1])
  dat <- dat[valid.rows,c(1,3,4,5)]
  row.names(dat) <- 1:nrow(dat)
  names(dat) <- c('aid', 'active', 'inactive', 'tested')
  ret <- dat

  type <- type[1]
  switch(type,
         active = dat[dat$active == 1,1],
         inactive = dat[dat$inactive == 1,1],
         tested = dat[,1],
         raw = ret[,-5])
}
