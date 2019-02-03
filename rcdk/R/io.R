.packageName <- "rcdk"

#' Write molecules to disk.
#' 
#' This function writes one or more molecules to an SD file on disk,
#' which can be of the single- or multi-molecule variety. In
#' addition, if the molecule has keyed properties, they can also be
#' written out as SD tags.
#' 
#' @details In case individual SD files are desired the
#' \code{together} argument can be set ot \code{FALSE}. In this case, the
#' value of \code{filename} is used as a prefix, to which a numeric
#' identifier and the suffix of ".sdf" is appended. 
#' 
#' @param mols A `list` of `jobjRef` objects representing  `IAtomContainer` objects
#' @param filename The name of the SD file to write. Note that if
#' `together` is `FALSE` then this argument is taken as a prefix for
#' the name of the individual files
#' @param together If `TRUE` then all the molecules are written to a
#' single SD file. If `FALSE` each molecule is written to an
#' individual file
#' @param write.props If `TRUE`, keyed properties are included in the SD file output
#' @seealso \code{\link{load.molecules}}, \code{\link{parse.smiles}}, \code{\link{iload.molecules}}
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
write.molecules <- function(mols, filename, together=TRUE, write.props=FALSE) {
  if (together) {
    value <-.jcall('org/guha/rcdk/util/Misc', 'V', 'writeMoleculesInOneFile',
                   .jarray(mols,
                           contents.class = "org/openscience/cdk/interfaces/IAtomContainer"),
                   as.character(filename), as.integer(ifelse(write.props,1,0)))
  } else {
    value <- .jcall('org/guha/rcdk/util/Misc', 'V', 'writeMolecules',
                    .jarray(mols,
                            contents.class = "org/openscience/cdk/interfaces/IAtomContainer"),
                    as.character(filename), as.integer(ifelse(write.props,1,0)))
  }
}

#' Load molecular structures from disk or URL
#' 
#' The CDK can read a variety of molecular structure formats. This function
#' encapsulates the calls to the CDK API to load a structure given its filename
#' or a URL to a structure file.
#' 
#' @details 
#' Note that this method will load all molecules into memory. For files containing
#' tens of thousands of molecules this may lead to out of memory errors. In such 
#' situations consider using the iterating file readers.
#' 
#' Note that if molecules are read in from formats that do not have rules for
#' handling implicit hydrogens (such as MDL MOL), the molecule will not have
#' implicit or explicit hydrogens. To add explicit hydrogens, make sure that the molecule
#' has been typed (this is `TRUE` by default for this function) and then call 
#' \code{\link{convert.implicit.to.explicit}}. On the other hand for a format 
#' such as SMILES, implicit or explicit hydrogens will be present.

#' @param molfiles A `character` vector of filenames. Note that the full
#' path to the files should be provided. URL's can also be used as
#' paths. In such a case, the URL should start with "http://"
#' @param aromaticity If `TRUE` then aromaticity detection is
#' performed on all loaded molecules. If this fails for a given
#' molecule, then the molecule is set to `NA` in the return list
#' @param typing If `TRUE` then atom typing is
#' performed on all loaded molecules. The assigned types will be CDK
#' internal types. If this fails for a given molecule, then the molecule 
#' is set to `NA` in the return list
#' @param isotopes If `TRUE` then atoms are configured with isotopic masses
#' @param verbose If `TRUE`, output (such as file download progress) will
#' be bountiful
#' @return A `list` of CDK `IAtomContainer` objects, represented as `jobjRef` objects 
#' in R, which can be used in other `rcdk` functions
#' @seealso \code{\link{write.molecules}}, \code{\link{parse.smiles}}, \code{\link{iload.molecules}}
#' @importFrom utils download.file
#' @export
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' \dontrun{
#' mols <- load.molecules(c('mol1.sdf', 'mol2.smi', 
#'                         'https://github.com/rajarshi/cdkr/blob/master/data/set2/dhfr00008.sdf?raw=true'))
#'
#' }
load.molecules <- function(molfiles=NA, aromaticity = TRUE, 
                           typing = TRUE, isotopes = TRUE, 
                           verbose=FALSE) {
  if (any(is.na(molfiles))) {
    stop("Must supply a vector of file names")
  }
  if (length(molfiles) == 0) {
    stop("Must supply a vector of file names")
  }

  for (f in molfiles) {
    if (!file.exists(f) && length(grep('http://', f)) == 0 && length(grep('https://', f)) == 0)
      stop(paste(f, ": Does not exist", sep=''))
  }

  urls <- grep('http|https', molfiles)
  if (length(urls) > 0) { ## download the files and replace the URL's with the temp names
    for (idx in urls) {
      url <- molfiles[idx]
      tmpdest <- tempfile(pattern='xxx')
      status <- try(download.file(url, destfile=tmpdest,
                                  method='curl',
                                  mode='wb', quiet=!verbose),
                    silent=verbose)
      if (class(status) == 'try-error') {
        molfiles[idx] <- NA
        cat("Can't get ", url, '\n')
      } else {
        molfiles[idx] <- tmpdest
      }
    }
  }
  molfiles <- molfiles[ !is.na(molfiles) ]
  farr <- .jarray(molfiles, contents.class = 'S')
  molecules <- .jcall('org/guha/rcdk/util/Misc', '[Lorg/openscience/cdk/interfaces/IAtomContainer;',
                      'loadMolecules', farr, aromaticity, typing, isotopes,
                      check=FALSE)
  exception <- .jgetEx(clear = TRUE)
  if (!is.null(exception)) {
    stop(exception$toString())
  }

  if (is.jnull(molecules)) {
    return(NA)
  }
  if (length(molecules) == 0) {
    return(molecules)
  } else {
    nulls <- which( unlist(lapply(molecules, is.jnull)) )
    if (length(nulls) > 0) molecules[nulls] <- NA
    return(molecules)
  }
}


