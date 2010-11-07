hasNext <- function(obj, ...) { UseMethod("hasNext") } 
hasNext.iload.molecules <- function(obj, ...) obj$hasNext()
iload.molecules<- function(molfile, type = 'smi', aromaticity = TRUE, typing = TRUE, isotopes = TRUE) {
  fr <- .jnew("java/io/FileReader", as.character(molfile))
  dcob <- .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                 "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                 "getInstance")
  if (type == 'smi') {
    sreader <- .jnew("org/openscience/cdk/io/iterator/IteratingSMILESReader",.jcast(fr, "java/io/Reader"), dcob)
  } else if (type == 'sdf') {
    sreader <- .jnew("org/openscience/cdk/io/iterator/IteratingMDLReader",.jcast(fr, "java/io/Reader"), dcob)    
  }
  hasNext <- NA
  mol <- NA
  molr <- NA
  
  hasNx <- function() {
    hasNext <<- .jcall(sreader, "Z", "hasNext")
    if (!hasNext) {
      .jcall(sreader, "V", "close")      
      mol <<- NA
    }
    return(hasNext)
  }
  
  nextEl <- function() {
    mol <<- .jcall(sreader, "Ljava/lang/Object;", "next")
    mol <<- .jcast(mol, "org/openscience/cdk/interfaces/IAtomContainer")
    if (aromaticity) do.aromaticity(mol)
    if (typing) do.typing(mol)
    if (isotopes) do.isotopes(mol)

    hasNext <<- NA    
    return(mol)
  }

  obj <- list(nextElem = nextEl, hasNext = hasNx)
  class(obj) <- c("iload.molecules", "abstractiter", "iter")
  obj
}
