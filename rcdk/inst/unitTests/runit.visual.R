test.view.image <- function()
{
  m <- parse.smiles('c1ccccc1C(=O)NC')
  img <- view.image.2d(m, 100,100)
  dims <- dim(img)  
  checkEquals(dims[1], 100)
  checkEquals(dims[2], 100)
  checkEquals(dims[2], 3)
}
