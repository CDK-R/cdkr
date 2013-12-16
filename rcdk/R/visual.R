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

view.molecule.2d <- function(molecule, ncol = 4, cellx = 200, celly = 200) {
  
  if (class(molecule) != 'character' &&
      class(molecule) != 'list' &&
      class(molecule) != 'jobjRef') {
    stop("Must supply a filename, single molecule object or list of molecule objects")
  }

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
  if (class(molecule) == 'character') {
    molecule <- load.molecules(molecule)
    if (length(molecule) == 1) molecule <- molecule[[1]]
  }

  if (class(molecule) != 'list') { ## single molecule
    if (attr(molecule, "jclass") != 'org/openscience/cdk/interfaces/IAtomContainer') {
      stop("Supplied object should be a Java reference to an IAtomContainer")
    }

    if (is.osx) {
      smi <- get.smiles(molecule)
      cmd <- sprintf('java -cp %s/cont/cdk.jar:%s/cont/rcdk.jar org.guha.rcdk.app.OSXHelper viewMolecule2D "%s" %d %d &', rcdklibs, jarfile, smi, cellx, celly)
      return(system(cmd))
    } else {
      v2d <- .jnew("org/guha/rcdk/view/ViewMolecule2D", molecule, as.integer(cellx), as.integer(celly))
      ret <- .jcall(v2d, "V", "draw")
    }
  } else { ## multiple molecules
    array <- .jarray(molecule, contents.class="org/openscience/cdk/interfaces/IAtomContainer")
    v2d <- .jnew("org/guha/rcdk/view/ViewMolecule2DTable", array,
                 as.integer(ncol), as.integer(cellx), as.integer(celly))
  }
}

view.table <- function(molecules, dat, cellx = 200, celly = 200) {
##  stop("Currently disabled")

  if (cellx <= 0 || celly <= 0) {
    stop("Invalid cell width or height specified")
  }

  if (!is.list(molecules)) {
    stop("Must provide a list of molecule objects")
  }

  if (!is.matrix(dat) && !is.data.frame(dat)) {
    stop("datatable must be a matrix or data.frame")
  }

  if (length(molecules) != nrow(dat)) {
    stop("The number of rows in datatable must be the same as the number of molecules")
  }

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
               molecules, carr, xval.arr)
  .jcall(obj, "V", "setCellX", as.integer(cellx))
  .jcall(obj, "V", "setCellY", as.integer(celly))
  .jcall(obj, "V", "display")
}



view.image.2d <- function(molecule, width=200, height=200) {
  if (attr(molecule,"jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("Must supply an IAtomContainer object")
  mi <- .jnew("org/guha/rcdk/view/MoleculeImage", molecule)
  bytes <- .jcall(mi, "[B", "getBytes", as.integer(width), as.integer(height))
  return(readPNG(bytes))
}

copy.image.to.clipboard <-  function(molecule, width=200, height=200) {
  if (Sys.info()[1] == 'Darwin') { ## try the standalone helper
    smi <- get.smiles(molecule)
    jarfile <- system.file(package='rcdk')
    rcdklibs <- system.file(package='rcdklibs')
    cmd <- sprintf('java -cp %s/cont/cdk.jar:%s/cont/rcdk.jar org.guha.rcdk.app.OSXHelper copyToClipboard "%s" %d %d', rcdklibs, jarfile, smi, width, height)
    return(system(cmd))
  }
  if (attr(molecule,"jclass") != "org/openscience/cdk/interfaces/IAtomContainer")
    stop("Must supply an IAtomContainer object")
  .jcall('org/guha/rcdk/view/MoleculeImageToClipboard',
         'V',
         'copyImageToClipboard',
         molecule, as.integer(width), as.integer(height));
}
