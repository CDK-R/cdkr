.packageName <- "rcdk"

## draw.molecule <- function(molecule = NA) {
##   if (is.na(molecule)) {
##     editor <- .jnew("org/guha/rcdk/draw/Get2DStructureFromJCP")
##   } else {
##     if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
##       stop("Supplied object should be a Java reference to an IAtomContainer")
##     }
##     editor <- .jnew("org/guha/rcdk/draw/Get2DStructureFromJCP", molecule)
##   }
##   .jcall(editor, "V", "showWindow")
##   molecule <- .jcall(editor, "[Lorg/openscience/cdk/interfaces/IAtomContainer;", "getMolecules")
##   return(molecule)
## }

## script should be a valid Jmol script string
## view.molecule.3d <- function(molecule, ncol = 4, cellx = 200, celly = 200, script = NA) {

##   if (class(molecule) != 'character' &&
##       class(molecule) != 'list' &&
##       class(molecule) != 'jobjRef') {
##     stop("Must supply a filename, single molecule object or list of molecule objects")
##   }

##   if (class(molecule) == 'character') {
##     molecule <- load.molecules(molecule)
##     if (length(molecule) == 1) molecule <- molecule[[1]]
##   }

##   if (class(molecule) != 'list') { ## single molecule
##     if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
##       stop("Supplied object should be a Java reference to an IAtomContainer")
##     }
##     viewer <- .jnew("org/guha/rcdk/view/ViewMolecule3D", molecule)
##     .jcall(viewer, 'V', 'show')
##     if (!is.na(script)) {
##       .jcall(viewer, "V", "setScript", script)
##     }
##   } else { ## script is not run for the grid case
##     array <- .jarray(molecule, contents.class="org/openscience/cdk/interfaces/IAtomContainer")
##     v3d <- .jnew("org/guha/rcdk/view/ViewMolecule3DTable", array,
##                  as.integer(ncol), as.integer(cellx), as.integer(celly))
##     .jcall(v3d, 'V', 'show')    
##   }
## }

#' get.depictor
#' 
#' return an RcdkDepictor.
#' 
#' @param width Default. \code{200}
#' @param height Default. \code{200}
#' @param zoom Default. \code{1.3}
#' @param style Default. \code{cow}
#' @param annotate Default. \code{off}
#' @param abbr Default. \code{on}
#' @param suppressh Default. \code{TRUE}
#' @param showTitle Default. \code{FALSE}
#' @param smaLimit Default. \code{100}
#' @param sma Default. \code{NULL}
#' @param fillToFit Defailt. \code{FALSE}
#' 
#' @export
#' 
get.depictor <- function(width = 200, height = 200, zoom = 1.3, style = "cow", annotate = "off", abbr = "on",
                         suppressh = TRUE, showTitle = FALSE, smaLimit = 100, sma = NULL, fillToFit = FALSE) {
  if (is.null(sma)) sma <- ""
  return(.jnew("org/guha/rcdk/view/RcdkDepictor",
               as.integer(width),
               as.integer(height),
               as.double(zoom),
               as.character(style),
               as.character(annotate),
               as.character(abbr),
               as.logical(suppressh),
               as.logical(showTitle),
               as.integer(smaLimit),
               as.character(sma),
               as.logical(fillToFit)))
}

