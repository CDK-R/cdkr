\name{fplogical}
\alias{!}
\alias{|}
\alias{&}
\alias{xor}
\alias{|,fingerprint,fingerprint-method}
\alias{&,fingerprint,fingerprint-method}
\alias{xor,fingerprint,fingerprint-method}
\alias{!,fingerprint-method}
\title{
    Logical Operators for Fingerprints
}
\description{
These functions perform logical operatiosn (AND, OR, NOT, XOR) on the supplied
binary fingerprints. Thus for two fingerprints A and B we have
\describe{
\item{\code{&}}{Logical AND}
\item{\code{|}}{Logical OR}
\item{\code{xor}}{Logical XOR}
\item{\code{!}}{Logical NOT (negation)}
}
}
\arguments{
    \item{e1}{
      An object of class \code{fingerprint}
    }
    \item{e2}{
      An object of class \code{fingerprint}
    }
  }
\value{
A fingerprint object
}
\keyword{logic}
\keyword{methods}
\author{Rajarshi Guha \email{rguha@indiana.edu}}



