set.property <- function(molecule, key, value) {
  if (!is.character(key)) {
    stop("The property key must be a character")
  }
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer") &&
      !.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    stop("Must supply an AtomContainer or IAtomContainer object")
  if (.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    atom <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")
  
  if (is.character(value)) {
    value <- .jcall('org/guha/rcdk/util/Misc', 'V', 'setProperty',
                    molecule, as.character(key),
                    .jcast( .jnew("java/lang/String", value), "java/lang/Object"))
  } else if (is.integer(value)) {
    value <-.jcall('org/guha/rcdk/util/Misc', 'V', 'setProperty',
                   molecule, as.character(key), as.integer(value))
  } else if (is.double(value)) {
    value <-.jcall('org/guha/rcdk/util/Misc', 'V', 'setProperty',
                   molecule, as.character(key), as.double(value))
  } else if (class(value) == 'jobjRef') {
    value <-.jcall('org/guha/rcdk/util/Misc', 'V', 'setProperty',
                   molecule, as.character(key),
                   .jcast(value, 'java/lang/Object'))
  }
  
}

get.property <- function(molecule, key) {
  if (is.jnull(molecule)) {
    warning("Molecule object was null")
    return(NA)
  }
  if (!is.character(key)) {
    stop("The property key must be a character")
  }
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer") &&
      !.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    stop("Must supply an AtomContainer or IAtomContainer object")
  if (.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    atom <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")

  value <- .jcall('org/guha/rcdk/util/Misc', 'Ljava/lang/Object;', 'getProperty',
                  molecule, as.character(key), check=FALSE)
  e <- .jgetEx()
  if (.jcheck(silent=TRUE)) {
    return(NA)
  }

  if (is.jnull(value)) return(NA)
  else return(.jsimplify(value))
}

get.properties <- function(molecule) {
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer") &&
      !.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    stop("Must supply an AtomContainer or IAtomContainer object")
  if (.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    atom <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")

  map <- .jcall(molecule, "Ljava/util/Map;", method = "getProperties")
  keySet <- .jcall(map, "Ljava/util/Set;", method="keySet")
  size <- .jcall(map, "I", method="size")
  if (size == 0) return(list())
  keyIter <- .jcall(keySet, "Ljava/util/Iterator;", method="iterator")
  keys <- list()
  for (i in 1:size) {
    ##    keys[[i]] <-.jcall(keyIter, "Ljava/lang/Object;", method="next")
    keys[[i]] <- J(keyIter, "next")
  }

  
  values <- list()
  for (i in 1:length(keys)) {
    values[[i]] <- .jcall(map, "Ljava/lang/Object;", "get", .jcast(new(J("java/lang/String"),keys[[i]]),"java/lang/Object") )
  }

  ret <- list()
  for (i in 1:length(keys)) {
    k <- keys[[i]]
    if (is.jnull(values[[i]])) ret[[k]] <- NA
    else ret[[k]] <- .jsimplify(values[[i]])
  }
  ret
}

remove.property <- function(molecule, key) {
  if (!is.character(key)) {
    stop("The property key must be a character")
  }
  if (!.check.class(molecule, "org/openscience/cdk/interfaces/IAtomContainer") &&
      !.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    stop("Must supply an AtomContainer or IAtomContainer object")
  if (.check.class(molecule, "org/openscience/cdk/AtomContainer"))
    atom <- .jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")

  if (is.na(get.property(molecule, key))) {
    warning("No such key exists")
  } else {
    value <- .jcall('org/guha/rcdk/util/Misc', 'V', 'removeProperty',
                    molecule, as.character(key))
  }
}

