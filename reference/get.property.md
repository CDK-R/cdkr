# Get a property value of the molecule.

This function retrieves the value of a keyed property that has
previously been set on the molecule. Properties enable us to associate
arbitrary pieces of data with a molecule. Such data can be text, numeric
or a Java object (represented as a \`jobjRef\`).

## Usage

``` r
get.property(molecule, key)
```

## Arguments

- molecule:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

- key:

  The property key as a character string

## Value

The value of the property. If there is no property with the specified
key, \`NA\` is returned

## See also

[`set.property`](https://cdk-r.github.io/cdkr/reference/set.property.md),
[`get.properties`](https://cdk-r.github.io/cdkr/reference/get.properties.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
mol <- parse.smiles("CC1CC(C=O)CCC1")[[1]]
set.property(mol, 'prop1', 23.45)
set.property(mol, 'prop2', 'inactive')
get.property(mol, 'prop1')
#> [1] 23.45
```