hasNext <- function(obj, ...) { UseMethod("hasNext") } 
hasNext.iload.molecules <- function(obj, ...) obj$hasNext()

#' Load molecules using an iterator.
#' 
#' The CDK can read a variety of molecular structure formats. Some file
#' formats support multiple molecules in a single file. If read using
#' \code{\link{load.molecules}}, all are read into memory. For very large
#' structure files, this can lead to out of memory errors. Instead it is 
#' recommended to use the iterating version of the loader so that only a
#' single molecule is read at a time.
#' 
#' Note that the iterating loader only supports SDF and SMILES file formats.
#' 
#' @param molfile A string containing the filename to load. Must be a local file
#' @param type Indicates whether the input file is SMILES or SDF. Valid values are
#' `"smi"` or `"sdf"`
#' @param skip If `TRUE`, then the reader will continue reading even when 
#' faced with an invalid molecule. If `FALSE`, the reader will stop at 
#' the fist invalid molecule
#' @param aromaticity If `TRUE` then aromaticity detection is
#' performed on all loaded molecules. If this fails for a given
#' molecule, then the molecule is set to `NA` in the return list
#' @param typing If `TRUE` then atom typing is
#' performed on all loaded molecules. The assigned types will be CDK
#' internal types. If this fails for a given molecule, then the molecule 
#' is set to `NA` in the return list
#' @param isotopes If `TRUE` then atoms are configured with isotopic masses
#' @seealso \code{\link{write.molecules}}, \code{\link{load.molecules}}, \code{\link{parse.smiles}}
#' @export
#' @S3method hasNext iload.molecules 
#' @author Rajarshi Guha (\email{rajarshi.guha@@gmail.com})
#' @examples 
#' \dontrun{
#' moliter <- iload.molecules("big.sdf", type="sdf")
#' while(hasNext(moliter)) {
#' mol <- nextElem(moliter)
#'   print(get.property(mol, "cdk:Title"))
#' }
#' }
iload.molecules<- function(molfile, type = 'smi', 
                           aromaticity = TRUE, typing = TRUE, isotopes = TRUE, 
                           skip=TRUE) {
  
  if (!file.exists(molfile) && length(grep('http://', molfile)) == 0)
    stop(paste(molfile, ": Does not exist", sep=''))
  
  fr <- .jnew("java/io/FileReader", as.character(molfile))
  dcob <- get.chem.object.builder()
  if (type == 'smi') {
    sreader <- .jnew("org/openscience/cdk/io/iterator/IteratingSMILESReader",.jcast(fr, "java/io/Reader"), dcob)
  } else if (type == 'sdf') {
    sreader <- .jnew("org/openscience/cdk/io/iterator/IteratingSDFReader",.jcast(fr, "java/io/Reader"), dcob)
    .jcall(sreader, "V", "setSkip", skip)
  }
  hasNext <- NA
  mol <- NA
  molr <- NA
  
  hasNx <- function() {
    hasNext <<- .jcall(sreader, "Z", "hasNext")
    if (!hasNext) {
      .jcall(sreader, "V", "close")      
      mol <<- NA
    }
    return(hasNext)
  }
  
  nextEl <- function() {
    mol <<- .jcall(sreader, "Ljava/lang/Object;", "next")
    mol <<- .jcast(mol, "org/openscience/cdk/interfaces/IAtomContainer")
    if (aromaticity) do.aromaticity(mol)
    if (typing) do.typing(mol)
    if (isotopes) do.isotopes(mol)
    
    hasNext <<- NA    
    return(mol)
  }
  
  obj <- list(nextElem = nextEl, hasNext = hasNx)
  class(obj) <- c("iload.molecules", "abstractiter", "iter")
  obj
}

