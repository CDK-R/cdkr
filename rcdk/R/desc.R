
#' @keywords internal
.get.desc.values <- function(dval, nexpected) {
  if (!inherits(dval, "jobjRef")) {
    if (is.null(dval) || is.na(dval)) return(NA)
  }

  exception <- .jcall(dval, "Ljava/lang/Exception;", "getException")
  if (!is.null(exception)) {
    warning(exception$getMessage())
    return(rep(NA, nexpected))
  }
  
  nval <- numeric()
  if (!inherits(dval,'jobjRef') && is.na(dval)) {
    return(NA)
  }
  
  result <- .jcall(dval, "Lorg/openscience/cdk/qsar/result/IDescriptorResult;", "getValue")
  methods <- .jmethods(result)

  if ("public double org.openscience.cdk.qsar.result.DoubleArrayResult.get(int)" %in% methods) {
    result <- .jcast(result, "org/openscience/cdk/qsar/result/DoubleArrayResult")
    len <- .jcall(result, "I", "length")
    for (i in 1:len) nval[i] <- .jcall(result, "D", "get", as.integer(i-1))
  } else if ("public int org.openscience.cdk.qsar.result.IntegerArrayResult.get(int)" %in% methods) {
    result <- .jcast(result, "org/openscience/cdk/qsar/result/IntegerArrayResult")    
    len <- .jcall(result, "I", "length")
    for (i in 1:len) nval[i] <- .jcall(result, "I", "get", as.integer(i-1))    
  }  else if ("public int org.openscience.cdk.qsar.result.IntegerResult.intValue()" %in% methods) {
    result <- .jcast(result, "org/openscience/cdk/qsar/result/IntegerResult")    
    nval <- .jcall(result, "I", "intValue")
  } else if ("public double org.openscience.cdk.qsar.result.DoubleResult.doubleValue()" %in% methods) {
    result <- .jcast(result, "org/openscience/cdk/qsar/result/DoubleResult")    
    nval <- .jcall(result, "D", "doubleValue")    
  } else if ("public boolean org.openscience.cdk.qsar.result.BooleanResult.booleanValue()" %in% methods) {
    result <- .jcast(result, "org/openscience/cdk/qsar/result/BooleanResult")    
    nval <- .jcall(result, "Z", "booleanValue")    
  }

  return(nval)
}


#' @keywords internal
.get.desc.engine <- function(type = 'molecular') {
  if (!(type %in% c('molecular', 'atomic', 'bond'))) {
    stop('type must bond, molecular or atomic')
  }
  if (type == 'molecular') {
    interface <- J("org.openscience.cdk.qsar.IMolecularDescriptor")
  } else if (type == 'atomic') {
    interface <- J("org.openscience.cdk.qsar.IAtomicDescriptor")    
  } else if (type == 'bond') {
    interface <- J("org.openscience.cdk.qsar.IBondDescriptor")        
  }
  dklass <- interface@jobj
  dcob <- get.chem.object.builder()
  dengine <- .jnew('org/openscience/cdk/qsar/DescriptorEngine', dklass, dcob)
  attr(dengine, 'descType') <- type
  pkg <- c('org.openscience.cdk.qsar.descriptors.atomic',
           'org.openscience.cdk.qsar.descriptors.bond',
           'org.openscience.cdk.qsar.descriptors.molecular')[ type ]
  attr(dengine, 'descPkg') <- pkg
  dengine
}

.get.desc.all.classnames <- function(type = 'molecular') {
  dengine <- .get.desc.engine(type)
  type <- attr(dengine, "descType")
  pkg <- attr(dengine, "descPkg")
  cn <- .jcall(dengine, 'Ljava/util/List;', 'getDescriptorClassNames')
  size <- .jcall(cn, "I", "size")
  cnames <- list()
  for (i in 1:size)
    cnames[[i]] <- .jsimplify(.jcast(.jcall(cn, "Ljava/lang/Object;", "get", as.integer(i-1)), "java/lang/String"))
                                        #cnames <- gsub(paste(pkg, '.', sep='',collapse=''), '',  unlist(cnames))
  unique(unlist(cnames)  )
}

