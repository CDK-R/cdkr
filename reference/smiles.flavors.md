# Generate flag for customizing SMILES generation.

The CDK supports a variety of customizations for SMILES generation
including the use of lower case symbols for aromatic compounds to the
use of the ChemAxon
[CxSmiles](https://docs.chemaxon.com/display/docs/formats_chemaxon-extended-smiles-and-smarts-cxsmiles-and-cxsmarts.md)
format. Each 'flavor' is represented by an integer and multiple
customizations are bitwise OR'ed. This method accepts the names of one
or more customizations and returns the bitwise OR of them. See [CDK
documentation](https://cdk.github.io/cdk/2.10/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html)
for the list of flavors and what they mean.

## Usage

``` r
smiles.flavors(flavors = c("Generic"))
```

## Arguments

- flavors:

  A character vector of flavors. The default is `Generic` (output
  non-canonical SMILES without stereochemistry, atomic masses). Possible
  values are

  - Absolute

  - AtomAtomMap

  - AtomicMass

  - AtomicMassStrict

  - Canonical

  - Cx2dCoordinates

  - Cx3dCoordinates

  - CxAtomLabel

  - CxAtomValue

  - CxCoordinates

  - CxFragmentGroup

  - CxMulticenter

  - CxPolymer

  - CxRadical

  - CxSmiles

  - CxSmilesWithCoords

  - Default

  - Generic

  - InChILabelling

  - Isomeric

  - Stereo

  - StereoCisTrans

  - StereoExTetrahedral

  - StereoTetrahedral

  - Unique

  - UniversalSmiles

  - UseAromaticSymbols

## Value

A numeric representing the bitwise \`OR“ of the specified flavors

## References

[CDK
documentation](https://cdk.github.io/cdk/2.10/docs/api/index.html?org/openscience/cdk/smiles/SmiFlavor.html)

## See also

[`get.smiles`](https://cdk-r.github.io/cdkr/reference/get.smiles.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>

## Examples

``` r
m <- parse.smiles('C1C=CCC1N(C)c1ccccc1')[[1]]
get.smiles(m)
#> [1] "C1C=CCC1N(C)C2=CC=CC=C2"
get.smiles(m, smiles.flavors(c('Generic','UseAromaticSymbols')))
#> [1] "C1C=CCC1N(C)c2ccccc2"

m <- parse.smiles("OS(=O)(=O)c1ccc(cc1)C(CC)CC |Sg:n:13:m:ht,Sg:n:11:n:ht|")[[1]]
get.smiles(m,flavor = smiles.flavors(c("CxSmiles")))
#> [1] "OS(=O)(=O)C1=CC=C(C=C1)C(CC)CC |Sg:n:11:n:ht,Sg:n:13:m:ht|"
get.smiles(m,flavor = smiles.flavors(c("CxSmiles","UseAromaticSymbols")))
#> [1] "OS(=O)(=O)c1ccc(cc1)C(CC)CC |Sg:n:11:n:ht,Sg:n:13:m:ht|"
```
