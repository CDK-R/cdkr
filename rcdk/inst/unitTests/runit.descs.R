library(devtools)
library(RUnit)
load_all(".")
.jinit(classpath=c("/Users/guha/src/cdkr/rcdk/inst/cont/rcdk.jar"))

test.atom.descriptors.alanine <- function() {
  alanine_file <- system.file("molfiles/alanine.sdf", packge="rcdk")
  mols <- load.molecules(as.character("/Users/guha/Downloads/alanine.sdf"), 
                         typing=TRUE, aromaticity = TRUE,
                         verbose=as.logical(TRUE))
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  (lapply(mols, convert.implicit.to.explicit))
  dvals <- eval.atomic.desc(mols[[1]], adn[c(1,6)], verbose=TRUE)
  checkTrue(ncol(dvals) > 2)
}

test.atom.descriptors.glutamine <- function() {
  glutamine_file <- system.file("molfiles/glutamine.sdf", packge="rcdk")
  mol <- load.molecules(as.character("/Users/guha/Downloads/glutamine.sdf"), 
                         typing=TRUE, aromaticity = TRUE,
                         verbose=as.logical(TRUE))[[1]]
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[c(17,1)], verbose=TRUE)
  checkTrue(ncol(dvals) > 2)
}

test.atom.descriptor.conjugated.pi.system <- function() {
  glutamine_file <- system.file("molfiles/glutamine.sdf", packge="rcdk")
  mol <- load.molecules(glutamine_file, 
                        typing=TRUE, aromaticity = TRUE,
                        verbose=as.logical(TRUE))[[1]]
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[c(17,1)], verbose=TRUE)
  checkTrue(ncol(dvals) == 2)
  checkTrue(all(!dvals[,1]))
  
  alanine_file <- system.file("molfiles/alanine.sdf", packge="rcdk")
  mol <- load.molecules(alanine_file, 
                        typing=TRUE, aromaticity = TRUE,
                        verbose=as.logical(TRUE))[[1]]
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[c(17,1)], verbose=TRUE)
  checkTrue(ncol(dvals) == 2)
  checkTrue(all(!dvals[,1]))
  
}

