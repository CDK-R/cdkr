# Gets the largest component in a disconnected molecular graph.

A molecule may be represented as a [disconnected
graph](http://mathworld.wolfram.com/DisconnectedGraph.md), such as when
read in as a salt form. This method will return the larges connected
component or if there is only a single component (i.e., the molecular
graph is [complete](https://en.wikipedia.org/wiki/Complete_graph) or
fully connected), that component is returned.

## Usage

``` r
get.largest.component(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

The largest component as an \`IAtomContainer\` object or else the input
molecule itself

## See also

[`is.connected`](https://cdk-r.github.io/cdkr/reference/is.connected.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
m <- parse.smiles("CC.CCCCCC.CCCC")[[1]]
largest <- get.largest.component(m)
length(get.atoms(largest)) == 6
#> [1] TRUE
```
