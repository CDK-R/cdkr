test.is.connected <- function()
{
  m <- parse.smiles('CCCC')[[1]]
  connected <- is.connected(m)
  checkTrue(connected)
  m <- parse.smiles('CCCC.CCCC')[[1]]  
  connected <- is.connected(m)
  checkTrue(!connected)  
}

test.get.largest <- function() {
  m <- parse.smiles('CCCC')[[1]]
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 4)

  m <- parse.smiles('CCCC.CCCCCC.CC')[[1]]
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 6)  
}

test.atom.count <- function() {
  m <- parse.smiles("CCC")[[1]]
  natom <- get.atom.count(m)
  checkEquals(natom, 3)

  convert.implicit.to.explicit(m)
  natom <- get.atom.count(m)
  checkEquals(natom, 11)  
}

test.is.neutral <- function() {
  m <- parse.smiles("CCC")[[1]]
  checkTrue(is.neutral(m))
  m <- parse.smiles('[O-]CC')[[1]]
  checkTrue(!is.neutral(m))
}
