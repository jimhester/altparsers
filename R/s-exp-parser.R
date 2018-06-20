parse_token <- function(word) {
  num <- suppressWarnings(readr::parse_integer(word))
  if (!is.na(num)) {
    word <- num
  } else {
    word <- as.symbol(word)
  }
  word
}

#' Alternative S-expression parser for R code
#' @inheritParams base::parse
#' @rdname sexp_parse
#' @export
sexp_parse_file <- function(file) {
  sexp_parse_text(readLines(file))
}

#' @rdname sexp_parse
#' @export
sexp_parse_text <- function(text) {
   chars <- strsplit(text, "")[[1]]
   parse_call <- function(start) {
     call <- list()
     word = ''
     in_str = FALSE
     for (i in seq(start, length(chars))) {
       char <- chars[[i]]
      if (!in_str && char == '(') {
        return(as.call(append(call, list(parse_call(i + 1)))))
      } else if (char == ')' && !in_str) {
        if (nzchar(word)) {
          call <- append(call, parse_token(word))
          word = ''
        }
        return(as.call(call))
      } else if (char %in% c(' ', '\n', '\t') && !in_str) {
        if (nzchar(word)) {
          call <- append(call, parse_token(word))
          word = ''
        }
      } else if (char == '\"') {
        in_str = !in_str
      } else {
        word <- paste0(word, char)
      }
     }
     return(call)
   }
   as.expression(parse_call(1)[[1]])
}
