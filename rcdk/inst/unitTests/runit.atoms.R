test.is.aromatic <- function()
{
  m <- parse.smiles('c1ccccc1CC')[[1]]
  x <- unlist(lapply(get.atoms(m), is.aromatic))
  checkEquals(0, length(which(x)))
  do.typing(m)
  do.aromaticity(m)
  x <- unlist(lapply(get.atoms(m), is.aromatic))
  checkEquals(6, length(which(x)))  
}

test.get.hcount <- function() {
  m <- parse.smiles('c1ccccc1')[[1]]
  x <- unlist(lapply(get.atoms(m), get.hydrogen.count))
  checkEquals(1, unique(x))
}


test.charges <- function() {
  m <- parse.smiles("CCC")[[1]]
  a <- get.atoms(m)
  for (atom in a) {
    checkTrue(is.null(get.charge(atom)))
  }

  m <- parse.smiles("[O-]CC")[[1]]
  a <- get.atoms(m)
  checkTrue(is.null(get.charge(a[[1]])))

  checkEquals(-1, get.formal.charge(a[[1]]))
  checkEquals(0, get.formal.charge(a[[2]]))
  checkEquals(0, get.formal.charge(a[[3]]))  
}
