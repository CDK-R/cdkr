# get.charge

Get the charge on the atom.

## Usage

``` r
get.charge(atom)
```

## Arguments

- atom:

  The atom to query

## Value

An numeric representing the partial charge. If charges have not been
set, \`NULL\` is returned

## Details

This method returns the partial charge on the atom. If charges have not
been set the return value is `NULL`, otherwise the appropriate charge.

## See also

[`get.formal.charge`](https://cdk-r.github.io/cdkr/reference/get.formal.charge.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
