.packageName <- "rcdk"

#' Get the default chemical object builder.
#' 
#' The CDK employs a builder design pattern to construct
#' instances of new chemical objects (e.g., atoms, bonds, parsers
#' and so on). Many methods require an instance of a builder 
#' object to function. While most functions in this package handle
#' this internally, it is useful to be able to get an instance of
#' a builder object when directly working with the CDK API via
#' `rJava`.
#' 
#' This method returns an instance of the \href{http://cdk.github.io/cdk/2.2/docs/api/org/openscience/cdk/silent/SilentChemObjectBuilder.html}{SilentChemObjectBuilder}. 
#' Note that this is a static object that is created at package load time, 
#' and the same instance is returned whenever this function is called.
#' 
#' @return An instance of \href{http://cdk.github.io/cdk/2.3/docs/api/org/openscience/cdk/silent/SilentChemObjectBuilder.html}{SilentChemObjectBuilder}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.chem.object.builder <- function() {
  return(get("dcob", envir = .rcdk.GlobalEnv))
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

#'
#' @import fingerprint
#' @import methods
#' @import rJava
#' @import png
#' @import iterators
#' @import itertools
#' @import rcdklibs
#'
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
  
  # Extract the bond order enums so we can return them without going through
  # Java each time we want one
  assign("BOND_ORDER_SINGLE", J("org.openscience.cdk.interfaces.IBond")$Order$SINGLE,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_DOUBLE", J("org.openscience.cdk.interfaces.IBond")$Order$DOUBLE,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_TRIPLE", J("org.openscience.cdk.interfaces.IBond")$Order$TRIPLE,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_UNSET", J("org.openscience.cdk.interfaces.IBond")$Order$UNSET,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_QUADRUPLE", J("org.openscience.cdk.interfaces.IBond")$Order$QUADRUPLE,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_QUINTUPLE", J("org.openscience.cdk.interfaces.IBond")$Order$QUINTUPLE,
         envir = .rcdk.GlobalEnv)
  assign("BOND_ORDER_SEXTUPLE", J("org.openscience.cdk.interfaces.IBond")$Order$SEXTUPLE,
         envir = .rcdk.GlobalEnv)
}

#' Get the current CDK version used in the package.
#' 
#' @return Returns a character containing the version of the CDK used in this package
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
cdk.version <- function() {
  .jcall("org.openscience.cdk.CDK", "S", "getVersion")
}

#' Remove explicit hydrogens.
#' 
#' Create an copy of the original structure with explicit hydrogens removed. 
#' Stereochemistry is updated but up and down bonds in a depiction may need 
#' to be recalculated. This can also be useful for descriptor calculations.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return A copy of the original molecule, with explicit hydrogens removed
#' @seealso \code{\link{get.hydrogen.count}}, \code{\link{get.total.hydrogen.count}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
remove.hydrogens <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  newmol <- .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
                   'Lorg/openscience/cdk/interfaces/IAtomContainer;',
                   'removeHydrogens',
                   mol);
  newmol
}

#' Get total number of implicit hydrogens in the molecule.
#' 
#' Counts the number of hydrogens on the provided molecule. As this method 
#' will sum all implicit hydrogens on each atom it is important to ensure 
#' the molecule has already been configured (and thus each atom has an 
#' implicit hydrogen count). 
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return An integer representing the total number of implicit hydrogens
#' @seealso \code{\link{get.hydrogen.count}}, \code{\link{remove.hydrogens}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.total.hydrogen.count <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalHydrogenCount',
         mol);
}

#' get.exact.mass
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
get.exact.mass <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  
  formulaJ <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                     "Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                     "getMolecularFormula",
                     mol,
                     use.true.class=FALSE);
  
  
  ret <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                'D',
                'getTotalExactMass',
                formulaJ,
                check=FALSE)
  
  ex <- .jgetEx(clear=TRUE)
  
  
  if (is.null(ex)) return(ret)
  else{
    print(ex)
    stop("Couldn't get exact mass. Maybe you have not performed aromaticity, atom type or isotope configuration?")
  }
}
  

#' get.natural.mass
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
get.natural.mass <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  ret <- .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
                'D',
                'getNaturalExactMass',
                mol,
                check=FALSE)
  ex <- .jgetEx(clear=TRUE)
  if (is.null(ex)) return(ret)
  else{
    print(ex)
    stop("Couldn't get natural mass. Maybe you have not performed aromaticity, atom type or isotope configuration?")
  }  
}

#' get.total.charge
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
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

#' get.total.formal.charge
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
get.total.formal.charge <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalFormalCharge',
         mol);
}

#' Convert implicit hydrogens to explicit.
#' 
#' In some cases, a molecule may not have any hydrogens (such as when read
#' in from an MDL MOL file that did not have hydrogens or SMILES with no
#' explicit hydrogens). In such cases, this method
#' will add implicit hydrogens and then convert them to explicit ones. The 
#' newly added H's will not have any 2D or 3D coordinates associated with them.
#' Ensure that the molecule has been typed beforehand.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @seealso \code{\link{get.hydrogen.count}}, \code{\link{remove.hydrogens}}, \code{\link{set.atom.types}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
convert.implicit.to.explicit <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")

    if (any(is.null(unlist(lapply(get.atoms(mol), .jcall, returnSig = "Ljava/lang/Integer;", method="getImplicitHydrogenCount"))))) {
    ## add them in
    dcob <- get.chem.object.builder()
    hadder <- .jcall("org/openscience/cdk/tools/CDKHydrogenAdder", "Lorg/openscience/cdk/tools/CDKHydrogenAdder;",
                     "getInstance", dcob)
    .jcall(hadder, "V", "addImplicitHydrogens", mol)
  }
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator', 'V', 'convertImplicitToExplicitHydrogens', mol)
}


