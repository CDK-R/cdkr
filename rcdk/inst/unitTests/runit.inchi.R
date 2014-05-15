test.inchi.1 <- function()
{
  m <- parse.smiles('CCC')[[1]]
  i <- get.inchi(m) 
  checkEquals(i, "InChI=1S/C3H8/c1-3-2/h3H2,1-2H3")
}
test.inchi.2 <- function()
{
  m <- parse.smiles('CCN')[[1]]
  i <- get.inchi(m) 
  checkEquals(i, "InChI=1S/C2H7N/c1-2-3/h2-3H2,1H3")
}
test.inchi.3 <- function()
{
  m <- parse.smiles('C1CCC1CC(CN(C)(C))CC(=O)CC')[[1]]
  i <- get.inchi(m) 
  checkEquals(i, "InChI=1S/C13H25NO/c1-4-13(15)9-12(10-14(2)3)8-11-6-5-7-11/h11-12H,4-10H2,1-3H3")
}
test.inchi.4 <- function()
{
  m <- parse.smiles("[2H]C1=C([2H])C(=C([2H])C(=C1[2H])C(=O)N(CC)CC)C([2H])([2H])[2H]")[[1]]
  i <- get.inchi(m) 
  checkEquals(i, "InChI=1S/C12H17NO/c1-4-13(5-2)12(14)11-8-6-7-10(3)9-11/h6-9H,4-5H2,1-3H3/i3D3,6D,7D,8D,9D")
}

