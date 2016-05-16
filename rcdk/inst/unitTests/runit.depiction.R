library(rJava)

test.depictiongenerator <- function()
{
  
  mol <- parse.smiles("CC")
  
  #create a depiction  and write to SVG
  dg  <- .jnew("org.openscience.cdk.depict.DepictionGenerator")
  dg$withSize(512,512)$withAtomColors()
  temp1 <- paste0(tempfile(), ".svg")
  dg$depict(mol[[1]])$writeTo(temp1)
  
  #check SVG Output
  checkEquals("org.openscience.cdk.depict.DepictionGenerator", dg$getClass()$getName())
}


