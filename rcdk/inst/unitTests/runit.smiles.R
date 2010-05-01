test.get.smiles <- function()
{
  m <- parse.smiles('CCCC')
  s <- get.smiles(m)
  checkEquals(s, 'CCCC')
}
