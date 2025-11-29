# Set a property value of the molecule.

This function sets the value of a keyed property on the molecule.
Properties enable us to associate arbitrary pieces of data with a
molecule. Such data can be text, numeric or a Java object (represented
as a \`jobjRef\`).

## Usage

``` r
set.property(molecule, key, value)
```

## Arguments

- molecule:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

- key:

  The property key as a character string

- value:

  The value of the property. This can be a character, numeric or
  \`jobjRef\` R object

## See also

[`get.property`](https://cdk-r.github.io/cdkr/reference/get.property.md),
[`get.properties`](https://cdk-r.github.io/cdkr/reference/get.properties.md),
[`remove.property`](https://cdk-r.github.io/cdkr/reference/remove.property.md)

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
