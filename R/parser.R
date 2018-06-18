#' @importFrom Rcpp sourceCpp
#' @useDynLib parser, .registration = TRUE
#' @export
parse2 <- function(text) {
  .Call("do_parser", text)
}
