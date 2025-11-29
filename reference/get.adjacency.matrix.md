# Get adjacency matrix for a molecule.

The adjacency matrix for a molecule with \\N\\ non-hydrogen atoms is an
\\N \times N\\ matrix where the element \[\\i\\,\\j\\\] is set to 1 if
atoms \\i\\ and \\j\\ are connected by a bond, otherwise set to 0.

## Usage

``` r
get.adjacency.matrix(mol)
```

## Arguments

- mol:

  A `jobjRef` object with Java class `IAtomContainer`

## Value

A \\N \times N\\ numeric matrix

## See also

[`get.connection.matrix`](https://cdk-r.github.io/cdkr/reference/get.connection.matrix.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>

## Examples

``` r
m <- parse.smiles("CC=C")[[1]]
get.adjacency.matrix(m)
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    1    0    1
#> [3,]    0    1    0
```
