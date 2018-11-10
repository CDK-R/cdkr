#' Generate molecular fingerprints
#' 
#' `get.fingerprint` returns a `fingerprint` object representing molecular fingerprint of
#' the input molecule.
#' 
#' @param molecule A \code{jobjRef} object to an \code{IAtomContaine}
#' @param type The type of fingerprint. Possible values are:
#'   \itemize{
#' \item standard - Considers paths of a given length. The default is
#' but can be changed. These are hashed fingerprints, with a
#' default length of 1024
#' \item extended - Similar to the standard type, but takes rings and
#' atomic properties into account into account
#' \item graph - Similar to the standard type by simply considers connectivity
#' \item hybridization - Similar to the standard type, but only consider hybridization state
#' \item maccs - The popular 166 bit MACCS keys described by MDL
#' \item estate - 79 bit fingerprints corresponding to the E-State atom types described by Hall and Kier
#' \item pubchem - 881 bit fingerprints defined by PubChem
#' \item kr - 4860 bit fingerprint defined by Klekota and Roth
#' \item shortestpath - A fingerprint based on the shortest paths between pairs of atoms and takes into account ring systems, charges etc.
#' \item signature - A feature,count type of fingerprint, similar in nature to circular fingerprints, but based on the signature 
#' descriptor
#' \item circular - An implementation of the ECFP6 fingerprint
#' }
#' @param fp.mode The style of fingerprint. Specifying "`bit`" will return a binary fingerprint,
#' "`raw`" returns the the original representation (usually sequence of integers) and 
#' "`count`" returns the fingerprint as a sequence of counts.
#' @param depth The search depth. This argument is ignored for the
#' `pubchem`, `maccs`, `kr` and `estate` fingerprints
#' @param size The final length of the fingerprint. 
#' This argument is ignored for the `pubchem`, `maccs`, `kr`, `signature`, `circular` and 
#' `estate` fingerprints
#' @param verbose Verbose output if \code{TRUE}
#' @return an S4 object of class \code{\link{fingerprint-class}} or \code{\link{featvec-class}}, 
#' which can be manipulated with the fingerprint package.
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' ## get some molecules
#' sp <- get.smiles.parser()
#' smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
#' mols <- parse.smiles(smiles)
#' 
#' ## get a single fingerprint using the standard
#' ## (hashed, path based) fingerprinter
#' fp <- get.fingerprint(mols[[1]])
#' 
#' ## get MACCS keys for all the molecules
#' fps <- lapply(mols, get.fingerprint, type='maccs')
#' 
#' ## get Signature fingerprint
#' ## feature, count fingerprinter
#' fps <- lapply(mols, get.fingerprint, type='signature', fp.mode='raw')
get.fingerprint <- function(molecule, type = 'standard', fp.mode = 'bit', depth=6, size=1024, verbose=FALSE) {
  if (is.null(attr(molecule, 'jclass'))) stop("Must supply an IAtomContainer or something coercable to it")
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    ## try casting it
    molecule <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")
  }

  mode(size) <- 'integer'
  mode(depth) <- 'integer'

  fingerprinter <-
    switch(type,
           standard = .jnew('org/openscience/cdk/fingerprint/Fingerprinter', size, depth),
           extended = .jnew('org/openscience/cdk/fingerprint/ExtendedFingerprinter', size, depth),
           graph = .jnew('org/openscience/cdk/fingerprint/GraphOnlyFingerprinter', size, depth),
           maccs = .jnew('org/openscience/cdk/fingerprint/MACCSFingerprinter'),
           pubchem = .jnew('org/openscience/cdk/fingerprint/PubchemFingerprinter', .get.chem.object.builder()),
           estate = .jnew('org/openscience/cdk/fingerprint/EStateFingerprinter'),
           hybridization = .jnew('org/openscience/cdk/fingerprint/HybridizationFingerprinter', size, depth),
           lingo = .jnew('org/openscience/cdk/fingerprint/LingoFingerprinter', depth),
           kr = .jnew('org/openscience/cdk/fingerprint/KlekotaRothFingerprinter'),
           shortestpath = .jnew('org/openscience/cdk/fingerprint/ShortestPathFingerprinter', size),
           signature = .jnew('org/openscience/cdk/fingerprint/SignatureFingerprinter', depth),
           circular = .jnew('org/openscience/cdk/fingerprint/CircularFingerprinter'),
           )
  if (is.null(fingerprinter)) stop("Invalid fingerprint type specified")

  jfp <- NA
  if (fp.mode == 'bit') {
    jfp <- .jcall(fingerprinter,
                  "Lorg/openscience/cdk/fingerprint/IBitFingerprint;",
                  "getBitFingerprint", molecule, check=FALSE)
  } else if (fp.mode == 'raw') {
    jfp <- .jcall(fingerprinter,
                  "Ljava/util/Map;",
                  "getRawFingerprint", molecule, check=FALSE)
  } else if (fp.mode == 'count') {
    jfp <- .jcall(fingerprinter,
                  "Lorg/openscience/cdk/fingerprint/ICountFingerprint;",
                  "getCountFingerprint", molecule, check=FALSE)    
  }
  
  e <- .jgetEx()
  if (.jcheck(silent=TRUE)) {
    if (verbose) print(e)
    return(NULL)
  }

  moltitle <- get.property(molecule, 'Title')
  if (is.na(moltitle)) moltitle <- ''

  if (fp.mode == 'bit') {
    bitset <- .jcall(jfp, "Ljava/util/BitSet;", "asBitSet")
    
    if (type == 'maccs') nbit <- 166
    else if (type == 'estate') nbit <- 79
    else if (type == 'pubchem') nbit <- 881
    else if (type == 'kr') nbit <- 4860
    else nbit <- size
    
    bitset <- .jcall(bitset, "S", "toString")
    s <- gsub('[{}]','', bitset)
    s <- strsplit(s, split=',')[[1]]
    return(new("fingerprint", nbit=nbit, bits=as.numeric(s)+1, provider="CDK", name=moltitle))
  } else if (fp.mode == 'raw') {
    keySet <- .jcall(jfp, "Ljava/util/Set;", method="keySet")
    size <- .jcall(jfp, "I", method="size")
    if (size == 0) return(new('featvec', provider='CDK', name=moltitle))
    keyIter <- .jcall(keySet, "Ljava/util/Iterator;", method="iterator")
    keys <- list()
    for (i in 1:size) {
      keys[[i]] <- J(keyIter, "next")
    }

    values <- list()
    for (i in 1:length(keys)) {
      tmp <- .jcall(jfp, "Ljava/lang/Object;", "get", .jcast(new(J("java/lang/String"),keys[[i]]),"java/lang/Object") )
      values[[i]] <- .jsimplify(tmp)
    }
    ## now make our features and create the featvec fp
    if (length(keys) != length(values))
      stop("Feature length did not match count length. This is a problem")
    features <- lapply(1:length(keys), function(i) new("feature", feature=keys[[i]], count=as.integer(values[[i]])))
    return(new("featvec", features=features, provider="CDK", name=moltitle))
  } else if (fp.mode == 'count') {
    fpsize <- .jcall(jfp, "J", "size")
    nbin <- .jcall(jfp, "I", "numOfPopulatedbins")
    ## get hash values
    hvals <- sapply(0:(nbin-1), function(i) .jcall(jfp, "I", "getHash", as.integer(i)) )
    cvals <- sapply(0:(nbin-1), function(i) .jcall(jfp, "I", "getCount", as.integer(i)) )
    features <- lapply(1:length(hvals), function(i) new("feature", feature=as.character(hvals[i]), count=as.integer(cvals[i])))
    return(new("featvec", features=features, provider="CDK", name=moltitle))
  }
}
