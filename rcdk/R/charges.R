#' Get the Total Charge for the Molecule
#' 
#' returns the summed partial charges for a molecule
#' and \code{\link{get.total.formal.charge}} returns the summed formal charges. Currently,
#' if one or more partial charges are unset, the function simply returns
#' the sum of formal charges (via \code{\link{get.total.formal.charge}}). This is slightly
#' different from how the CDK evaluates the total charge of a molecule 
#' (via \href{https://cdk.github.io/cdk/2.2/docs/api/org/openscience/cdk/tools/manipulator/AtomContainerManipulator.html}{AtomContainerManipulator.getTotalCharge()}), 
#' but is in line with how OEChem determines net charge on a molecule. In general, you will 
#' want to use the \code{\link{get.total.charge}} function.
#' 
#' @section XXX
#' @describeIn get.total.charge Get sum of partial charges
#' @param mol  A `jobjRef` objects of Java class `IAtomContainer`
#' @return An integer value indicating the total charge
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @seealso \code{\link{get.total.formal.charge}}
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

#' @section XXX
#' @describeIn get.total.formal.charge Get sum of formal charges
#' @export
get.total.formal.charge <- function(mol) {
  if (!.check.class(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
    stop("molecule must be of class IAtomContainer")
  .jcall('org/openscience/cdk/tools/manipulator/AtomContainerManipulator',
         'I',
         'getTotalFormalCharge',
         mol);
}
