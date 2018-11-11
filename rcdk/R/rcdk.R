.packageName <- "rcdk"

.get.chem.object.builder <- function() {
  dcob <- .jcall("org/openscience/cdk/silent/SilentChemObjectBuilder",
                 "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                 "getInstance")
  return(dcob)
}

.check.class <- function(obj, klass) {
  !is.null(attr(obj, 'jclass')) && attr(obj, "jclass") == klass
}

.trim.whitespace <- function(x) {
  x <- gsub('^[[:space:]]+', '', x)
  gsub('[[:space:]]+$', '',x)
}

.javalist.to.rlist <- function(l) {
  size <- .jcall(l, "I", "size")
  if (size == 0) return(list())
  rl <- list()
  for (i in 1:size)
    rl[[i]] <- .jcall(l, "Ljava/lang/Object;", "get", as.integer(i-1))
  return(rl)
}

.onLoad <- function(lib, pkg) {
  dlp<-Sys.getenv("DYLD_LIBRARY_PATH")
  if (dlp!="") { # for Mac OS X we need to remove X11 from lib-path
    Sys.setenv("DYLD_LIBRARY_PATH"=sub("/usr/X11R6/lib","",dlp))
  }

  jar.rcdk <- paste(lib,pkg,"cont","rcdk.jar",sep=.Platform$file.sep)
  jar.png <- paste(lib,pkg,"cont","com.objectplanet.image.PngEncoder.jar",sep=.Platform$file.sep)
  .jinit(classpath=c(jar.rcdk,jar.png))
  
  # check Java Version 
  jv <- .jcall("java/lang/System", "S", "getProperty", "java.runtime.version")
  if(substr(jv, 1L, 2L) == "1.") {
    jvn <- as.numeric(paste0(strsplit(jv, "[.]")[[1L]][1:2], collapse = "."))
    if(jvn < 1.8) stop("Java >= 8 is needed for this package but not available")
  }

  ## generate some Java objects which get reused, so as to avoid repeated .jnew()
  nRule <- .jnew("org/openscience/cdk/formula/rules/NitrogenRule");
  rdbeRule <- .jnew("org/openscience/cdk/formula/rules/RDBERule");
  assign(".rcdk.GlobalEnv", new.env(parent = emptyenv()), envir = topenv())
  assign("nRule", nRule, envir = .rcdk.GlobalEnv)
  assign("rdbeRule", rdbeRule, envir = .rcdk.GlobalEnv)
  assign("dcob", .jcall("org/openscience/cdk/silent/SilentChemObjectBuilder",
                        "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                        "getInstance"), envir = .rcdk.GlobalEnv)
  assign("mfManipulator", .jnew("org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator"), envir = .rcdk.GlobalEnv)
}

cdk.version <- function() {
  .jcall("org.openscience.cdk.CDK", "S", "getVersion")
}

remove.hydrogens <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  newmol <- .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
                   'Lorg/openscience/cdk/interfaces/IAtomContainer;',
                   'removeHydrogens',
                   mol);
  newmol
}

get.total.hydrogen.count <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalHydrogenCount',
         mol);
}

get.total.charge <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  ## check to see if we have partial charges
  atoms <- get.atoms(mol)
  pcharges <- unlist(lapply(atoms, get.charge))

  ## If any are null, partial charges were not set, so
  ## just return the total formal charge
  if (any(is.null(pcharges))) return(get.total.formal.charge(mol))
  else {
    .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
           'D',
           'getTotalCharge',
           mol);
  }
}

get.total.formal.charge <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalFormalCharge',
         mol);
}


convert.implicit.to.explicit <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")

    if (any(is.null(unlist(lapply(get.atoms(mol), .jcall, returnSig = "Ljava/lang/Integer;", method="getImplicitHydrogenCount"))))) {
    ## add them in
    dcob <- .get.chem.object.builder()
    hadder <- .jcall("org/openscience/cdk/tools/CDKHydrogenAdder", "Lorg/openscience/cdk/tools/CDKHydrogenAdder;",
                     "getInstance", dcob)
    .jcall(hadder, "V", "addImplicitHydrogens", mol)
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator', 'V', 'convertImplicitToExplicitHydrogens', mol)
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

get.bonds <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  nbond <- .jcall(mol, "I", "getBondCount")
  bonds <- list()
  for (i in 0:(nbond-1))
    bonds[[i+1]] <- .jcall(mol, "Lorg/openscience/cdk/interfaces/IBond;", "getBond", as.integer(i))
  bonds
}

do.aromaticity <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  model <- .jcall("org/openscience/cdk/aromaticity/ElectronDonation",
                  "Lorg/openscience/cdk/aromaticity/ElectronDonation;",
                  "daylight")
  cycles.all <- .jcall("org/openscience/cdk/graph/Cycles", 
                      "Lorg/openscience/cdk/graph/CycleFinder;",
                      "all")
  cycles.6 <- .jcall("org.openscience.cdk.graph.Cycles", 
                    "Lorg/openscience/cdk/graph/CycleFinder;",
                    "all", as.integer(6))
  cycles <- .jcall("org.openscience.cdk.graph.Cycles", 
                  "Lorg/openscience/cdk/graph/CycleFinder;",
                  "or", cycles.all, cycles.6)
  aromaticity <- .jnew("org/openscience/cdk.aromaticity/Aromaticity",
                       model, cycles)
  .jcall(aromaticity, "Z", "apply", mol)
}

do.typing <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall("org.openscience.cdk.tools.manipulator.AtomContainerManipulator",
         "V", "percieveAtomTypesAndConfigureAtoms", mol)
}

do.isotopes <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  ifac <- .jcall('org.openscience.cdk.config.Isotopes',
                 'Lorg/openscience/cdk/config/Isotopes;',
                 'getInstance')
  .jcall(ifac, 'V', 'configureAtoms', mol)
}

is.neutral <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  atoms <- get.atoms(mol)
  fc <- unlist(lapply(atoms, get.formal.charge))
  return(all(fc == 0))
}

is.connected <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall("org.openscience.cdk.graph.ConnectivityChecker",
         "Z", "isConnected", mol)
}

get.largest.component <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  isConnected <- .jcall("org.openscience.cdk.graph.ConnectivityChecker",
                        "Z", "isConnected", mol)
  if (isConnected) return(mol)
  molSet <- .jcall("org.openscience.cdk.graph.ConnectivityChecker",
                   "Lorg/openscience/cdk/interfaces/IAtomContainerSet;",
                   "partitionIntoMolecules", mol)
  ncomp <- .jcall(molSet, "I", "getAtomContainerCount")
  max.idx <- -1
  max.atom.count <- -1
  for (i in seq_len(ncomp)) {
    m <- .jcall(molSet, "Lorg/openscience/cdk/interfaces/IAtomContainer;",
                "getAtomContainer", as.integer(i-1))
    natom <- .jcall(m, "I", "getAtomCount")
    if (natom > max.atom.count) {
      max.idx <- i
      max.atom.count <- natom
    }
  }
  m <- .jcall(molSet, "Lorg/openscience/cdk/interfaces/IAtomContainer;",
              "getAtomContainer", as.integer(max.idx-1))
  .jcast(m, "org/openscience/cdk/interfaces/IAtomContainer")
}

get.atom.count <- function(molecule) {
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall(molecule, "I", "getAtomCount")
}

get.title <- function(molecule) {
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  get.property(molecule, "cdk:Title")
}

generate.2d.coordinates <- function(molecule) {
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall('org/guha/rcdk/util/Misc', 'Lorg/openscience/cdk/interfaces/IAtomContainer;',
         'getMoleculeWithCoordinates', molecule)
}
