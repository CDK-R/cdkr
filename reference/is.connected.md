# Tests whether the molecule is fully connected.

A single molecule will be represented as a
[complete](https://en.wikipedia.org/wiki/Complete_graph) graph. In some
cases, such as for molecules in salt form, or after certain operations
such as bond splits, the molecular graph may contained [disconnected
components](http://mathworld.wolfram.com/DisconnectedGraph.md). This
method can be used to tested whether the molecule is complete (i.e.
fully connected).

## Usage

``` r
is.connected(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

\`TRUE\` if molecule is complete, \`FALSE\` otherwise

## See also

[`get.largest.component`](https://cdk-r.github.io/cdkr/reference/get.largest.component.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
m <- parse.smiles("CC.CCCCCC.CCCC")[[1]]
is.connected(m)
#> [1] FALSE
```
