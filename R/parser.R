#' @importFrom Rcpp sourceCpp
#' @useDynLib altparsers, .registration = TRUE
NULL

#' Alternative parser for R code
#' @inheritParams base::parse
#' @export
parse2 <- function(text) {
  .Call("do_parser", as.character(text))
}

#' Create lists
#' @export
`[]` <- function(...) list(...)
