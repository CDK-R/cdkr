test.get.smiles <- function()
{
  m <- parse.smiles('CCCC')[[1]]
  s <- get.smiles(m)
  checkEquals(s, 'CCCC')
}
