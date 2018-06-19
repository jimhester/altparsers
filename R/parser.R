#' @importFrom Rcpp sourceCpp
#' @useDynLib parser, .registration = TRUE
NULL

#' Alternative parser for R code
#' @inheritParams base::parse
#' @export
parse2 <- function(text) {
  .Call("do_parser", as.character(text))
}
