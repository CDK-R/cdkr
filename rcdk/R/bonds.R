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

#' Get the atom connected to an atom in a bond.
#' 
#' This function returns the atom that is connected to a
#' specified in a specified bond. Note that this function assumes
#' 2-atom bonds, mainly because the CDK does not currently
#' support other types of bonds
#' 
#' @param bond A \code{jObjRef} representing an `IBond` object
#' @param atom A \code{jObjRef} representing an `IAtom` object
#' @return A \code{jObjRef} representing an `IAtom`` object
#' @seealso \code{\link{get.atoms}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
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

#' Get an object representing bond order
#' 
#' This function returns a Java enum representing a
#' bond order. This can be used to modify the order
#' of pre-existing bonds
#' 
#' @param order A character vector that can be one of single, double, triple,
#' quadruple, quintuple, sextuple or unset. Case is ignored
#' @return A \code{jObjRef} representing an `Order` enum object
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' \dontrun{
#' m <- parse.smiles('CCN')[[1]]
#' b <- get.bonds(m)[[1]]
#' b$setOrder(get.bond.order("double"))
#' }
get.bond.order <- function(order = 'single') {
  switch(tolower(order), 
        single = get("BOND_ORDER_SINGLE", envir = .rcdk.GlobalEnv),
        double = get("BOND_ORDER_DOUBLE", envir = .rcdk.GlobalEnv),
        triple = get("BOND_ORDER_TRIPLE", envir = .rcdk.GlobalEnv),
        quadruple = get("BOND_ORDER_QUADRUPLE", envir = .rcdk.GlobalEnv),
        quintuple = get("BOND_ORDER_QUINTUPLE", envir = .rcdk.GlobalEnv),
        sextuple = get("BOND_ORDER_SEXTUPLE", envir = .rcdk.GlobalEnv),
        unset = get("BOND_ORDER_UNSET", envir = .rcdk.GlobalEnv),
        )
}