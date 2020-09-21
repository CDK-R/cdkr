test.bond.order <- function()
{
  m <- parse.smiles('CCN')[[1]]
  b <- get.bonds(m)[[1]]
  checkTrue(b$getOrder() == get.bond.order('single'))
  b$setOrder(get.bond.order("double"))
  checkTrue(b$getOrder() == get.bond.order('double'))
}