#' Get the atoms from a molecule or bond.
#' 
#' @param object A `jobjRef` representing either a molecule (`IAtomContainer`) or 
#' bond (`IBond`) object.
#' @return A list of `jobjRef` representing the `IAtom` objects in the molecule or bond
#' @seealso \code{\link{get.bonds}}, \code{\link{get.connected.atoms}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
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

#' Get the bonds in a molecule.
#' 
#' @param mol A `jobjRef` representing the molecule (`IAtomContainer`) object.
#' @return A list of `jobjRef` representing the bonds (`IBond`) objects in the molecule
#' @seealso \code{\link{get.atoms}}, \code{\link{get.connected.atoms}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.bonds <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  nbond <- .jcall(mol, "I", "getBondCount")
  bonds <- list()
  for (i in 0:(nbond-1))
    bonds[[i+1]] <- .jcall(mol, "Lorg/openscience/cdk/interfaces/IBond;", "getBond", as.integer(i))
  bonds
}

#' do.aromaticity
#' 
#' detect aromaticity of an input compound
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
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

#' do.isotopes
#' 
#' configure isotopes
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @export
do.isotopes <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  ifac <- .jcall('org.openscience.cdk.config.Isotopes',
                 'Lorg/openscience/cdk/config/Isotopes;',
                 'getInstance')
  .jcall(ifac, 'V', 'configureAtoms', mol)
}

#' Tests whether the molecule is neutral.
#' 
#' The test checks whether all atoms in the molecule have a formal charge of 0.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return `TRUE` if molecule is neutral, `FALSE` otherwise
#' @aliases charge
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
is.neutral <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  atoms <- get.atoms(mol)
  fc <- unlist(lapply(atoms, get.formal.charge))
  return(all(fc == 0))
}

#' Tests whether the molecule is fully connected.
#' 
#' A single molecule will be represented as a 
#' \href{https://en.wikipedia.org/wiki/Complete_graph}{complete} graph. 
#' In some cases, such as for molecules in salt form, or after certain 
#' operations such as bond splits, the molecular graph may contained 
#' \href{http://mathworld.wolfram.com/DisconnectedGraph.html}{disconnected components}.
#' This method can be used to tested whether the molecule is complete (i.e. fully
#' connected).
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return `TRUE` if molecule is complete, `FALSE` otherwise
#' @seealso \code{\link{get.largest.component}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' m <- parse.smiles("CC.CCCCCC.CCCC")[[1]]
#' is.connected(m)
is.connected <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall("org.openscience.cdk.graph.ConnectivityChecker",
         "Z", "isConnected", mol)
}

#' Gets the largest component in a disconnected molecular graph.
#' 
#' A molecule may be represented as a 
#' \href{http://mathworld.wolfram.com/DisconnectedGraph.html}{disconnected graph}, such as
#' when read in as a salt form. This method will return the larges connected component
#' or if there is only a single component (i.e., the molecular graph is 
#' \href{https://en.wikipedia.org/wiki/Complete_graph}{complete} or fully connected), that
#' component is returned.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return The largest component as an `IAtomContainer` object or else the input molecule itself
#' @seealso \code{\link{is.connected}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' m <- parse.smiles("CC.CCCCCC.CCCC")[[1]]
#' largest <- get.largest.component(m)
#' length(get.atoms(largest)) == 6
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

#' Get the number of atoms in the molecule.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return An integer representing the number of atoms in the molecule
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.atom.count <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall(mol, "I", "getAtomCount")
}

#' Get the title of the molecule.
#' 
#' Some molecules may not have a title (such as when parsing in a SMILES
#' with not title).
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return A character string with the title, `NA` is no title is specified
#' @seealso \code{\link{set.title}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.title <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  get.property(mol, "cdk:Title")
}

#' Set the title of the molecule.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param title The title of the molecule as a character string. This will overwrite
#' any pre-existing title. The default value is an empty string.
#' @seealso \code{\link{get.title}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
set.title <- function(mol, title = "") {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  set.property(mol, "cdk:Title", title)
}

#' Generate 2D coordinates for a molecule.
#' 
#' Some file formats such as SMILES do not support 2D (or 3D) coordinates
#' for the atoms. Other formats such as SD or MOL have support for coordinates
#' but may not include them. This method will generate reasonable 2D coordinates 
#' based purely on connectivity information, overwriting
#' any existing coordinates if present. 
#' 
#' Note that when depicting a molecule (\code{\link{view.molecule.2d}}), 2D coordinates
#' are generated, but since it does not modify the input molecule, we do not have access
#' to the generated coordinates.
#' 
#' @param mol The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return The input molecule, with 2D coordinates added
#' @seealso \code{\link{get.point2d}}, \code{\link{view.molecule.2d}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
generate.2d.coordinates <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  
  .jcall('org/guha/rcdk/util/Misc', 'Lorg/openscience/cdk/interfaces/IAtomContainer;',
         'getMoleculeWithCoordinates', mol)
}
