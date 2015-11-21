\name{get.assay}
\alias{get.assay}
\title{
  Get a PubChem Bio-Assay
}
\description{
  PubChem provides access to a number of bio-assays which are generally
  results obtained from High Throughput Screens (HTS). The number of
  observations in a given assay can be as high as 42000. This method
  allows one to obtain the assay data for a given assay ID. Assay ID's
  can be obtained using a text search using the \code{\link{find.assay.id}} function.
}
\details{
  The assay data are obtained for a variety of targets using a variety
  of techniques. As a result though each assay dataset contains a set of
  fixed fields, they can have additional fields.

  If \code{cid} or \code{sid} is not specified the entire bioassay is retrieved. This can 
  be time consuming for primary screening assays. If both arguments are specified, then
  \code{sid} is used in preference to \code{sid}.
}
\usage{
get.assay(aid, cid=NULL, sid=NULL, quiet=TRUE)
}
\arguments{
  \item{aid}{An assay ID}
  \item{cid}{A list of CID's}
  \item{sid}{A list of SID's}
  \item{quiet}{If \code{FALSE} the output is verbose}
}
\value{
  A data frame with the observations in the rows. The number of columns
  varies from assay to assay. Any assay will, however, have the
  following columns:
    \item{PUBCHEM.SID}{PubChem SID}
    \item{PUBCHEM.CID}{PubChem CID}
    \item{PUBCHEM.ACTIVITY.OUTCOME}{Activity outcome}
    \item{PUBCHEM.ACTIVITY.SCORE}{Activity score, higher is more active}
    \item{PUBCHEM.ASSAYDATA.COMMENT}{Test result specific comment}

  The activity outcome field is provided as a numeric but is recoded as
  described in the PubChem documentation. The remaining fields are
  obtained by parsing the description file for the corresponding assay.  

  In addition to the usual attributes for a
  \code{data.frame} object this function adds some extra attributes:
  \itemize{
    \item{description}{A short description of the assay}
    \item{comments}{Comments associated with the assay}
    \item{types}{A named \code{list} where the names are the assay
      specific field names. Each element of the \code{list} is a
      2-element vector containing the description of the field along
      with the units. In case the field is unitless the unit is NA}
  }
}
\seealso{
\code{\link{get.assay.desc}}, \code{\link{find.assay.id}}
}
\keyword{programming}

\author{Rajarshi Guha \email{rajarshi.guha@gmail.com}}
\concept{PubChem}
\concept{pubchem}
\concept{assay data}

