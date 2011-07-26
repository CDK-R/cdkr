\name{fp.sim.matrix}
\alias{fp.sim.matrix}
\title{
  Calculates a Similarity Matrix for a Set of Fingerprints
}
\description{
Given a set of fingerprints, a pairwise similarity can be calculated using the
various distance metrics defined for binary strings. This function calculates
the pairwise similarity matrix for a set of \code{fingerprint} or
\code{featvec} objects supplied in a \code{list} 
structure. Any of the distance metrics provided by \code{\link{distance}} can be used and the 
default is the Tanimoto metric.

Note that if the the Euclidean distance is specified then the resultant matrix is a
distance matrix and not a similarity matrix
}
\usage{
fp.sim.matrix(fplist, fplist2=NULL, method='tanimoto')
}
\arguments{
  \item{fplist}{
        A list structure with each element being an object of class
	\code{fingerprint} or \code{featvec}. These can be constructed by hand or
	read from disk via \code{\link{fp.read}}    
    }
\item{fplist2}{A list structure with each element being an object of class
\code{fingerprint} or \code{featvec}. if \code{NULL} then traditional pairwise 
similarity is calculated with each member in \code{fplist}, otherwise the 
resultant N x M matrix is derived from the similarity between each member of 
\code{fplist} and \code{fplist2}}
    \item{method}{
    The type of distance metric to use. The default is \code{tanimoto}. Partial
    matching is supported.
    }
}
\value{
A matrix with dimensions equal to \code{(length(fplist), length(fplist))} if 
\code{fplist2} is NULL, otherwise \code{(length(fplist), length(fplist2))}
}
\seealso{
    \code{\link{distance}}, \code{\link{fp.read}}
}
\examples{
# make fingerprint objects
fp1 <- new("fingerprint", nbit=6, bits=c(1,2,5,6))
fp2 <- new("fingerprint", nbit=6, bits=c(1,4,5,6))
fp3 <- new("fingerprint", nbit=6, bits=c(2,3,4,5,6))

fp.sim.matrix( list(fp1,fp2,fp3) )
}
\keyword{logic}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
