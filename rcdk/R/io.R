.packageName <- "rcdk"

write.molecules <- function(mols, filename, together=TRUE, write.props=FALSE) {
  if (together) {
    value <-.jcall('org/guha/rcdk/util/Misc', 'V', 'writeMoleculesInOneFile',
                   .jarray(mols,
                           contents.class = "org/openscience/cdk/interfaces/IAtomContainer"),
                   as.character(filename), as.integer(ifelse(write.props,1,0)))
  } else {
    value <- .jcall('org/guha/rcdk/util/Misc', 'V', 'writeMolecules',
                    .jarray(mols,
                            contents.class = "org/openscience/cdk/interfaces/IAtomContainer"),
                    as.character(filename), as.integer(ifelse(write.props,1,0)))
  }
}

## molfiles should be a vector of strings. Returns a list of
## IAtomContainer objects
load.molecules <- function(molfiles=NA, aromaticity = TRUE, typing = TRUE, isotopes = TRUE, verbose=FALSE) {
  if (any(is.na(molfiles))) {
    stop("Must supply a vector of file names")
  }
  if (length(molfiles) == 0) {
    stop("Must supply a vector of file names")
  }

  for (f in molfiles) {
    if (!file.exists(f) && !grep('http://', f))
      stop(paste(f, ": Does not exist", sep=''))
  }

  urls <- grep('http://', molfiles)
  if (length(urls) > 0) { ## download the files and replace the URL's with the temp names
    for (idx in urls) {
      url <- molfiles[idx]
      tmpdest <- tempfile(pattern='xxx')
      status <- try(download.file(url, destfile=tmpdest, method='internal', mode='wb', quiet=!verbose),
                    silent=verbose)
      if (class(status) == 'try-error') {
        molfiles[idx] <- NA
        cat("Can't get ", url, '\n')
      } else {
        molfiles[idx] <- tmpdest
      }
    }
  }
  molfiles <- molfiles[ !is.na(molfiles) ]
  farr <- .jarray(molfiles, contents.class = 'S')
  molecules <- .jcall('org/guha/rcdk/util/Misc', '[Lorg/openscience/cdk/interfaces/IAtomContainer;',
                      'loadMolecules', farr, aromaticity, typing, isotopes,
                      check=FALSE)
  exception <- .jgetEx(clear = TRUE)
  if (!is.null(exception)) {
    stop(exception)
  }

  if (is.jnull(molecules)) {
    return(NA)
  } else {
    nulls <- which( unlist(lapply(molecules, is.jnull)) )
    if (length(nulls) > 0) molecules[nulls] <- NA
    return(molecules)
  }
}

