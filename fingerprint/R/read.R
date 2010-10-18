cdk.lf <- function(line) {
  p <- regexpr("{([0-9,\\s]*)}",line,perl=T)
  s <- gsub(',','',substr(line, p+1, p+attr(p,"match.length")-2))
  s <- lapply( strsplit(s,' '), as.numeric )
  list(NA, s[[1]])
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

fp.read <- function(f='fingerprint.txt', size=1024, lf=cdk.lf, header=FALSE, binary=TRUE) {
  provider <- parseCall(match.call())$lf
  
  fplist <- list()
  fcon <- file(description=f,open='r')
  lines = readLines(fcon,n=-1)
  if (header) lines = lines[-1]
  c = 1
  for (line in lines) {
    dat <- lf(line)
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
