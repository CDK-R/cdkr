\name{eval.stress}
\alias{eval.stress}
\title{
  Evaluates the Sammon stress of an embedding
}
\description{
   Given an N dimensional dataset embedded M dimensions, this function will evaluate
   the Sammon stress of the embedding, via probability sampling
}
\usage{
eval.stress( x, coord,
             ndim = 0, edim = 0, nobs = 0,
             samplesize = 1e6)
}
\arguments{
\item{x}{
The embedded data in matrix form. If present in a data.frame it will be coerced to
a matrix
}
\item{coord}{
The input data in matrix form. If present in a data.frame it will be coerced to
a matrix
}
\item{nobs}{
The number of observations (rows of the input matrix should be the same as the rows of the embedding matrix)
If it is not specified nobs will be taken as nrow(coord)
}
\item{ndim}{
The number of input dimensions. If not specified it will be taken as ncol(coord)
}
\item{edim}{
The number of dimensions to embed in. If not specified it will be taken as ncol(x)
}
\item{samplesize}{
The number of iterations for probability sampling. For a dataset of 6070 observations
there will be 6070x6069/2 pairwise distances. The default value gives a close approximation and runs
fast. If you want a better approximation 1e7 is a good value. YMMV
}
}
\details{
The Sammon stress is given by
\deqn{ S = \sum_{i < j} \frac{ (d_{ij} - r_{ij} )^2 }{r_{ij}} / \sum_{i<j} r_{ij} }
where \eqn{d_{ij}} is the Euclidean distance between two observations in the embedded data
and \eqn{r_{ij}} is the relationship (in this case it is the Euclidean distance but could be 
a similarity value) between the two observations in the input data
}
\value{
Returns the value of the Sammon stress as a single number
}
\seealso{\link{spe}}
\references{Stochastic Proximity Embedding, \emph{J. Comput. Chem.}, 2003, \bold{24}, 1215-1221}
\keyword{nonparametric}
