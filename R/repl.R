read_line <- function(prompt) {
  cat(prompt)
  flush(stdout())
  readLines(n = 1)
}

handle_parse_error <- function(e) {
  msg <- conditionMessage(e)
  cat(msg)
}

handle_value <- function(e) {
  if (e$visible) {
    print(e$value)
  }
}

handle_error <- function(e) {
  cat("Error in ", deparse(conditionCall(e)), ":", conditionMessage(e), "\n")
}

#' Launch a Read Eval Print Loop
#'
#' @param parser the parsing function to use
#' @param envir environment to perform evaluations in
#' @export
repl <- function(parser = parse_text, envir = parent.frame()) {
  prompt <- "> "
  cmd <- character()
  repeat {

  # Read
    cmd <- c(cmd, read_line(prompt))
    ans <- tryCatch(parser(cmd), error = function(e) e)
    has_error <- inherits(ans, "error")

    if (has_error) {
      incomplete_parse <- grepl("unexpected end of input", ans$message)

      if (incomplete_parse) {
        prompt <- "+ "
      } else {
        handle_parse_error(ans)
        prompt <- "> "
        cmd <- character()
      }

      next
    }
    if (is_quit(ans)) {
      return(invisible())
    }

  # Eval
    for (e in ans) {
      e <- tryCatch(withVisible(eval(e, envir = envir)), error = function(e) e)

  # Print
      if (inherits(e, "error")) {
        handle_error(e)
      } else {
        handle_value(e)
      }
    }

    prompt <- "> "
    cmd <- character()
  }
}

is_quit <- function(e) {
  (!inherits(e, "error") &&
    length(e) == 1 &&
    is.call(e[[1]]) &&
    as.character(e[[1]][[1]]) == "q")
}

#' Test
#' @name a
#' @examples
#' a(mtcars, hp > 10)
#' @export
NULL

#' Alternative interfaces for [base::parse()]
#'
#' @param x For `parse_text`, the text to parse; for `parse_file` the file to parse.
#' @export
parse_text <- function(x) {
  base::parse(text = x)
}

#' @rdname parse_text
#' @export
parse_file <- function(x) {
  base::parse(file = x)
}

#' Source a file with an alternative parser
#'
#' @param dir The installed directory from which to parse files
#' @param package The package
#' @param files The files to parse
#' @param parser The parser to use, should take the file to parse as the first parameter
#' @param envir The environment to evaluate the parsed code in
#' @export
src <- function(dir, package, parser = parse_file, files = NULL, envir = asNamespace(package)) {
  if (is.null(files)) {
    files <- list.files(dir, full.names = TRUE)
  }
  for (f in files) {
    exprs <- parser(f)
    for (e in exprs) {
      eval(e, envir = envir)
    }
  }
}
