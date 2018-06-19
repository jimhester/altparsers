# altparsers

The `altparsers` package allows the user or package developer to use
alternative parsers for R code. It provides helpers for parsing and evaluating
code and for starting a REPL with a non-standard R parser.

The expressions returned by the parsers are valid R expressions and are
evaluated in the same way as normal R code.


```{r}
library(altparsers)
repl(parser = tidy_parser)
#> [1, 2, 3] |> head(n = 1)
```

```{r}
repl(parser = sexp_parser)
(= x 5)
(== x 5)
#> [1] TRUE
(+ x (* 3 5))
#> [1] 20
```
