## An example of getting all the coordinates for a molecule
## atoms <- get.atoms(mol)
## coords <- do.call('rbind', lapply(apply, get.point3d))

get.point3d <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")
  
  p3d <- .jcall(atom, "Ljavax/vecmath/Point3d;", "getPoint3d")
  if (is.jnull(p3d)) return( c(NA,NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'),
      .jfield(p3d, name='z'))
  }
}

get.point2d <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")

  p3d <- .jcall(atom, "Ljavax/vecmath/Point2d;", "getPoint2d")
  if (is.jnull(p3d)) return( c(NA,NA) )
  else {
    c(.jfield(p3d, name='x'),
      .jfield(p3d, name='y'))
  }
}

get.symbol <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")
  
  .jcall(atom, "S", "getSymbol")
}

get.atomic.number <- function(atom) {
  if (is.null(attr(atom, 'jclass'))) stop("Must supply an Atom or IAtom object")
  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an Atom or IAtom object")

  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")

  .jcall(atom, "I", "getAtomicNumber")
}
