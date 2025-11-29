# Get all properties associated with a molecule.

In this context a property is a value associated with a key and stored
with the molecule. This method returns a list of all the properties of a
molecule. The names of the list are set to the property names.

## Usage

``` r
get.properties(molecule)
```

## Arguments

- molecule:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

A named \`list\` with the property values. Element names are the keys
for each property. If no properties have been defined, an empty list.

## See also

[`set.property`](https://cdk-r.github.io/cdkr/reference/set.property.md),
[`get.property`](https://cdk-r.github.io/cdkr/reference/get.property.md),
[`remove.property`](https://cdk-r.github.io/cdkr/reference/remove.property.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
set.property(mol, 'prop1', 23.45)
set.property(mol, 'prop2', 'inactive')
get.properties(mol)
#> $`cdk:Title`
#> [1] NA
#> 
#> $prop1
#> [1] 23.45
#> 
#> $prop2
#> [1] "inactive"
#> 
```
