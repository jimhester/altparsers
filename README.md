# altparsers

The `altparsers` package allows the user or package developer to use
alternative parsers for R code. It provides helpers for parsing and evaluating
code and for starting a REPL with a non-standard R parser.

The expressions returned by the parsers are valid R expressions and are
evaluated in the same way as normal R code.


```{r}
library(altparsers)
repl(parser = tidy_parse_text)
#> [1, 2, 3] |> head(n = 1)
```

```{r}
repl(parser = sexp_parse_text)
(= x 5)
(== x 5)
#> [1] TRUE
(+ x (* 3 5))
#> [1] 20
```

## Within packages

`tidyparsers::src()` can be used within a package to source and evaluate code
written for alternative parsers. Generally this code needs to be in a
installed directory, such as `inst/r2`.

```{r}
.onLoad <- function(libname, pkgname) {
  altparsers::src("r2", parser = altparsers::tidy_parse_file)
}