#' Get descriptor class names
#' 
#' @param type A string indicating which class of descriptors to return. Specifying
#' `"all"` will return class names for all molecular descriptors. Options include
#' * topological
#' * geometrical
#' * hybrid
#' * constitutional
#' * protein
#' * electronic
#' @seealso \link{get.atomic.desc.names}
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
get.desc.names <- function(type = "all") {
  if (type == 'all') return(.get.desc.all.classnames())
  if (!(type %in% c('topological', 'geometrical', 'hybrid',
                    'constitutional', 'protein', 'electronic'))) {
    stop("Invalid descriptor category specified")
  }
  ret <- .jcall("org/guha/rcdk/descriptors/DescriptorUtilities", "[Ljava/lang/String;",
                "getDescriptorNamesByCategory", type)
  if ("org.openscience.cdk.qsar.descriptors.molecular.IPMolecularLearningDescriptor" %in% ret) {
    pos <- which(ret == "org.openscience.cdk.qsar.descriptors.molecular.IPMolecularLearningDescriptor")
    return(ret[-pos])
  } else {
    return(ret)
  }
}

#' List available descriptor categories
#' 
#' @return A character vector listing available descriptor categories. This can be 
#' used in \link{get.desc.names}
#' @seealso \link{get.desc.names}
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
get.desc.categories <- function() {
  cats <- .jcall("org/guha/rcdk/descriptors/DescriptorUtilities", "[Ljava/lang/String;",
                 "getDescriptorCategories");
  gsub("Descriptor", "", cats)
}

