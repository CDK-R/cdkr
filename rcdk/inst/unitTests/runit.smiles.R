test.get.smiles <- function()
{
  m <- parse.smiles('CCCC')[[1]]
  s <- get.smiles(m)
  checkEquals(s, 'CCCC')
}

test.get.smiles2 <- function() {
  m1 <- parse.smiles("CCCNCC")[[1]]
  m2 <- parse.smiles("CCNCCS")[[1]]
  mcs <- get.mcs(m1, m2)
  checkEquals("[CH2]CNCC", get.smiles(mcs, smiles.flavors(c('Unique'))))
}
