test.atom.descriptors.1 <- function() {
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


