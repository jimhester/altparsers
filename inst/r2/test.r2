library(dplyr)

# https://github.com/r-lib/rlang/pull/328
a <- function(df, ...) {
  dots <- quos(...)
  df |> filter(!!!dots)
}
