.packageName <- "rcdk"

## .First.lib code taken from iPlots

require(rJava, quietly=TRUE)

.check.class <- function(obj, klass) {
  attr(obj, "jclass") == klass
}

.trim.whitespace <- function(x) {
  x <- gsub('^[[:space:]]+', '', x)
  gsub('[[:space:]]+$', '',x)
}

.First.lib <- function(lib, pkg) {
  dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
  if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
    Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
  }

  jar.rcdk <- paste(lib,pkg,"cont","rcdk.jar",sep=.Platform$file.sep)
  jar.png <- paste(lib,pkg,"cont","com.objectplanet.image.PngEncoder.jar",sep=.Platform$file.sep)
  .jinit(classpath=c(jar.rcdk,jar.png))
}



remove.hydrogens <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  newmol <- .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
                   'Lorg/openscience/cdk/interfaces/IAtomContainer;',
                   'removeHydrogens',
                   molecule);
  newmol
}

get.total.hydrogen.count <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalHydrogenCount',
         molecule);
}

get.exact.mass <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'D',
         'getTotalExactMass',
         molecule);
}

get.natural.mass <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'D',
         'getNaturalExactMass',
         molecule);
}


get.total.charge <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'D',
         'getTotalCharge',
         molecule);
}

convert.implicit.to.explicit <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')) ||
      attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator', 'V', 'convertImplicitToExplicitHydrogens', molecule)
}


get.fingerprint <- function(molecule, type = 'standard', depth=6, size=1024) {
  if (is.null(attr(molecule, 'jclass'))) stop("Must supply an IAtomContainer or something coercable to it")
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    ## try casting it
    molecule <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")
  }

  mode(size) <- 'integer'
  mode(depth) <- 'integer'
  
  fingerprinter <-
    switch(type,
           standard = .jnew('org/openscience/cdk/fingerprint/Fingerprinter', size, depth),
           extended = .jnew('org/openscience/cdk/fingerprint/ExtendedFingerprinter', size, depth),
           graph = .jnew('org/openscience/cdk/fingerprint/GraphOnlyFingerprinter', size, depth),
           maccs = .jnew('org/openscience/cdk/fingerprint/MACCSFingerprinter'),
           estate = .jnew('org/openscience/cdk/fingerprint/EStateFingerprinter'))
  if (is.null(fingerprinter)) stop("Invalid fingerprint type specified")
  
  bitset <- .jcall(fingerprinter, "Ljava/util/BitSet;", "getFingerprint", molecule)
  if (type == 'maccs') nbit <- 166
  else if (type == 'estate') nbit <- 79
  else nbit <- size
  
  bitset <- .jcall(bitset, "S", "toString")
  s <- gsub('[{}]','', bitset)
  s <- strsplit(s, split=',')[[1]]
  moltitle <- get.property(molecule, 'Title')
  if (is.na(moltitle)) moltitle <- ''
  return(new("fingerprint", nbit=nbit, bits=as.numeric(s)+1, provider="CDK", name=moltitle))
}

get.atoms <- function(object) {
  if (is.null(attr(object, 'jclass')))
    stop("object must be of class IAtomContainer or IObject or IBond")
  
  if (attr(object, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer" &&
      attr(object, 'jclass') != "org/openscience/cdk/interfaces/IObject" &&
      attr(object, 'jclass') != "org/openscience/cdk/interfaces/IBond")
    stop("object must be of class IAtomContainer or IObject or IBond")

  natom <- .jcall(object, "I", "getAtomCount")
  atoms <- list()
  for (i in 0:(natom-1))
    atoms[[i+1]] <- .jcall(object, "Lorg/openscience/cdk/interfaces/IAtom;", "getAtom", as.integer(i))
  atoms
}

get.bonds <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')))
    stop("molecule must be of class IAtomContainer or IMolecule")
  if (attr(molecule, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer" &&
      attr(molecule, 'jclass') != "org/openscience/cdk/interfaces/IMolecule")
    stop("molecule must be of class IAtomContainer or IMolecule")

  nbond <- .jcall(molecule, "I", "getBondCount")
  bonds <- list()
  for (i in 0:(nbond-1))
    bonds[[i+1]] <- .jcall(molecule, "Lorg/openscience/cdk/interfaces/IBond;", "getBond", as.integer(i))
  bonds
}

do.aromaticity <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')))
    stop("molecule must be of class IAtomContainer or IMolecule")
  if (attr(molecule, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("molecule must be of class IAtomContainer or IMolecule")

  .jcall("org.openscience.cdk.aromaticity.CDKHueckelAromaticityDetector",
         "Z", "detectAromaticity", molecule)
}

do.typing <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')))
    stop("molecule must be of class IAtomContainer or IMolecule")
  if (attr(molecule, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("molecule must be of class IAtomContainer or IMolecule")

  .jcall("org.openscience.cdk.tools.manipulator.AtomContainerManipulator",
         "V", "percieveAtomTypesAndConfigureAtoms", molecule)
}

do.isotopes <- function(molecule) {
  if (is.null(attr(molecule, 'jclass')))
    stop("molecule must be of class IAtomContainer or IMolecule")
  if (attr(molecule, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("molecule must be of class IAtomContainer or IMolecule")

  builder <- .jcall(.jnew('org/openscience/cdk/ChemObject'),
                    'Lorg/openscience/cdk/interfaces/IChemObjectBuilder;', 'getBuilder')
  ifac <- .jcall('org.openscience.cdk.config.IsotopeFactory',
                 'Lorg/openscience/cdk/config/IsotopeFactory;',
                 'getInstance', builder)
  .jcall(ifac, 'V', 'configureAtoms', molecule)

}
