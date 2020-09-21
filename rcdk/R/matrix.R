#' Get adjacency matrix for a molecule.
#'
#' The adjacency matrix for a molecule with \eqn{N} non-hydrogen atoms is an
#' \eqn{N \times N} matrix where the element [\eqn{i},\eqn{j}] is set to 1
#' if atoms \eqn{i} and \eqn{j} are connected by a bond, otherwise set to 0.
#'
#' @param mol A \code{jobjRef} object with Java class \code{IAtomContainer}
#' @return A \eqn{N \times N} numeric matrix
#' @author Rajarshi Guha \email{rajarshi.guha@gmail.com}
#' @seealso \code{\link{get.connection.matrix}}
#' @examples
#' m <- parse.smiles("CC=C")[[1]]
#' get.adjacency.matrix(m)
#' @export
get.adjacency.matrix <- function(mol) {
    am <- .jcall('org.openscience.cdk.graph.matrix.AdjacencyMatrix','[[I','getMatrix', mol)
    do.call(rbind, lapply(am, .jevalArray))
}

#' Get connection matrix for a molecule.
#'
#' The connection matrix for a molecule with \eqn{N} non-hydrogen atoms is an
#' \eqn{N \times N} matrix where the element [\eqn{i},\eqn{j}] is set to the 
#' bond order if atoms \eqn{i} and \eqn{j} are connected by a bond, otherwise set to 0.
#'
#' @param mol A \code{jobjRef} object with Java class \code{IAtomContainer}
#' @return A \eqn{N \times N} numeric matrix
#' @author Rajarshi Guha \email{rajarshi.guha@gmail.com}
#' @seealso \code{\link{get.adjacency.matrix}}
#' @examples
#' m <- parse.smiles("CC=C")[[1]]
#' get.connection.matrix(m)
#' @export
get.connection.matrix <- function(mol) {
    cm <- .jcall('org.openscience.cdk.graph.matrix.ConnectionMatrix','[[D','getMatrix', mol)
    do.call(rbind, lapply(cm, .jevalArray))
}
