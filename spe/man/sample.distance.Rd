\name{sample.max.distance}
\alias{sample.max.distance}
\title{
  Samples the distances in the input dimensions to get the maximum distance
}
\description{
 The maxmium distance in the input dimensions is required to generate a value of
 the neighborhood radius. For datasets with >1000 observations an all pairs calculation
 is prohibitive. Instead probability sampling is used so that two points are randomly chosen
 and their distance is calculated. This is repeated for a user specified number of times
 and the maximum distance obtained is kept track of and returned at the end.
}
\usage{
sample.max.distance( coord,
                     nobs = 0, ndim = 0,
                     samplesize = 1e6)
}
\arguments{
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
\item{samplesize}{
The number of iterations for probability sampling. For a dataset of 6070 observations
there will be 6070x6069/2 pairwise distances. The default value gives a close approximation and runs
fast. If you want a better approximation 1e7 is a good value. YMMV
}
}
\value{
Returns the value of the maxmium distance found as a single number
}
\seealso{\link{spe}}
\keyword{nonparametric}
