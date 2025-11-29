# Compute descriptors for each atom in a molecule

Compute descriptors for each atom in a molecule

## Usage

``` r
eval.atomic.desc(molecule, which.desc, verbose = FALSE)
```

## Arguments

- molecule:

  A molecule object

- which.desc:

  A character vector of atomic descriptor class names

- verbose:

  Optional. Default `FALSE`. Toggle verbosity.

## Value

A \`data.frame\` with atoms in the rows and descriptors in the columns

## See also

[get.atomic.desc.names](https://cdk-r.github.io/cdkr/reference/get.atomic.desc.names.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
