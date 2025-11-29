# Generate a SMILES representation of a molecule.

The function will generate a SMILES representation of an
\`IAtomContainer\` object. The default parameters of the CDK SMILES
generator are used. This can mean that for large ring systems the method
may fail. See CDK
[Javadocs](http://cdk.github.io/cdk/2.2/docs/api/org/openscience/cdk/smiles/SmilesGenerator.md)
for more information

## Usage

``` r
get.smiles(molecule, flavor = smiles.flavors(c("Generic")), smigen = NULL)
```

## Arguments

- molecule:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

- flavor:

  The type of SMILES to generate. See
  [`smiles.flavors`](https://cdk-r.github.io/cdkr/reference/smiles.flavors.md).
  Default is \`Generic\` SMILES

- smigen:

  A pre-existing SMILES generator object. By default, a new one is
  created from the specified flavor

## Value

A character string containing the generated SMILES

## References

[SmilesGenerator](http://cdk.github.io/cdk/2.2/docs/api/org/openscience/cdk/smiles/SmilesGenerator.md)

## See also

[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md),
[`smiles.flavors`](https://cdk-r.github.io/cdkr/reference/smiles.flavors.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
get.smiles(m)
#> [1] "C1C=CCC1N(C)C2=CC=CC=C2"
get.smiles(m, smiles.flavors(c('Generic','UseAromaticSymbols')))
#> [1] "C1C=CCC1N(C)c2ccccc2"
```
