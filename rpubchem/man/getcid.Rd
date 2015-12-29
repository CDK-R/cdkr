\name{get.cid}
\alias{get.cid}
\title{
  Get PubChem Compound Information
}
\description{
  The PubChem compound collection stores a variety of information for
  each molecule. These include canonical SMILES, molecular properties,
  substance associations, synonyms etc.

  This function will extract a subset of the molecular property
  information for a single CID.
}
\usage{
get.cid(cid, quiet=TRUE)
}
\arguments{
  \item{cid}{A single numeric CID}
  \item{quiet}{If \code{FALSE}, output is verbose}
}
\value{
  A \code{data.frame} with at least 23 columns including the CID, IUPAC name, InChI and InChI key, canonical SMILES and a variety of molecular descriptors. In addition, a few physical properties  are also included.
}
\details{The method currently queries PubChem via the PUG REST interface. Since the method 
processes a single CID at a time, the user can parallelize processing. However, this is usually 
not recommended, at least in an unrestricted manner.

In addition, since the \code{data.frame} for each CID may have a different set of physical properties, it is recommended to either extract the common set of columns or else use something like \code{bind_rows} from the \code{dplyr} package to get a uniform \code{data.frame} if processing multiple CIDs
}
\examples{
\dontrun{
cids <- c(5282108, 5282148, 91754124)
dat <- lapply(cids, get.cid)
dat <- dplyr::bind_rows(dat)
str(dat)
}
}
\seealso{
  \code{\link{get.assay}},
  \code{\link{get.sid}},
  \code{\link{get.sid.list}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{compound}

