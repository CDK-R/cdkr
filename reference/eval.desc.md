# Compute descriptor values for a set of molecules

Compute descriptor values for a set of molecules

## Usage

``` r
eval.desc(molecules, which.desc, verbose = FALSE)
```

## Arguments

- molecules:

  A \`list\` of molecule objects

- which.desc:

  A character vector listing descriptor class names

- verbose:

  If \`TRUE\`, verbose output

## Value

A \`data.frame\` with molecules in the rows and descriptors in the
columns. If a descriptor value cannot be computed for a molecule, \`NA\`
is returned.

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
