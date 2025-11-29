# Get the title of the molecule.

Some molecules may not have a title (such as when parsing in a SMILES
with not title).

## Usage

``` r
get.title(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

A character string with the title, \`NA\` is no title is specified

## See also

[`set.title`](https://cdk-r.github.io/cdkr/reference/set.title.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