#' view.molecule.2d
#' 
#' Create a 2D depiction of a molecule. If there are more than
#' one molecules supplied, return a grid woth \code{ncol} columns,.
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param ncol Default \code{4}
#' @param width Default \code{200}
#' @param height Default \code{200}
#' @param depictor Default \code{NULL}
#' 
#' @importFrom utils write.table
#' @export 
view.molecule.2d <- function(molecule, ncol = 4, width = 200, height = 200, depictor = NULL) {
  
  if (!class(molecule) %in% c('character', 'list', 'jobjRef')) {
    stop("Must supply a filename, single molecule object or list of molecule objects")
  }

  if (is.null(depictor))
    depictor <- get.depictor()
  
  ## in case we're on OS X we need to prep some stuff
  ## so we can shell out 
  is.osx <- Sys.info()[1] == 'Darwin'
  jarfile <- NULL
  rcdklibs <- NULL
  if (is.osx) { 
    jarfile <- system.file(package='rcdk')
    rcdklibs <- system.file(package='rcdklibs')
  }

  ## if we got a file name, lets load all the molecules
  if (is(molecule, 'character')) {
    molecule <- load.molecules(molecule)
    if (length(molecule) == 1) molecule <- molecule[[1]]
  }

  if (!is(molecule, 'list')) { ## single molecule
    if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
      stop("Supplied object should be a Java reference to an IAtomContainer")
    }

    if (is.osx) {
      smi <- get.smiles(molecule)
      if (depictor$getSma() == "")
        sma = "\"\""
      else
        sma = depictor$getSma()

      cmd <- sprintf('java -cp \"%s/cont/*:%s/cont/rcdk.jar\" org.guha.rcdk.app.OSXHelper viewMolecule2D "%s" %d %d %f %s %s %s %s %s %d "%s" %d &', rcdklibs, jarfile, smi,
                     depictor$getWidth(), depictor$getHeight(),
                     depictor$getZoom(), depictor$getStyle(), depictor$getAnnotate(),
                     depictor$getAbbr(), depictor$isSuppressh(), depictor$isShowTitle(),
                     depictor$getSmaLimit(), sma, depictor$getFillToFit())
      return(system(cmd))
    } else {
      v2d <- .jnew("org/guha/rcdk/view/ViewMolecule2D", molecule, as.integer(width), as.integer(height), depictor)
      ret <- .jcall(v2d, "V", "draw")
    }
  } else { ## multiple molecules
    if (is.osx) {
      ## write out mols as a temp smi file
      smi <- sapply(molecule, get.smiles, flavor = smiles.flavors(c('Isomeric')))
      titles <- sapply(molecule, get.title)
      tmp <- data.frame(smi, titles)
      tf <- tempfile(pattern='rcdkv-', fileext='.smi')
      write.table(tmp, file=tf, sep='\t', row.names=FALSE, col.names=FALSE, quote=FALSE)

      if (depictor$getSma() == "") {
        sma = "\"\""
      } else {
        sma = depictor$getSma()
      }
      cmd <- sprintf('java -cp \"%s/cont/*:%s/cont/rcdk.jar\" org.guha.rcdk.app.OSXHelper viewMolecule2Dtable "%s" %d %d %f %s %s %s %s %s %d "%s" %d %d &',
                     rcdklibs, jarfile, tf,
                     depictor$getWidth(), depictor$getHeight(),
                     depictor$getZoom(), depictor$getStyle(), depictor$getAnnotate(),
                     depictor$getAbbr(), depictor$isSuppressh(), depictor$isShowTitle(),
                     depictor$getSmaLimit(), sma, depictor$getFillToFit(),
                     ncol)
      return(system(cmd))
    } else {
      array <- .jarray(molecule, contents.class="org/openscience/cdk/interfaces/IAtomContainer")
      v2d <- .jnew("org/guha/rcdk/view/ViewMolecule2DTable", array,
                   as.integer(ncol), depictor)
    }
  }
}

