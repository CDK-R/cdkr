\name{bpdata}
\alias{bpdata}
\docType{data}
\title{
	Boiling Point Data
}
\description{
Structures and associated boiling points for 277 molecules, primarily
alkanes and substituted alkanes.
}
\usage{
bpdata
}
\format{
A \code{data.frame} with two columns:
\tabular{rlll}{
[,1] \tab SMILES \tab character \tab Structure in SMILES format\cr
[,2] \tab BP \tab numeric \tab Boiling point in Kelvin
}
The names of the molecules are used as the row names
}

\references{
Goll, E.S. and Jurs, P.C.; "Prediction of the Normal Boiling Points of
Organic Compounds From Molecular Structures with a Computational
Neural Network Model", \emph{J. Chem. Inf. Comput. Sci.}, 1999,
\emph{39}, 974-983.
}

\keyword{datasets}
