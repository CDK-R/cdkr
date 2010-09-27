test.match1 <- function()
{
  m <- parse.smiles('CCCCc1cccc(Cl)c1')[[1]]
  q <- 'cCl'
  checkTrue(matches(q,m))
}

test.match2 <- function()
{
  m <- parse.smiles('CCCCc1cccc(Cl)c1')[[1]]
  q <- 'CCCCc'
  checkTrue(matches(q,m))
}

test.match3 <- function()
{
  m1 <- parse.smiles('CCCCc1cccc(Cl)c1')[[1]]
  m2 <- parse.smiles('CC(N)(N)CC=O')[[1]]
  q <- '[CD2]'
  checkTrue(all(matches(q,list(m1,m2))))
  checkEquals(2, length(matches(q,list(m1,m2))))
}

test.mcs1 <- function() {
  mols <- parse.smiles(c("NCc1ccccc1OC(=N)CCN", "c1ccccc1OC(=N)"))
  lapply(mols, do.aromaticity)
  lapply(mols, do.typing) 
  mcs <- get.mcs(mols[[1]], mols[[2]], TRUE)
  checkEquals("org.openscience.cdk.AtomContainer", .jclass(mcs))
  checkEquals(9, get.atom.count(mcs))
}

test.mcs3 <- function() {
  mols <- parse.smiles(c("c1cccc(COC(=O)NC(CC(C)C)C(=O)NC(CCc2ccccc2)C(=O)COC)c1", "c1cccc(COC(=O)NC(CC(C)C)C(=O)NCC#N)c1"))
  lapply(mols, do.aromaticity)
  lapply(mols, do.typing) 
  mcs <- get.mcs(mols[[1]], mols[[2]], TRUE)
  checkEquals("org.openscience.cdk.AtomContainer", .jclass(mcs))
  checkEquals(21, get.atom.count(mcs))
}

test.mcs2 <- function() {
  mols <- parse.smiles(c("NCc1ccccc1OC(=N)CCN", "c1ccccc1OC(=N)"))
  lapply(mols, do.aromaticity)
  lapply(mols, do.typing) 
  mcs <- get.mcs(mols[[1]], mols[[2]], FALSE)
  checkEquals("matrix", class(mcs))
  checkEquals(9, nrow(mcs))
  checkEquals(2, ncol(mcs))
}
