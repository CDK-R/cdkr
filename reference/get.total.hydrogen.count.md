# Get total number of implicit hydrogens in the molecule.

Counts the number of hydrogens on the provided molecule. As this method
will sum all implicit hydrogens on each atom it is important to ensure
the molecule has already been configured (and thus each atom has an
implicit hydrogen count).

## Usage

``` r
get.total.hydrogen.count(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

An integer representing the total number of implicit hydrogens

## See also

[`get.hydrogen.count`](https://cdk-r.github.io/cdkr/reference/get.hydrogen.count.md),
[`remove.hydrogens`](https://cdk-r.github.io/cdkr/reference/remove.hydrogens.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
