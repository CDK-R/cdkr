#library(devtools)
library(RUnit)
library(rcdk)
#load_all(".")
# .jinit(classpath=c("/Users/guha/src/cdkr/rcdk/inst/cont/rcdk.jar"))

test.atom.descriptors.alanine <- function() {
  alanine_file <- system.file("molfiles/alanine.sdf", package="rcdk")
  mols <- load.molecules(molfiles=alanine_file,  typing=TRUE, aromaticity=TRUE, verbose=TRUE)
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  (lapply(mols, convert.implicit.to.explicit))
  dvals <- eval.atomic.desc(mols[[1]], adn[c(1,6)], verbose=TRUE)
  checkTrue(ncol(dvals) > 2)
  checkTrue(all(is.na(dvals[,2])))
}

test.atom.descriptors.rdf.glutamine <- function() {
  glutamine_file <- system.file("molfiles/glutamine.sdf", package="rcdk")
  mol <- load.molecules(molfiles=glutamine_file,
                         typing=TRUE, aromaticity = TRUE,
                         verbose=as.logical(TRUE))[[1]]
  glutamine_file <- mol
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[4:8], verbose=TRUE)
  checkTrue(ncol(dvals) > 2)
  checkTrue(all(dvals$gDr_1[11:20]==0))
  checkTrue(all(dvals$gDr_2[11:20]==0))
  checkTrue(all(dvals$gDr_3[11:20]==0))
  checkTrue(all(dvals$gDr_4[11:20]==0))
  checkTrue(all(dvals$gDr_5[11:20]==0))
  checkTrue(all(dvals$gDr_6[11:20]==0))
  checkTrue(all(dvals$gDr_7[11:20]==0))
  checkTrue(all(!is.na(dvals$gSr_1[18:19])))
  checkTrue(all(!is.na(dvals$gSr_2[18:19])))
  checkTrue(all(!is.na(dvals$gSr_3[18:19])))
  checkTrue(all(!is.na(dvals$gSr_4[18:19])))
  checkTrue(all(!is.na(dvals$gSr_5[18:19])))
  checkTrue(all(!is.na(dvals$gSr_6[18:19])))
  checkTrue(all(!is.na(dvals$gSr_7[18:19])))
}

test.atom.descriptor.conjugated.pi.system <- function() {
  glutamine_file <- system.file("molfiles/glutamine.sdf", package="rcdk")
  mol <- load.molecules(molfiles=glutamine_file,typing=TRUE, aromaticity = TRUE, verbose=TRUE)[[1]]
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[c(17,1)], verbose=TRUE)
  checkTrue(ncol(dvals) == 2)
  checkTrue(all(!dvals[,1]))
  
  alanine_file <- system.file("molfiles/alanine.sdf", package="rcdk")
  mol <- load.molecules(molfiles=alanine_file, typing=TRUE, aromaticity = TRUE, verbose=as.logical(TRUE))[[1]]
  adn <- get.atomic.desc.names()
  checkTrue(length(adn) > 0)
  
  convert.implicit.to.explicit(mol)
  dvals <- eval.atomic.desc(mol, adn[c(17,1)], verbose=TRUE)
  checkTrue(ncol(dvals) == 2)
  checkTrue(all(!dvals[,1]))
  
}

