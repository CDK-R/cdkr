# Get an object representing bond order

This function returns a Java enum representing a bond order. This can be
used to modify the order of pre-existing bonds

## Usage

``` r
get.bond.order(order = "single")
```

## Arguments

- order:

  A character vector that can be one of single, double, triple,
  quadruple, quintuple, sextuple or unset. Case is ignored

## Value

A `jObjRef` representing an \`Order\` enum object

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
if (FALSE) { # \dontrun{
m <- parse.smiles('CCN')[[1]]
b <- get.bonds(m)[[1]]
b$setOrder(get.bond.order("double"))
} # }
```
