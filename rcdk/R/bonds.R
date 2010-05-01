##get.bond.order <- function(bond) {
##  stop("Doesn't work at this point")
##  if (is.null(attr(bond, 'jclass')) ||
##      attr(bond, "jclass") != "org/openscience/cdk/interfaces/IBond") {
##    stop("Must supply an IBond object")
##  }
##
##  bo <- .jcall(bond, "Lorg/openscience/cdk/interfaces/IBond.Order;", "getBondOrder")
##  bo
##}
##

get.connected.atom <- function(bond, atom) {
  if (is.null(attr(bond,"jclass")) || is.null(attr(atom,"jclass")))
    stop("Must supply an IBond object or Bond")
  
  if (!.check.class(bond, "org/openscience/cdk/interfaces/IBond") &&
      !.check.class(bond, "org/openscience/cdk/Bond"))
    stop("Must supply an IBond or Bond object")

  if (.check.class(bond, "org/openscience/cdk/Bond"))
    bond <- .jcast(bond, "org/openscience/cdk/interfaces/IBond")

  if (!.check.class(atom, "org/openscience/cdk/interfaces/IAtom") &&
      !.check.class(atom, "org/openscience/cdk/Atom"))
    stop("Must supply an IAtom or Atom object")
  
  if (.check.class(atom, "org/openscience/cdk/Atom"))
    atom <- .jcast(atom, "org/openscience/cdk/interfaces/IAtom")
  
  .jcall(bond, "Lorg/openscience/cdk/interfaces/IAtom;", "getConnectedAtom", atom);
}
