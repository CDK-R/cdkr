fps.lf <- function(line) {
  toks <- strsplit(line, "\\s")[[1]];
  if (length(toks) != 2) return(NULL)
  bitpos <- .Call("parse_hex", as.character(toks[1]), as.integer(nchar(toks[1])))
  if (is.null(bitpos)) return(NULL)
  list(toks[2], bitpos+1) ## we add 1, since C does bit positions from 0
}

cdk.lf <- function(line) {
  p <- regexpr("{([0-9,\\s]*)}",line,perl=T)
  s <- gsub(',','',substr(line, p+1, p+attr(p,"match.length")-2))
  s <- lapply( strsplit(s,' '), as.numeric )
  molid <- gsub("\\s+","", strsplit(line, "\\{")[[1]][1])
  list(molid, s[[1]])
}

moe.lf <- function(line) {
  p <- regexpr("\"([0-9\\s]*)\"",line, perl=T)
  s <- substr(line, p+1, p+attr(p,"match.length")-2)
  s <- lapply( strsplit(s,' '), as.numeric )
  list(NA, s[[1]])
}

bci.lf <- function(line) {
  tokens <- strsplit(line, '\\s')[[1]]
  name <- tokens[1]
  tokens <- tokens[-c(1, length(tokens), length(tokens)-1)]
  list(name, as.numeric(tokens))
}

ecfp.lf <- function(line) {
  tokens <- strsplit(line, '\\s')[[1]]
  name <- tokens[1]
  tokens <- tokens[-1]
  list(name, tokens)
}

## TODO we should be iterating over lines and not reading
## them all in
fp.read <- function(f='fingerprint.txt', size=1024, lf=cdk.lf, header=FALSE, binary=TRUE) {
  lf.name <- deparse(substitute(lf))
  
  provider <- lf.name
  
  fplist <- list()
  fcon <- file(description=f,open='r')
  lines = readLines(fcon,n=-1)
  if (header && lf.name != 'fps.lf') lines = lines[-1]
  if (lf.name == 'fps.lf') {
    binary <- TRUE
    size <- NULL
    ## process the header block
    nheaderline = 0
    for (line in lines) {
      if (substr(line,1,1) != '#') break
      nheaderline <- nheaderline + 1
      if (nheaderline == 1 && length(grep("#FPS1", line)) != 1) stop("Invalid FPS format")
      if (length(grep("#num_bits", line)) == 1) size <- as.numeric(strsplit(line, '=')[[1]][2])
      if (length(grep("#software", line)) == 1) provider <- as.numeric(strsplit(line, '=')[[1]][2])      
    }
    lines <- lines[ (nheaderline+1):length(lines) ]
    if (is.null(size)) { # num_bit
      size <- nchar(strsplit(line, '\\s')[[1]][1]) * 4
    }
  }
  c = 1
  for (line in lines) {
    dat <- lf(line)
    if (is.null(dat)) {
      warning(sprintf("Couldn't parse: %s", line))
      next
    }
    if (is.na(dat[[1]])) name <- ""
    else name <- dat[[1]]

    if (binary) {
      fplist[[c]] <- new("fingerprint",
                         nbit=size,
                         bits=as.numeric(dat[[2]]),
                         folded=FALSE,
                         provider=provider,
                         name=name)
    } else {
      fplist[[c]] <- new("featvec",
                         features=sort(dat[[2]]),
                         provider=provider,
                         name=name)
    }
    c <- c+1
  }
  close(fcon)
  fplist
}

## Need to supply the length of the bit string since fp.read does
## not provide that information
fp.read.to.matrix <- function(f='fingerprint.txt', size=1024, lf=cdk.lf, header=FALSE) {
  fplist <- fp.read(f, size, lf, header)
  fpmat <- fp.to.matrix(fplist)
  fpmat
}
