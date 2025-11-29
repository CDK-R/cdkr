# Get the atom connected to an atom in a bond.

This function returns the atom that is connected to a specified in a
specified bond. Note that this function assumes 2-atom bonds, mainly
because the CDK does not currently support other types of bonds

## Usage

``` r
get.connected.atom(bond, atom)
```

## Arguments

- bond:

  A `jObjRef` representing an \`IBond\` object

- atom:

  A `jObjRef` representing an \`IAtom\` object

## Value

A `jObjRef` representing an \`IAtom“ object

## See also

[`get.atoms`](https://cdk-r.github.io/cdkr/reference/get.atoms.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
