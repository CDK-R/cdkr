\name{cdk.lf, moe.lf, bci.lf}
\alias{cdk.lf}
\alias{moe.lf}
\alias{bci.lf}
\alias{ecfp.lf}
\title{
    Functions to parse lines from fingerprint files
}
\description{
These functions take a single line and parses it to produce 
a vector of integers which represents the position of the 'on' bits in
a fingerprint. This allows the user to use \code{read.fp} with arbitrary fingerprint
files. A new file format can be handled by defining a new line parser function.
Currently the first three functions process fingerprint files obtained from the 
CDK (\url{http://cdk.sourceforge.net}), MOE (\url{http://chemcomp.com})
and BCI (\url{http://www.digitalchemistry.co.uk/}). The last function can be used
for any fingerprint that generates hashed features (such as ECFPs or other 
circular fingerprints). For these cases, it is assumed that features are unsigned 
integers, so string features are not handled
}
\usage{
    cdk.lf(line)
    moe.lf(line)
    bci.lf(line)
    ecfp.lf(line)
}
\arguments{
    \item{line}{
        The line to parse
    }
}
\value{
A list with two componenents - the name associated with the fingerprint (if available)
 and a vector of integers representing bits set to 1 (for the case of the first three 
methods) or a vector of signed integers representing hashed features (characteristic of
 circular fingerprints).
}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\keyword{logic}



