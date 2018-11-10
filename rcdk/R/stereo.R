#' Identify which atoms are stereocenters.
#'
#' This method identifies stereocenters based on connectivity.
#'
#' @param mol A \code{jObjRef} representing an \code{IAtomContainer}
#' @return A logical vector of length equal in length to the number of atoms. The i'th element is \code{TRUE} if the i'th element is identified as a stereocenter
#' @seealso \code{\link{get.element.types}}, \code{\link{get.stereo.types}}
#' @author Rajarshi Guha \email{rajarshi.guha@gmail.com}
#' @export
get.stereocenters <- function(mol) {
    if (attr(mol, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
        stop("Must supply an IAtomContainer object")
    
    centers <- .jcall("org/openscience/cdk/stereo/Stereocenters",
                      "Lorg/openscience/cdk/stereo/Stereocenters;",
                      "of",
                      mol)
    sapply(0:(get.atom.count(mol)-1), function(i) {
        .jcall(centers, "Z", "isStereocenter", as.integer(i))
    })
}

#' Obtain the type of stereo element support for atom.
#'
#' Supported elements types are
#' \describe{
#' \item{Bicoordinate}{an central atom involved in a cumulated system (not yet supported)}
#' \item{Tricoordinate}{an atom at one end of a geometric (double-bond) stereo bond or cumulated system}
#' \item{Tetracoordinate}{a tetrahedral atom (could also be square planar in future)}
#' \item{None}{the atom is not a (supported) stereo element type}
#' }
#'
#' @param mol A \code{jObjRef} representing an \code{IAtomContainer}
#' @return A factor of length equal in length to the number of atoms, indicating the element type
#' @seealso \code{\link{get.stereocenters}}, \code{\link{get.stereo.types}}
#' @author Rajarshi Guha \email{rajarshi.guha@gmail.com}
#' @export
get.element.types <- function(mol) {
    if (attr(mol, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
        stop("Must supply an IAtomContainer object")
    
    centers <- .jcall("org/openscience/cdk/stereo/Stereocenters",
                      "Lorg/openscience/cdk/stereo/Stereocenters;",
                      "of",
                      mol)
    stypes <- sapply(0:(get.atom.count(mol)-1), function(i) {
        .jcall(centers,
               "Lorg/openscience/cdk/stereo/Stereocenters$Type;",
               "elementType", as.integer(i))
    })
    stypes <- sapply(stypes, function(x) x$toString())
    factor(stypes, levels=c("Bicoordinate",
                            "None",
                            "Tetracoordinate",
                            "Tricoordinate"))
}

#' Obtain the stereocenter type for atom.
#'
#' Supported stereo center types are
#' \describe{
#' \item{True}{the atom has constitutionally different neighbors}
#' \item{Para}{the atom resembles a stereo centre but has constitutionally equivalent neighbors (e.g. inositol, decalin). The stereocenter depends on the configuration of one or more stereocenters.}
#' \item{Potential}{the atom can supported stereo chemistry but has not be shown ot be a true or para center}
#' \item{Non}{the atom is not a stereocenter (e.g. methane)}
#' }
#'
#' @param mol A \code{jObjRef} representing an \code{IAtomContainer}
#' @return A factor of length equal in length to the number of atoms indicating the stereocenter type.
#' @seealso \code{\link{get.stereocenters}}, \code{\link{get.element.types}}
#' @author Rajarshi Guha \email{rajarshi.guha@gmail.com}
#' @export
get.stereo.types <- function(mol) {
    if (attr(mol, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
        stop("Must supply an IAtomContainer object")
    
    centers <- .jcall("org/openscience/cdk/stereo/Stereocenters",
                      "Lorg/openscience/cdk/stereo/Stereocenters;",
                      "of",
                      mol)
    stypes <- sapply(0:(get.atom.count(mol)-1), function(i) {
        .jcall(centers,
               "Lorg/openscience/cdk/stereo/Stereocenters$Stereocenter;",
               "stereocenterType", as.integer(i))
    })
    stypes <- sapply(stypes, function(x) x$toString())
    factor(stypes, levels=c("True","Para","Potential","Non"))
}
