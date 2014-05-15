## An example of getting all the coordinates for a molecule
## atoms <- get.atoms(mol)
## coords <- do.call('rbind', lapply(apply, get.point3d))

.valid.atom <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")
  return(atom)
}
get.point3d <- function(atom) {
  atom <- .valid.atom(atom)
  p3d <- .jcall(atom, "Ljavax/vecmath/Point3d;", "getPoint3d")
  if (is.jnull(p3d)) return( c(NA,NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'),
      .jfield(p3d, name='z'))
  }
}

get.point2d <- function(atom) {
  atom <- .valid.atom(atom)    
  p3d <- .jcall(atom, "Ljavax/vecmath/Point2d;", "getPoint2d")
  if (is.jnull(p3d)) return( c(NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'))
  }
}

get.symbol <- function(atom) {
  atom <- .valid.atom(atom)  
  .jcall(atom, "S", "getSymbol")
}

get.atomic.number <- function(atom) {
  atom <- .valid.atom(atom)
  .jcall(.jcall(atom, "Ljava/lang/Integer;", "getAtomicNumber"), "I", "intValue")
}

get.charge <- function(atom) {
  atom <- .valid.atom(atom)
  .jcall(.jcall(atom, "Ljava/lang/Double;", "getCharge"), "D", "doubleValue")
}

get.formal.charge <- function(atom) {
  atom <- .valid.atom(atom)
  .jcall(.jcall(atom, "Ljava/lang/Integer;", "getFormalCharge"), "I", "intValue")
}

get.hydrogen.count <- function(atom) {
  atom <- .valid.atom(atom)  
  .jcall(.jcall(atom, "Ljava/lang/Integer;", "getImplicitHydrogenCount"), "I", "intValue")
}

is.aromatic <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISAROMATIC")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

is.aliphatic <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISALIPHATIC")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

is.in.ring <- function(atom) {
  atom <- .valid.atom(atom)
  flag.idx <- .jfield("org/openscience/cdk/CDKConstants", "I", "ISINRING")
  .jcall(atom, "Z", "getFlag", as.integer(flag.idx))
}

get.connected.atoms <- function(atom, mol) {
  if (is.null(attr(mol, 'jclass')))
    stop("object must be of class IAtomContainer")
  
  if (attr(mol, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("object must be of class IAtomContainer")
  
  atom <- .valid.atom(atom)
  ret <- .jcall(mol, "Ljava/util/List;", "getConnectedAtomsList", atom)
  ret <- lapply(.javalist.to.rlist(ret), .jcast, new.class='org/openscience/cdk/interfaces/IAtom')
  return(ret)
}

get.atom.index <- function(atom, mol) {
  if (is.null(attr(mol, 'jclass')))
    stop("object must be of class IAtomContainer")
  
  if (attr(mol, 'jclass') != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("object must be of class IAtomContainer")
  
  atom <- .valid.atom(atom)
  .jcall(mol, "I", "getAtomNumber", atom)
}
