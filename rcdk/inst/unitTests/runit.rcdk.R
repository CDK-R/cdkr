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
