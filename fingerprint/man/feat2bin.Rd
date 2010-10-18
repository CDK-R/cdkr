\name{featvec.to.binaryfp}
\alias{featvec.to.binaryfp}
\title{
Convert a Set of Feature Fingerprints to Binary Fingerprints
}
\description{
Most feature vector style fingerprints (such as circular fingerprints) are
of variable length, with the features being pulled from an implicit (and 
very large) universe of features. 

While it is possible to convert a single feature fingerprint to a binary vector 
via a hashing procedure, one cannot convert the feature representation into 1:1 
binary representation.

However, for a collection of feature fingerprints, one can define a "local" universe
as the union of the features contained in the set of fingerprints. With this definition
each feature can be mapped to a single bit and thus each fingerprint can be converted
to a fixed length, keyed fingerprint.

Since circular fingerprints can lead to a very large binary fingerprint, the initial 
fingerprint is usually folded multiple times to achieve a desired bit density.

Since the fingerprint folding procedure divides a fingerprint into two equal halves and
OR's the two halves together, the starting fingerprint must be of even length. For circular
fingerprints that may not lead to an even-length initial bit string, an extra bit is added 
at the top of the bit string.
}
\usage{
featvec.to.binaryfp(fps, bit.length = 256)
}
\arguments{
    \item{fps}{
    A list of \code{featvec} objects
    }
    \item{bit.length}{The length of the bit string to stop folding at}
}
\value{
A list of objects of class \code{fingerprint}
}
\seealso{\code{\link{fold}}}
\keyword{logic}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
