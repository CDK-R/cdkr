\name{bit.spectrum}
\alias{bit.spectrum}
\title{
	Generate a Bit Spectrum from a List of Fingerprints
}
\description{
The idea of comparing datasets using fingerprints was described in
Guha \& Schurer (2008). The idea is that one can summarize the dataset
by counting the frequency of occurrence of each bit position. The
frequency is normalized by the number of fingerprints considered. Thus a
collection of N fingerprints can be converted to a single vector of
numbers highlighting the most frequent bits with respect to a given
dataset. A plot of this vector looks like a traditional spectrum and
hence the name.

The bit spectra for two datasets (assuming that the same types of
fingerprints have been used) allows one to compare the similarity of
the datasets, without having to do a full pairwise similarity
calculation. The difference between the structural features of the
datasets can be quantified by evaluating the distance between the two
bit spectra.
}
\usage{
bit.spectrum(fplist)
}
\arguments{
  \item{fplist}{
        A list structure with each element being an object of class
	\code{fingerprint}. These will can be constructed by hand or
	read from disk via \code{\link{fp.read}}.

	All fingerprints in the list should be of the same length.
    }
}
\value{
A numeric vector of length equal to the size of the fingerprints.
}
\seealso{
    \code{\link{distance}}, \code{\link{fp.read}}
}
\references{
Guha, R.; Schurer, S.; \emph{J. Comp. Aid. Molec. Des.}, \bold{2008},
    \emph{22}, 367-384.
}
\keyword{programming}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
