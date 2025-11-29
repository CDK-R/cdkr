# generate.formula.iter

Generate a list of possible formula objects given a mass and a mass
tolerance.

## Usage

``` r
generate.formula.iter(
  mass,
  window = 0.01,
  elements = list(c("C", 0, 50), c("H", 0, 50), c("N", 0, 50), c("O", 0, 50), c("S", 0,
    50)),
  validation = FALSE,
  charge = 0,
  as.string = TRUE
)
```

## Arguments

- mass:

  Required. Mass.

- window:

  Optional. Default `0.01`

- elements:

  Optional. Default
  ` list(c('C', 0,50), c('H', 0,50), c('N', 0,50), c('O', 0,50), c('S', 0,50))`

- validation:

  Optional. Default `FALSE`

- charge:

  Optional. Default `FALSE`

- as.string:

  Optional. Default `FALSE`
