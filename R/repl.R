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

repl <- function(env = parent.frame(), parser = parse_text) {
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

  # Eval
    for (e in ans) {
      e <- tryCatch(withVisible(eval(e, envir = env)), error = function(e) e)

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

#' Test
#' @name a
#' @examples
#' a()
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
#' @param file The file to parse
#' @param parser The parser to use, should take the file to parse as the first parameter
#' @param envir The environment to evaluate the parsed code in
#' @export
src <- function(file, parser = parse_file, envir = parent.frame()) {
  for (f in file) {
    exprs <- parser(f)
    for (e in exprs) {
      eval(e, envir = envir)
    }
  }
}

src(Sys.glob(file.path(system.file(package = "altparsers", "r2"), "*.r2")))
