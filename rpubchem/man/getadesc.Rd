\name{get.assay.desc}
\alias{get.assay.desc}
\title{
  Get An Assay Description
}
\description{
  PubChem stores a number of pieces of information for each
  bio-assay. These include the description of the assay, related
  comments as well as type information (name, units, description) for
  the extra columns in the assay data.

  This method accesses the description information and extracts a subset
  of that available.
}
\usage{
get.assay.desc(aid)
}
\arguments{
  \item{aid}{A valid assay ID. This can be obtained using
    \link{find.assay.id} if not already known}
}
\value{
  A \code{list} object with the following named components
    \item{assay.desc}{A short description of the assay}
    \item{assay.comments}{A \code{list} of comments for the assay}
    \item{types}{A \code{matrix} with 3 columns. The first column is the
      name of the assay specific columns. The second column contains the
      descriptions of each assay specific column. The final column lists
      the units for each of the assay specific columns. In case an assay
      column is unitless, the value of the unit for that column is \code{NA}}
}
\seealso{
\code{\link{find.assay.id}}, \code{\link{get.assay}}
}
\keyword{programming}
\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{bioassay}

