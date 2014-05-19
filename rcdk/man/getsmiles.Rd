\name{get.smiles}
\alias{get.smiles}
\title{
  Get the SMILES for a Molecule
}
\description{
  The function will generate a SMILES representation of an
  IAtomContainer object. The default parameters of the CDK SMILES
  generator are used. This can mean that for large ring systems the
  method may fail. See CDK Javadocs for more information
}
\usage{
get.smiles(molecule, type = 'generic', aromatic = FALSE, atomClasses = FALSE)
}
\arguments{
  \item{molecule}{A Java object of class \code{IAtomContainer}}
  \item{type}{The type of SMILES to output. Possible values are
  \enumerate{
  \item generic - non-canonical SMILES string, different atom ordering produces different SMILES. No isotope or stereochemistry encoded.
  \item unique - canonical SMILES string, different atom ordering produces the same* SMILES. No isotope or stereochemistry encoded.
  \item isomeric - non-canonical SMILES string, different atom ordering produces different SMILES. Isotope and stereochemistry is encoded.
  \item absolute - canonical SMILES string, different atom ordering produces the same SMILES. Isotope and stereochemistry is encoded.
  }}
  \item{aromatic}{If \code{TRUE} aromatic SMILES are generated. The default is to output Kekule form}
  \item{atomClasses}{If \code{TRUE} include atom classes. See \href{http://pele.farmbio.uu.se/nightly/cdk-javadoc-1.5.6.git/org/openscience/cdk/smiles/SmilesGenerator.html}{CDK
  docs} for more details}
}
\value{
  An R character object containing the SMILES
}
\examples{
sp <- get.smiles.parser()
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
mols <- parse.smiles(smiles)
}
\keyword{programming}

\author{Rajarshi Guha (\email{rajarshi.guha@gmail.com})}
