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
