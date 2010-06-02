\name{distance}
\alias{distance}
\title{
Calculates the Similarity or Dissimilarity Between Two Fingerprints
}
\description{
  A number of distance metrics can be calculated for binary
  fingerprints. Some of these are actually similarity metrics and
  thus represent the reverse of a distance metric.

  The following are distance (dissimilarity) metrics
  \itemize{
    \item Hamming
    \item Mean Hamming
    \item Soergel
    \item Pattern Difference
    \item Variance
    \item Size
    \item Shape
  }

  The following metrics are similarity metrics and so the distance can
  be obtained by subtracting the value fom 1.0
  \itemize{
    \item Tanimoto
    \item Dice
    \item Modified Tanimoto
    \item Simple
    \item Jaccard
    \item Russel-Rao
    \item Rodgers Tanimoto
    \item Cosine
    \item Achiai
    \item Carbo
    \item Baroniurbanibuser
    \item Kulczynski2
  } 

  Finally the method also provides a set of composite and asymmetric
  distance metrics
  \itemize{
    \item Hamann
    \item Yule
    \item Pearson
    \item Dispersion
    \item McConnaughey
    \item Stiles
    \item Simpson
    \item Petke
  }
  The default metric is the Tanimoto coefficient.
}
\usage{
distance(fp1, fp2, method)
}
\arguments{
  \item{fp1}{
    An object of class \code{fingerprint}
  }
  \item{fp2}{
    An object of class \code{fingerprint}
  }
  \item{method}{
    The type of distance metric desired. Partial matching is
    supported and the deault is \code{tanimoto}. Alternative values are
    \itemize{
      \item \code{euclidean} 
      \item \code{hamming}
      \item \code{meanHamming}
      \item \code{soergel}
      \item \code{patternDifference}
      \item \code{variance}
      \item \code{size}
      \item \code{shape}

      \item \code{jaccard}
      \item \code{dice}
      \item \code{mt}
      \item \code{simple}
      \item \code{russelrao}
      \item \code{rodgerstanimoto}
      \item \code{cosine}
      \item \code{achiai}
      \item \code{carbo}
      \item \code{baroniurbanibuser}
      \item \code{kulczynski2}

      \item \code{hamann}
      \item \code{yule}
      \item \code{pearson}
      \item \code{mcconnaughey}
      \item \code{stiles}

      \item \code{simpson}
      \item \code{petke}

    }

  }
}
\value{
  Numeric value representing the distance in the specified metric between the
  supplied fingerprint objects
}
\examples{
# make a 2 fingerprint vectors
fp1 <- new("fingerprint", nbit=6, bits=c(1,2,5,6))
fp2 <- new("fingerprint", nbit=6, bits=c(1,2,5,6))

# calculate the tanimoto coefficient
distance(fp1,fp2) # should be 1

# Invert the second fingerprint
fp3 <- !fp2

distance(fp1,fp3) # should be 0
}

\references{Fligner, M.A.; Verducci, J.S.; Blower, P.E.;
  A Modification of the Jaccard-Tanimoto Similarity Index for
  Diverse Selection of Chemical Compounds Using Binary Strings,
  \emph{Technometrics}, 2002, \emph{44}(2), 110-119

  Monve, V.; Introduction to Similarity Searching in
  Chemistry, \emph{MATCH - Comm. Math. Comp. Chem.}, 2004, \emph{51}, 7-38
}

\keyword{logic}
\author{Rajarshi Guha \email{rguha@indiana.edu}}
