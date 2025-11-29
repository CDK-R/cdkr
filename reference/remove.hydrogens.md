# Remove explicit hydrogens.

Create an copy of the original structure with explicit hydrogens
removed. Stereochemistry is updated but up and down bonds in a depiction
may need to be recalculated. This can also be useful for descriptor
calculations.

## Usage

``` r
remove.hydrogens(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

A copy of the original molecule, with explicit hydrogens removed

## See also

[`get.hydrogen.count`](https://cdk-r.github.io/cdkr/reference/get.hydrogen.count.md),
[`get.total.hydrogen.count`](https://cdk-r.github.io/cdkr/reference/get.total.hydrogen.count.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
