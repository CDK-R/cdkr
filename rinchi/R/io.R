.packageName <- "rinchi"

.onLoad <- function(lib, pkg) {
  dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
  if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
    Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
  }

  jar.rcdk <- paste(lib,pkg,"cont","rcdk.jar",sep=.Platform$file.sep)
  jars <- list.files(path=paste(lib,pkg,"cont", sep=.Platform$file.sep),
                      pattern="jar$", full.names=TRUE)

  .jinit(classpath=c(jars))
}

.get.chem.object.builder <- function() {
  dcob <- .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                 "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                 "getInstance")
  return(dcob)
}
.get.smiles.parser <- function() {
  dcob <- .get.chem.object.builder()
  .jnew("org/openscience/cdk/smiles/SmilesParser", dcob)
}
.parse.smiles <- function(smiles, kekulise=TRUE) {
  if (!is.character(smiles)) {
    stop("Must supply a character vector of SMILES strings")
  }
  parser <- .get.smiles.parser()
  .jcall(parser, "V", "kekulise", kekulise)
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


get.inchi <- function(molecule) {
  if (is.character(molecule)) {
    molecule <- .parse.smiles(molecule)[[1]]
  } else if (is.null(attr(molecule, 'jclass')) ||
             attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object or a SMILES string")
  }
  .jcall("org/guha/rcdk/util/Misc", "S", "getInChi", molecule, check=FALSE)
}

get.inchi.key <- function(molecule) {
  if (is.character(molecule)) {
    molecule <- .parse.smiles(molecule)[[1]]
  } else if (is.null(attr(molecule, 'jclass')) ||
             attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object or a SMILES string")
  }
  .jcall("org/guha/rcdk/util/Misc", "S", "getInChiKey", molecule, check=FALSE)
}

