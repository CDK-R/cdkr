# get.point2d

Get the 2D coordinates of the atom.

## Usage

``` r
get.point2d(atom)
```

## Arguments

- atom:

  The atom to query

## Value

A 2-element numeric vector representing the X & Y coordinates.

## Details

In case, coordinates are unavailable (e.g., molecule was read in from a
SMILES file) or have not been generated yet, \`NA\`'s are returned for
the X & Y coordinates.

## See also

[`get.point3d`](https://cdk-r.github.io/cdkr/reference/get.point3d.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
if (FALSE) { # \dontrun{
atoms <- get.atoms(mol)
coords <- do.call('rbind', lapply(apply, get.point2d))
} # }
```
