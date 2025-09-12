#' Generate flag for customizing SMILES generation.
#'
#' The CDK supports a variety of customizations for SMILES generation including
#' the use of lower case symbols for aromatic compounds to the use of the ChemAxon
#' \href{https://docs.chemaxon.com/display/docs/formats_chemaxon-extended-smiles-and-smarts-cxsmiles-and-cxsmarts.md}{CxSmiles}
#' format. Each 'flavor' is represented by an integer and multiple
#' customizations are bitwise OR'ed. This method accepts the names of one or
#' more customizations and returns the bitwise OR of them.
#' See \href{https://cdk.github.io/cdk/2.10/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html}{CDK documentation}
#' for the list of flavors and what they mean.
#'
#' @param flavors A character vector of flavors. The default is \code{Generic} 
#' (output non-canonical SMILES without stereochemistry, atomic masses). Possible 
#' values are
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
#' @return A numeric representing the bitwise `OR`` of the specified flavors
#' @seealso \code{\link{get.smiles}}
#' @references \href{https://cdk.github.io/cdk/2.10/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html}{CDK documentation}
#' @examples
#' m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
#' get.smiles(m)
#' get.smiles(m, smiles.flavors(c('Generic','UseAromaticSymbols')))
#'
#' m <- parse.smiles("OS(=O)(=O)c1ccc(cc1)C(CC)CC |Sg:n:13:m:ht,Sg:n:11:n:ht|")[[1]]
#' get.smiles(m,flavor = smiles.flavors(c("CxSmiles")))
#' get.smiles(m,flavor = smiles.flavors(c("CxSmiles","UseAromaticSymbols")))
#'
#' @export
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

#' Generate a SMILES representation of a molecule.
#' 
#' The function will generate a SMILES representation of an
#' `IAtomContainer` object. The default parameters of the CDK SMILES
#' generator are used. This can mean that for large ring systems the
#' method may fail. See CDK \href{https://cdk.github.io/cdk/2.10/docs/api/org/openscience/cdk/smiles/SmilesGenerator.html}{Javadocs}
#' for more information
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param flavor The type of SMILES to generate. See \code{\link{smiles.flavors}}. Default is `Generic`
#' SMILES
#' @param smigen A pre-existing SMILES generator object. By default, a new one is created from the specified flavor
#' @return A character string containing the generated SMILES
#' @seealso \code{\link{parse.smiles}}, \code{\link{smiles.flavors}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @references \href{https://cdk.github.io/cdk/2.10/docs/api/org/openscience/cdk/smiles/SmilesGenerator.html}{SmilesGenerator} 
#' @examples 
#' m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
#' get.smiles(m)
#' get.smiles(m, smiles.flavors(c('Generic','UseAromaticSymbols')))
get.smiles <- function(molecule, flavor = smiles.flavors(c('Generic')), smigen = NULL) {
    if (is.null(smigen))
        smigen <- .jnew("org/openscience/cdk/smiles/SmilesGenerator", flavor)
    return(.jcall(smigen, 'S', 'create', molecule))
}

#' Get a SMILES parser object.
#' 
#' This function returns a reference to a SMILES parser
#' object. If you are parsing multiple SMILES strings using multiple
#' calls to \code{\link{parse.smiles}}, it is
#' preferable to create your own parser and supply it to
#' \code{\link{parse.smiles}} rather than forcing that function
#' to instantiate a new parser for each call
#' 
#' @return A `jobjRef` object corresponding to the CDK 
#' \href{https://cdk.github.io/cdk/2.10/docs/api/org/openscience/cdk/smiles/SmilesParser.html}{SmilesParser} class
#' @seealso \code{\link{get.smiles}}, \code{\link{parse.smiles}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.smiles.parser <- function() {
    .jnew("org/openscience/cdk/smiles/SmilesParser", get.chem.object.builder())
}

#' Parse SMILES strings into molecule objects.
#' 
#' This function parses a vector of SMILES strings to generate a list of
#' `IAtomContainer` objects. Note that the resultant molecule will
#' not have any 2D or 3D coordinates.
#' Note that the molecules obtained from this method will not have any
#' aromaticity perception (unless aromatic symbols are encountered, in which 
#' case the relevant atoms are automatically set to aromatic), atom typing or 
#' isotopic configuration done on them. This is in contrast to the 
#' \code{\link{load.molecules}} method. Thus, you should
#' perform these steps manually on the molecules.
#' @param smiles A single SMILES string or a vector of SMILES strings
#' @param kekulise If set to `FALSE` disables electron checking and
#' allows for parsing of incorrect SMILES. If a SMILES does not parse by default, try
#' setting this to `FALSE` - though the resultant molecule may not have consistent
#' bonding. As an example, `c4ccc2c(cc1=Nc3ncccc3(Cn12))c4` will not be parsed by default
#' because it is missing a nitrogen. With this argument set to `FALSE` it will parse
#' successfully, but this is a hack to handle an incorrect SMILES
#' @param omit.nulls If set to `TRUE`, omits SMILES which were parsed as `NULL`
#' @param smiles.parser A SMILES parser object obtained from \code{\link{get.smiles.parser}}
#' @return A `list` of `jobjRef`s to their corresponding CDK `IAtomContainer` 
#' objects. If a SMILES string could not be parsed and `omit.nulls=TRUE` it 
#' is omited from the output list.
#' @seealso \code{\link{get.smiles}}, \code{\link{parse.smiles}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
parse.smiles <-
  function(smiles,
           kekulise = TRUE,
           omit.nulls = FALSE,
           smiles.parser = NULL) {
    if (!is.character(smiles)) {
      stop("Must supply a character vector of SMILES strings")
    }
    if (!is.null(smiles.parser)) {
      parser <- smiles.parser
    } else {
      parser <- get.smiles.parser()
    }
    .jcall(parser, "V", "kekulise", kekulise)
    returnValue_withnulls <- sapply(smiles,
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
    returnValue_nonulls <- Filter(Negate(is.null), returnValue_withnulls)
    returnValue <- returnValue_withnulls

    if (omit.nulls==TRUE) {
        returnValue <- returnValue_nonulls
    }

    nulls_count <- length(returnValue_withnulls)-length(returnValue_nonulls)

    if (nulls_count > 0) {
        warning(paste(nulls_count)," out of ",paste(length(returnValue_withnulls)),
        " SMILES were not successfully parsed, resulting in NULLs.")
    }
    return(returnValue)
}
