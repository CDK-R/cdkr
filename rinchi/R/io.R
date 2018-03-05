.packageName <- "rinchi"

.onLoad <- function(lib, pkg) {
  dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
  if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
    Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
  }

  jar.rcdk <- paste(lib,pkg,"cont","rcdk.jar",sep=.Platform$file.sep)
  .jinit(classpath=c(jar.rcdk))

  assign("rinchi_globals", new.env(), envir=parent.env(environment()))
}

.assign.parser <- function() {
    assign("parser", .jnew("org/openscience/cdk/smiles/SmilesParser",
                           .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                                  "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                                  "getInstance")), envir=rinchi_globals)
}

.parse.smiles <- function(smiles, kekulise=TRUE) {
  if (!is.character(smiles)) {
    stop("Must supply a character vector of SMILES strings")
  }
  parser <- get("parser", rinchi_globals)
  if (is.null(parser)) {
      .assign.parser()
      parser <- get("parser", rinchi_globals)
  }
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
      ##molecule <- .parse.smiles(molecule)[[1]]
      molecule <- rcdk::parse.smiles(molecule)[[1]]
  } else if (is.null(attr(molecule, 'jclass')) ||
             attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object or a SMILES string")
  }
  .jcall("org/guha/rcdk/util/Misc", "S", "getInChiKey", molecule, check=FALSE)
}

parse.inchi <- function(inchis) {
  OKAY <- .jcall("net/sf/jniinchi/INCHI_RET", "Lnet/sf/jniinchi/INCHI_RET;", "getValue", as.integer(0))
  dcob <- .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                 "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                 "getInstance")
  igf <- .jcall("org/openscience/cdk/inchi/InChIGeneratorFactory",
                "Lorg/openscience/cdk/inchi/InChIGeneratorFactory;",
                "getInstance")
  mols <- lapply(inchis, function(inchi) { 
    i2s <- .jcall(igf, "Lorg/openscience/cdk/inchi/InChIToStructure;", "getInChIToStructure", inchi, dcob)
    status <- i2s$getReturnStatus();
    if (status == OKAY)
          .jcast(i2s$getAtomContainer(), "org/openscience/cdk/interfaces/IAtomContainer")
    else {
      warning(paste0("InChI parsing error for ", inchi, ": ", status$toString()))
      return(NULL)
    }
  })
  return(mols)
}
