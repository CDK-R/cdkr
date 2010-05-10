test.is.aromatic <- function()
{
  m <- parse.smiles('c1ccccc1CC')
  x <- unlist(lapply(get.atoms(m), is.aromatic))
  checkEquals(6, length(which(x)))
}

test.get.hcount <- function() {
  m <- parse.smiles('c1ccccc1')
  x <- unlist(lapply(get.atoms(m), get.hydrogen.count))
  checkEquals(1, unique(x))
}
