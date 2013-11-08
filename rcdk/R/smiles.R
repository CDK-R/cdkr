get.smiles <- function(molecule) {
  if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
    stop("Supplied object should be a Java reference to an IAtomContainer")
  }
  smiles <- .jcall('org/guha/rcdk/util/Misc', 'S', 'getSmiles', molecule)
  smiles
}

get.smiles.parser <- function() {
  dcob <- .get.chem.object.builder()
  .jnew("org/openscience/cdk/smiles/SmilesParser", dcob)
}
parse.smiles <- function(smiles, preserve.aromaticity=FALSE) {
  if (!is.character(smiles)) {
    stop("Must supply a character vector of SMILES strings")
  }
  parser <- get.smiles.parser()
  if (preserve.aromaticity) .jcall(parser, "V", "setPreservingAromaticity", TRUE)
  returnValue <- sapply(smiles, 
      function(x) {
        mol <- .jcall(parser, "Lorg/openscience/cdk/interfaces/IAtomContainer;", "parseSmiles", x)    
        if (is.null(mol)){
          return(NA)
        } else {
          return(.jcast(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
        }
      })
  return(returnValue)
}