#' Compute descriptor values for a set of molecules
#' 
#' @param molecules A `list` of molecule objects
#' @param which.desc A character vector listing descriptor class names
#' @param verbose If `TRUE`, verbose output
#' @return A `data.frame` with molecules in the rows and descriptors in the columns. If
#' a descriptor value cannot be computed for a molecule, `NA` is returned.
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
eval.desc <- function(molecules, which.desc, verbose = FALSE) {
  if (class(molecules) != 'list') {
    jclassAttr <- attr(molecules, "jclass")
    if (jclassAttr != "org/openscience/cdk/interfaces/IAtomContainer") {
      stop("Must provide a list of molecule objects or a single molecule object")
    }
    molecules <- list(molecules)
  } else {
    jclassAttr <- lapply(molecules, attr, "jclass")
    if (any(jclassAttr != "org/openscience/cdk/interfaces/IAtomContainer")) {
      stop("molecule must be an IAtomContainer")
    }
  }

  dcob <- get.chem.object.builder()
  
  if (length(which.desc) == 1) {
    desc <- .jnew(which.desc)
    .jcall(desc, "V", "initialise", dcob)
    
    dnames <- .jcall(desc, "[Ljava/lang/String;", "getDescriptorNames")
    dnames <- gsub('-', '.', dnames)
    
    descvals <- lapply(molecules, function(a,b) {
      val <- tryCatch({.jcall(b, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", a)},
                      warning = function(e) return(NA),
                      error = function(e) return(NA))
    }, b=desc)


    vals <- lapply(descvals, .get.desc.values, nexpected = length(dnames))
    vals <- data.frame(do.call('rbind', vals))
    names(vals) <- dnames 
    return(vals)
  } else {
    counter <- 1
    dl <- list()
    dnames <- c()
    for (desc in which.desc) {
      if (verbose) { cat("Processing ", gsub('org.openscience.cdk.qsar.descriptors.molecular.', '', desc)
                         , "\n") }
      desc <- .jnew(desc)
      .jcall(desc, "V", "initialise", dcob)
      
      dnames <- .jcall(desc, "[Ljava/lang/String;", "getDescriptorNames")
      dnames <- gsub('-', '.', dnames)

      descvals <- lapply(molecules, function(a, check) {
        val <- tryCatch({.jcall(desc, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", a, check=check)})
      }, check=FALSE)

      vals <- lapply(descvals, .get.desc.values, nexpected = length(dnames))
      vals <- data.frame(do.call('rbind', vals))

      
      if (length(vals) == 1 && any(is.na(vals))) {

        vals <- as.data.frame(matrix(NA, nrow=1, ncol=length(dnames)))
      }
      
      names(vals) <- dnames
      ## idx <- which(is.na(names(vals)))
      ## if (length(idx) > 0) vals <- vals[,-idx]
      
      dl[[counter]] <- vals
      counter <- counter + 1
    }
    do.call('cbind', dl)
  }
}

#' Get class names for atomic descriptors
#' 
#' @param type A string indicating which class of descriptors to return. Specifying
#' `"all"` will return class names for all molecular descriptors. Options include
#' * topological
#' * geometrical
#' * hybrid
#' * constitutional
#' * protein
#' * electronic
#' @return A character vector containing class names for atomic descriptors
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
get.atomic.desc.names <- function(type = "all") {
  if (type == 'all') return(.get.desc.all.classnames('atomic'))
  return(.jcall("org/guha/rcdk/descriptors/DescriptorUtilities", "[Ljava/lang/String;",
                "getDescriptorNamesByCategory", type))
}

#' Compute descriptors for each atom in a molecule
#' 
#' @param molecule A molecule object
#' @param which.desc A character vector of atomic descriptor class names
#' @param verbose Optional. Default \code{FALSE}. Toggle verbosity.
#' @return A `data.frame` with atoms in the rows and descriptors in the columns
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @seealso \link{get.atomic.desc.names}
eval.atomic.desc <- function(molecule, which.desc, verbose = FALSE) {
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }

  if (length(which.desc) > 1) {
    counter <- 1
    dl <- list()
    for (desc in which.desc) {
      if (verbose) { cat("Processing ", gsub('org.openscience.cdk.qsar.descriptors.atomic.', '', desc)
                         , "\n") }
      desc <- .jnew(desc)
      atoms = get.atoms(molecule)
      descvals <- lapply(atoms, function(a) {
        dval <- .jcall(desc, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", a, molecule, check=FALSE)
        if (!is.null(e<-.jgetEx())) {
          print("Java exception was raised")
          .jclear()
          dval <- NA
        }
        return(dval)
      })
      
      dnames <- NULL
      if (inherits(descvals[[1]], "jobjRef")) {
        dnames <- .jcall(descvals[[1]], "[Ljava/lang/String;", "getNames")
      } else {
        dnames <- gsub('org.openscience.cdk.qsar.descriptors.atomic.', '', desc)
      }
      if (verbose) 
        cat("\t", "computed", length(dnames), "descriptor values\n")
      
      vals <- lapply(descvals, .get.desc.values, nexpected=length(dnames))
      vals <- data.frame(do.call('rbind', vals))
      names(vals) <- dnames
      
      dl[[counter]] <- vals
      counter <- counter + 1
    }
    do.call('cbind', dl)
  }
}

#' Compute TPSA for a molecule
#' @param molecule A molecule object
#' @return A double value representing the TPSA value
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
get.tpsa <- function(molecule) {
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }

  desc <- .jnew("org.openscience.cdk.qsar.descriptors.molecular.TPSADescriptor")
  descval <- .jcall(desc, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", molecule)
  value <- .get.desc.values(descval, 1)
  return(value)
}

#' Compute ALogP for a molecule
#' @param molecule A molecule object
#' @return A double value representing the ALogP value
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.alogp <- function(molecule) {
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }

  desc <- .jnew("org.openscience.cdk.qsar.descriptors.molecular.ALOGPDescriptor")
  descval <- .jcall(desc, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", molecule)
  value <- .get.desc.values(descval, 3)
  return(value[1])
}

#' Compute XLogP for a molecule
#' @param molecule A molecule object
#' @return A double value representing the XLogP value
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @export
get.xlogp <- function(molecule) {
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }

  desc <- .jnew("org.openscience.cdk.qsar.descriptors.molecular.XLogPDescriptor")
  descval <- .jcall(desc, "Lorg/openscience/cdk/qsar/DescriptorValue;", "calculate", molecule)
  value <- .get.desc.values(descval, 3)
  return(value)
}

#' Compute volume of a molecule
#' 
#' This method does not require 3D coordinates. As a result its an 
#' approximation
#' @param molecule A molecule object
#' @return A double value representing the volume
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
get.volume <- function(molecule) {
  if (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
    stop("Must supply an IAtomContainer object")
  }
  return(J("org.openscience.cdk.geometry.volume.VABCVolume", "calculate", molecule))
}
