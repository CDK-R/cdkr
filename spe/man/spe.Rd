\name{spe}
\alias{spe}
\title{
  Implements the stochastic proximity embedding algorithm
}
\description{
   Embeds an N dimensional dataset in M dimensions, such that distances
   (or similarities) in the original N dimensions are maintained (as close as
   possible) in the final M dimensions
}
\usage{
spe( coord, rcutpercent = 1, maxdist = 0,
     nobs = 0, ndim = 0, edim,
     lambda0 = 2.0, lambda1 = 0.01,
     nstep = 1e6, ncycle = 100, 
     evalstress=FALSE, sampledist=TRUE, samplesize = 1e6)
}
\arguments{
\item{coord}{
This should be a matrix with number of rows equal to the number of observations
and number of columns equal to the input dimension. A data.frame may also be supplied
and it will be converted to a matrix (so all names will be lost)
}
\item{rcutpercent}{
This is the percentage of the maximum distance (as determined by probability sampling)
that will be used as the neighborhood radius. Setting rcutpercent to a value greater than 1 effectively sets it to 
infinity.
}
\item{maxdist}{
If you have alread calculated a mxaimum distance then you can supply it and 
probability sampling will not be carried out to obtain a maximum distance. The default is
to carry out sampling. By setting maxdist to a non zero value sampling will not be
carried out (even if sampledist=TRUE)
}
\item{nobs}{
The number of observations. If it is not specified nobs will be taken as nrow(coord)
}
\item{ndim}{
The number of input dimensions.  If not specified it will be taken as ncol(coord)
}
\item{edim}{
The number of dimensions to embed in
}
\item{lambda0}{
The starting value of the learning parameter
}
\item{lambda1}{
The ending value of the learning parameter
}
\item{nstep}{
The number of refinement steps
}
\item{ncycle}{
The number of cycles to carry out refinement for
}
\item{evalstress}{
If TRUE the function will evaluate the Sammon stress on the final embedding
}
\item{sampledist}{
If TRUE an approximation to the maximum distance in the input dimensions will
be obtained via probability sampling
}
\item{samplesize}{
The number of iterations for probability sampling. For a dataset of 6070 observations
there will be 6070x6069/2 pairwise distances. The default value gives a close approximation and runs
fast. If you want a bettr approximation 1e7 is a good value. YMMV
}
}
\value{
If evalstress is TRUE it will be a list with two components named x and stress.
x is the matrix of the final embedding and stress is the final stress
}
\examples{
## load the phone dataset
data(phone)

## run SPE, embed$stress should be 0 or very close to it
## You can plot the embedding using the scatterplot3d package
## (This will take a few minutes to run)
embed <- spe(phone, edim=3, evalstress=TRUE)

## evaluate the Sammon stress
stress <- eval.stress(embed$x, phone)

## embed the Swiss Roll dataset in 2D
data(swissroll)
embed <- spe(swissroll, edim=2, evalstress=TRUE)
}
\seealso{\code{\link{eval.stress}}, \code{\link{sample.max.distance}}}
\details{
Efficient determination of rcut is yet to be implemented (using the connected component method). As a result you will have
to determine a value of rcutpercent by trail and error. 
The pivot SPE method (\emph{J. Mol. Graph. Model.}, 2003, \bold{22}, 133-140) is not yet implemented
}
\references{A Self Organizing Principle for Learning Nonlinear Manifolds, \emph{Proc. Nat. Acad. Sci.}, 2002, \bold{99}, 15869-15872
Stochastic Proximity Embedding, \emph{J. Comput. Chem.}, 2003, \bold{24}, 1215-1221 
A Modified Rule for Stochastic Proximity Embedding, \emph{J. Mol. Graph. Model.}, 2003, \bold{22}, 133-140
A Geodesic Framework for Analyzing Molecular Similarities, \emph{J. Chem. Inf. Comput. Sci.}, 2003, \bold{43}, 475-484
}
\author{Rajarshi Guha \email{rajarshi@presidency.com}}
\keyword{nonparametric}
