#' Set a property value of the molecule.
#' 
#' This function sets the value of a keyed property on the molecule. 
#' Properties enable us to associate arbitrary pieces of data with a 
#' molecule. Such data can be text, numeric or a Java object 
#' (represented as a `jobjRef`).
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param key The property key as a character string
#' @param value The value of the property. This can be a character, numeric or 
#' `jobjRef` R object
#' @seealso \code{\link{get.property}}, \code{\link{get.properties}}, \code{\link{remove.property}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples
#' mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
#' set.property(mol, 'prop1', 23.45)
#' set.property(mol, 'prop2', 'inactive')
#' get.property(mol, 'prop1')
#' 
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

#' Get a property value of the molecule.
#' 
#' This function retrieves the value of a keyed property that has
#' previously been set on the molecule. Properties enable us to 
#' associate arbitrary pieces of data with a molecule. Such data
#' can be text, numeric or a Java object (represented as a `jobjRef`).
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param key The property key as a character string
#' @return The value of the property. If there is no property with the specified key, `NA` is returned
#' @seealso \code{\link{set.property}}, \code{\link{get.properties}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
#' set.property(mol, 'prop1', 23.45)
#' set.property(mol, 'prop2', 'inactive')
#' get.property(mol, 'prop1')
get.property <- function(molecule, key) {
  if (is.jnull(molecule)) {
    warning("Molecule object was null")
    return(NA)
  }
  if (is.null(key) || is.na(key) || !is.character(key)) {
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

#' Get all properties associated with a molecule.
#' 
#' In this context a property is a value associated with a key and stored
#' with the molecule. This methd returns a list of all the properties of 
#' a molecule. The names of the list are set to the property names.
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @return A named `list` with the property values. Element names are the keys 
#' for each property. If no properties have been defined, an empty list.
#' @seealso \code{\link{set.property}}, \code{\link{get.property}}, \code{\link{remove.property}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
#' set.property(mol, 'prop1', 23.45)
#' set.property(mol, 'prop2', 'inactive')
#' get.properties(mol)
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
    the.value <- .jcall(map, "Ljava/lang/Object;", "get", .jcast(new(J("java/lang/String"),keys[[i]]),"java/lang/Object") )
    if (is.jnull(the.value)) values[[i]] <- NA
    else values[[i]] <- the.value
  }
  
  ret <- list()
  for (i in 1:length(keys)) {
    k <- keys[[i]]
    if ('jobjRef' %in% class(values[[i]])) ret[[k]] <- .jsimplify(values[[i]])
    else if (is.na(values[[i]])) ret[[k]] <- NA
    else ret[[k]] <- values[[i]]
  }
  ret
}

#' Remove a property associated with a molecule.
#' 
#' In this context a property is a value associated with a key and stored
#' with the molecule. This methd will remove the property defined by the key.
#' If there is such key, a warning is raised.
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param key The property key as a character string
#' @seealso \code{\link{set.property}}, \code{\link{get.property}}, \code{\link{get.properties}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
#' set.property(mol, 'prop1', 23.45)
#' set.property(mol, 'prop2', 'inactive')
#' get.properties(mol)
#' remove.property(mol, 'prop2')
#' get.properties(mol)
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