#' view.table
#' 
#' Create a tabular view of a set of molecules (in 2D) and associated data columns
#' 
#' @param molecules A list of molecule objects (`jobjRef` representing an `IAtomContainer`)
#' @param dat The \code{data.frame} associated with the molecules, one per row
#' @param depictor Default \code{NULL}
#' 
#' @importFrom utils write.table
#' @export 
view.table <- function(molecules, dat, depictor = NULL) {

  if (!is.list(molecules)) {
    stop("Must provide a list of molecule objects")
  }

  if (!is.matrix(dat) && !is.data.frame(dat)) {
    stop("datatable must be a matrix or data.frame")
  }

  if (length(molecules) != nrow(dat)) {
    stop("The number of rows in datatable must be the same as the number of molecules")
  }

  if (is.null(depictor))
    depictor <- get.depictor()
  
  if (is.null(names(dat))) cnames <- c('Molecule', paste('V',1:ncol(dat)), sep='')
  else cnames <- c('Molecule', names(dat))

  ## we need to convert the R vectors to Java arrays
  ## and the datatable data.frame to an Object[][]
  molecules <- .jarray(molecules, "org/openscience/cdk/interfaces/IAtomContainer")
  carr <- .jarray(cnames)

  rows <- list()
  for (i in 1:nrow(dat)) {
    row <- list()
    
    ## for a given row we have to construct a Object[] and add
    ## it to our list
    for (j in 1:ncol(dat)) {
      if (is.numeric(dat[i,j])) {
        row[j] <- .jnew("java/lang/Double", dat[i,j])
      }
      else if (is.character(dat[i,j]) || is.factor(dat[i,j]) || is.logical(dat[i,j])) {
        row[j] <- .jnew("java/lang/String", as.character(dat[i,j]))
      }
    }
    rows[i] <- .jarray(row, "java/lang/Object")
  }

  ## now make our object table
  xval.arr <- .jarray(rows, "[Ljava/lang/Object;")
  obj <- .jnew("org/guha/rcdk/view/ViewMolecule2DDataTable",
               molecules, carr, xval.arr, depictor)
  .jcall(obj, "V", "display")
}


#' view.image.2d
#' 
#' @param molecule The molecule to display Should be a `jobjRef` representing an `IAtomContainer`
#' @param depictor Default \code{NULL}
#' 
#' @export
view.image.2d <- function(molecule, depictor = NULL) {
  if (is.null(depictor))
    depictor <- get.depictor()
  if (attr(molecule,"jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("Must supply an IAtomContainer object")
  mi <- .jnew("org/guha/rcdk/view/MoleculeImage", molecule, depictor)
  bytes <- .jcall(mi, "[B", "getBytes", as.integer(depictor$getWidth()), as.integer(depictor$getHeight()), "png")
  return(readPNG(bytes))
}

#' copy.image.to.clipboard
#' 
#' generate an image and make it available to the system
#' clipboard.
#' 
#' @param molecule The molecule to query. Should be a `jobjRef` representing an `IAtomContainer`
#' @param depictor Optional. Default \code{NULL}. Depictor from \code{get.depictor}
#' @export
copy.image.to.clipboard <-  function(molecule, depictor = NULL) {
  if (is.null(depictor))
    depictor <- get.depictor()

  if (Sys.info()[1] == 'Darwin') { ## try the standalone helper
    smi <- get.smiles(molecule)
    jarfile <- system.file(package='rcdk')
    rcdklibs <- system.file(package='rcdklibs')
    if (depictor$getSma() == "") {
      sma = "\"\""
    } else {
      sma = depictor$getSma()
    }
    cmd <- sprintf('java -cp %s/cont/*:%s/cont/rcdk.jar org.guha.rcdk.app.OSXHelper copyToClipboard "%s" %d %d %f %s %s %s %s %s %d %s %d',
                   rcdklibs, jarfile, smi,
                   depictor$getWidth(), depictor$getHeight(),
                   depictor$getZoom(), depictor$getStyle(), depictor$getAnnotate(),
                   depictor$getAbbr(), depictor$isSuppressh(), depictor$isShowTitle(),
                   depictor$getSmaLimit(), sma, depictor$getFillToFit())
    return(system(cmd))
  }
  if (attr(molecule,"jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("Must supply an IAtomContainer object")
  .jcall('org/guha/rcdk/view/MoleculeImageToClipboard',
         'V',
         'copyImageToClipboard',
         molecule, depictor);
}
