# Get connection matrix for a molecule.

The connection matrix for a molecule with \\N\\ non-hydrogen atoms is an
\\N \times N\\ matrix where the element \[\\i\\,\\j\\\] is set to the
bond order if atoms \\i\\ and \\j\\ are connected by a bond, otherwise
set to 0.

## Usage

``` r
get.connection.matrix(mol)
```

## Arguments

- mol:

  A `jobjRef` object with Java class `IAtomContainer`

## Value

A \\N \times N\\ numeric matrix

## See also

[`get.adjacency.matrix`](https://cdk-r.github.io/cdkr/reference/get.adjacency.matrix.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>

## Examples

``` r
m <- parse.smiles("CC=C")[[1]]
get.connection.matrix(m)
#>      [,1] [,2] [,3]
#> [1,]    0    1    0
#> [2,]    1    0    2
#> [3,]    0    2    0
```
