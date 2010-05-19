test.is.connected <- function()
{
  m <- parse.smiles('CCCC')
  connected <- is.connected(m)
  checkTrue(connected)
  m <- parse.smiles('CCCC.CCCC')  
  connected <- is.connected(m)
  checkTrue(!connected)  
}

test.get.largest <- function() {
  m <- parse.smiles('CCCC')
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 4)

  m <- parse.smiles('CCCC.CCCCCC.CC')
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 6)  
}

test.atom.count <- function() {
  m <- parse.smiles("CCC")
  natom <- get.atom.count(m)
  checkEquals(natom, 3)

  convert.implicit.to.explicit(m)
  natom <- get.atom.count(m)
  checkEquals(natom, 11)  
}

test.is.neutral <- function() {
  m <- parse.smiles("CCC")
  checkTrue(is.neutral(m))
  m <- parse.smiles('[O-]CC')
  checkTrue(!is.neutral(m))
}
