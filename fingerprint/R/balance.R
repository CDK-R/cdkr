balance <- function(fplist) {
  if (is.list(fplist)) {
    lapply(fplist, function(fp) {
      compl <- !fp
      new('fingerprint',
          nbit = 2 * length(fp),
          bits = c(fp@bits, compl@bits+length(fp)),
          provider='R', name='balanced')
    })
  } else {
    fp <- fplist
    compl <- !fp
    new('fingerprint',
        nbit = 2 * length(fp),
        bits = c(fp@bits, compl@bits+length(fp)),
        provider='R', name='balanced')    
  }
}
