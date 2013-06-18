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
  information for one or more compound ID's
}
\usage{
get.cid(cid, quiet=TRUE, from.file=FALSE)
}
\arguments{
  \item{cid}{A vector of one or more compound ID's}
  \item{quiet}{If \code{FALSE}, output is verbose}
  \item{from.file}{If \code{TRUE} then the first argument is considered
    to be the name of a file containing the XML data. If \code{FALSE}
    the first argument must be a sequence of compound ID's and the data
    will be downloaded from the PubChem FTP site}
}
\value{
  A \code{data.frame} with 9 columns:
    \item{CID}{The compound ID}
    \item{IUPACName}{The IUPAC name of the compound}
    \item{CanonicalSmiles}{The canonical SMILES for the compound}
    \item{MolecularWeight}{Molecular weight}
    \item{TotalFormalCharge}{The formal charge}    
    \item{MolecularFormula}{The molecular formula}    
    \item{TPSA}{Topological polar surface area}
    \item{HeavyAtomCount}{Heavy atom count}
    \item{FormalCharge}{Total formal charge}
    \item{HydrogenBondDonor}{Hydrogen bond donor count}
    \item{HydrogenBondAcceptor}{Hydrogen bond acceptor count}
}
\details{Processing a large number of compound ID's can take a long
  time. For large numbers of CID's the resultant XML file can be many
  megabytes. This may take a long time to download. After download it
  takes approximate 20 sec to process a 23MB data file.

  It should also be noted that the data files are downloaded using the R
  interface to Curl. In addition, the PubChem servers do not allow very
  large query URL's. This limits the number of compound ID's that can be
  directly pulled of the PubChem servers to about 1000
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

