get.smiles <- function(molecule, type = 'generic', aromatic=FALSE, atomClasses=FALSE) {
  if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
    stop("Supplied object should be a Java reference to an IAtomContainer")
  }
  smiles <- .jcall('org/guha/rcdk/util/Misc', 'S', 'getSmiles', molecule, as.character(type), as.logical(aromatic), as.logical(atomClasses))
  smiles
}

get.smiles.parser <- function() {
  dcob <- .get.chem.object.builder()
  .jnew("org/openscience/cdk/smiles/SmilesParser", dcob)
}
parse.smiles <- function(smiles, kekulise=TRUE) {
  if (!is.character(smiles)) {
    stop("Must supply a character vector of SMILES strings")
  }
  parser <- get.smiles.parser()
  .jcall(parser, "V", "kekulise", kekulise)
  returnValue <- sapply(smiles, 
      function(x) {
        mol <- tryCatch(
                        {
                          .jcall(parser, "Lorg/openscience/cdk/interfaces/IAtomContainer;", "parseSmiles", x)
                        }, error = function(e) {
                          return(NULL)
                        }
                        )
        if (is.null(mol)){
          return(NA)
        } else {
          return(.jcast(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
        }
      })
  return(returnValue)
}
