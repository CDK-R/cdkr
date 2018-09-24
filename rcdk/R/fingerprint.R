get.fingerprint <- function(molecule, type = 'standard', fp.mode = 'bit', depth=6, size=1024,  substructure.pattern=character(), verbose=FALSE) {
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
           substructure = 
               if (length(substructure.pattern) == 0) 
                   # Loads the default group substructures
                   { .jnew('org/openscience/cdk/fingerprint/SubstructureFingerprinter') }
               else
                   # Loads the substructures defined by the user
                   { .jnew('org/openscience/cdk/fingerprint/SubstructureFingerprinter', .jarray(substructure.pattern)) },
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
    else if (type == 'substructure') nbit <- .jcall(fingerprinter, "I", "getSize")
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
