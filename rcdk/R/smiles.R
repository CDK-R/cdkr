#' Generate flag for customizing SMILES generation.
#'
#' The CDK supports a variety of customizations for SMILES generation including
#' the use of lower case symbols for aromatic compounds to the use of the ChemAxon
#' CxSiles format. Each 'flavor' is represented by an integer and multiple
#' customizations are bitwise OR'ed. This method accepts the names of one or
#' more customizations and returns the bitwise OR of them. See \href{https://cdk.github.io/cdk/2.0/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html}{CDK documentation} for the list of flavors and what they mean.
#'
#' @param flavors A character vector of flavors. The default is \code{Generic}. Possible values are
#' * Absolute
#' * AtomAtomMap
#' * AtomicMass 
#' * AtomicMassStrict
#' * Canonical
#' * Cx2dCoordinates
#' * Cx3dCoordinates
#' * CxAtomLabel
#' * CxAtomValue
#' * CxCoordinates
#' * CxFragmentGroup
#' * CxMulticenter
#' * CxPolymer
#' * CxRadical
#' * CxSmiles
#' * CxSmilesWithCoords
#' * Default
#' * Generic
#' * InChILabelling
#' * Isomeric
#' * Stereo
#' * StereoCisTrans
#' * StereoExTetrahedral
#' * StereoTetrahedral
#' * Unique
#' * UniversalSmiles
#' * UseAromaticSymbols
#' @md
#' @return A numeric representign the bitwise OR of the specified flavors
#' @seealso \code{\link{get.smiles}}
#' @references \href{https://cdk.github.io/cdk/2.0/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html}{CDK documentation}
#' @examples
#' m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
#' get.smiles(m)
#' get.smiles(m, smiles.flavor(c('Generic','UseAromaticSymbols'))
#'
#' @author Rajarshi Guha \email{rajarshi.guha@@gmail.com}
smiles.flavors <- function(flavors = c('Generic')) {
    valid.flavors <- c('Absolute',
                       'AtomAtomMap',  
                       'AtomicMass',   
                       'AtomicMassStrict',
                       'Canonical',
                       'Cx2dCoordinates',
                       'Cx3dCoordinates',
                       'CxAtomLabel',  
                       'CxAtomValue',  
                       'CxCoordinates',
                       'CxFragmentGroup',
                       'CxMulticenter',
                       'CxPolymer',
                       'CxRadical',
                       'CxSmiles',
                       'CxSmilesWithCoords',
                       'Default',
                       'Generic',
                       'InChILabelling',
                       'Isomeric',
                       'Stereo',
                       'StereoCisTrans',
                       'StereoExTetrahedral',
                       'StereoTetrahedral',
                       'Unique',
                       'UniversalSmiles',
                       'UseAromaticSymbols')
    if (any(is.na(match(flavors, valid.flavors)))) {
        stop("Invalid flavor specified")
    }
    vals <- sapply(flavors, function(x) {
        .jfield('org.openscience.cdk.smiles.SmiFlavor', 'I', x)
    })
    Reduce(bitwOr, vals, 0)
}

get.smiles <- function(molecule, flavor = smiles.flavors(c('Generic')), smigen = NULL) {
    if (is.null(smigen))
        smigen <- .jnew("org/openscience/cdk/smiles/SmilesGenerator", flavor)
    return(.jcall(smigen, 'S', 'create', molecule))
}

get.smiles.parser <- function() {
    dcob <- .get.chem.object.builder()
    .jnew("org/openscience/cdk/smiles/SmilesParser", dcob)
}

parse.smiles <- function(smiles, kekulise=TRUE) {
    if (!is.character(smiles)) {
        stop("Must supply a character vector of SMILES strings")
    }
    parser <- get.smiles.parser()
    .jcall(parser, "V", "kekulise", kekulise)
    returnValue <- sapply(smiles, 
                          function(x) {
                              mol <- tryCatch(
                              {
                                  .jcall(parser, "Lorg/openscience/cdk/interfaces/IAtomContainer;", "parseSmiles", x)
                              }, error = function(e) {
                                  return(NULL)
                              }
                              )
                              if (is.null(mol)){
                                  return(NULL)
                              } else {
                                  return(.jcast(mol, "org/openscience/cdk/interfaces/IAtomContainer"))
                              }
                          })
    return(returnValue)
}
