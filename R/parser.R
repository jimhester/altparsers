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

#' Alternative parser for R code with identations
#' @inheritParams base::parse
#' @rdname py_parse
#' @export
py_parse_text <- function(text) {
  indents <- sub("^([[:space:]]*).*", "\\1", text)
  len <- nchar(indents)

  prev_len <- c(NA, len[seq_len(length(len) - 1)])

  open_locs <- which(len > prev_len)
  close_locs <- which(len < prev_len)

  # Append open braces to open_locs, append close braces to previous line for close_locs

  text[open_locs - 1] <- paste(text[open_locs - 1], "{")

  text[close_locs - 1] <- paste(text[close_locs - 1], "}")

  last_len <- len[length(len)]
  if (last_len > 0) {
    text <- c(text, rep("}", last_len / 2))
  }


  parse(text = text, keep.source = FALSE)
}

#' @rdname py_parse
#' @export
py_parse_file <- function(file) {
  text <- readLines(file)
  py_parse_text(text)
}

.onLoad <- function(libname, pkgname) {
  src(system.file(package = "altparsers", "r2"), parser = tidy_parse_file, package = "altparsers")
}
