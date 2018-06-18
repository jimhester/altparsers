#' @importFrom utils data
#' @import Rcpp 
#' @useDynLib parser, .registration = TRUE
.onLoad <- function( libname, pkgname ){
    # loadRcppModules()
	#loadModule("parser_module", T)
}
