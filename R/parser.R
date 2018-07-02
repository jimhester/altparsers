#' @importFrom Rcpp sourceCpp
#' @useDynLib altparsers, .registration = TRUE
NULL

#' Alternative parser for R code
#' @inheritParams base::parse
#' @rdname tidy_parse
#' @export
tidy_parse_text <- function(text) {
  .Call("do_parser", as.character(text))
}


#' @rdname tidy_parse
#' @export
tidy_parse_file <- function(file) {
  .Call("do_parser", readLines(file))
}

#' Create lists
#' @export
`[]` <- function(...) list(...)


.onLoad <- function(libname, pkgname) {
  src(system.file(package = "altparsers", "r2"), parser = tidy_parse_file)
}
