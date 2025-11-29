# Remove a property associated with a molecule.

In this context a property is a value associated with a key and stored
with the molecule. This methd will remove the property defined by the
key. If there is such key, a warning is raised.

## Usage

``` r
remove.property(molecule, key)
```

## Arguments

- molecule:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

- key:

  The property key as a character string

## See also

[`set.property`](https://cdk-r.github.io/cdkr/reference/set.property.md),
[`get.property`](https://cdk-r.github.io/cdkr/reference/get.property.md),
[`get.properties`](https://cdk-r.github.io/cdkr/reference/get.properties.md)

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
remove.property(mol, 'prop2')
get.properties(mol)
#> $`cdk:Title`
#> [1] NA
#> 
#> $prop1
#> [1] 23.45
#> 
```
