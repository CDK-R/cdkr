# get.point3d

Get the 3D coordinates of the atom.

## Usage

``` r
get.point3d(atom)
```

## Arguments

- atom:

  The atom to query

## Value

A 3-element numeric vector representing the X, Y and Z coordinates.

## Details

In case, coordinates are unavailable (e.g., molecule was read in from a
SMILES file) or have not been generated yet, \`NA\`'s are returned for
the X, Y and Z coordinates.

## See also

[`get.point2d`](https://cdk-r.github.io/cdkr/reference/get.point2d.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
if (FALSE) { # \dontrun{
atoms <- get.atoms(mol)
coords <- do.call('rbind', lapply(apply, get.point3d))
} # }
```
