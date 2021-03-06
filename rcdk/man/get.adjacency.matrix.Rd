% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/matrix.R
\name{get.adjacency.matrix}
\alias{get.adjacency.matrix}
\title{Get adjacency matrix for a molecule.}
\usage{
get.adjacency.matrix(mol)
}
\arguments{
\item{mol}{A \code{jobjRef} object with Java class \code{IAtomContainer}}
}
\value{
A \eqn{N \times N} numeric matrix
}
\description{
The adjacency matrix for a molecule with \eqn{N} non-hydrogen atoms is an
\eqn{N \times N} matrix where the element [\eqn{i},\eqn{j}] is set to 1
if atoms \eqn{i} and \eqn{j} are connected by a bond, otherwise set to 0.
}
\examples{
m <- parse.smiles("CC=C")[[1]]
get.adjacency.matrix(m)
}
\seealso{
\code{\link{get.connection.matrix}}
}
\author{
Rajarshi Guha \email{rajarshi.guha@gmail.com}
}
