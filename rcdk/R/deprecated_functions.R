################################################################################
#' Deprecated functions in the rcdk package.
#' 
#' These functions are provided for compatibility with older version of
#' the phyloseq package.  They may eventually be completely
#' removed.
#' 
#' @usage deprecated_rcdk_function(x, value, ...)
#' @rdname rcdk-deprecated
#' @name rcdk-deprecated
#' @param x For assignment operators, the object that will undergo a replacement
#'  (object inside parenthesis).
#' @param value For assignment operators, the value to replace with 
#'  (the right side of the assignment).
#' @param ... For functions other than assignment operators, 
#'  parameters to be passed to the modern version of the function (see table).
#' @docType package
#' @export do.typing
#' @aliases deprecated_rcdk_function do.typing
#' @details
#' \tabular{rl}{
#'   \code{do.typing} \tab now a synonym for \code{\link{set.atom.types}}\cr
#' }
#'
deprecated_rcdk_function <- function(x, value, ...){return(NULL)}
do.typing <- function(...){.Deprecated("set.atom.types", package="rcdk");return(set.atom.types(...))}
################################################################################