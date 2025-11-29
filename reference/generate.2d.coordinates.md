# Generate 2D coordinates for a molecule.

Some file formats such as SMILES do not support 2D (or 3D) coordinates
for the atoms. Other formats such as SD or MOL have support for
coordinates but may not include them. This method will generate
reasonable 2D coordinates based purely on connectivity information,
overwriting any existing coordinates if present.

## Usage

``` r
generate.2d.coordinates(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## Value

The input molecule, with 2D coordinates added

## Details

Note that when depicting a molecule
([`view.molecule.2d`](https://cdk-r.github.io/cdkr/reference/view.molecule.2d.md)),
2D coordinates are generated, but since it does not modify the input
molecule, we do not have access to the generated coordinates.

## See also

[`get.point2d`](https://cdk-r.github.io/cdkr/reference/get.point2d.md),
[`view.molecule.2d`](https://cdk-r.github.io/cdkr/reference/view.molecule.2d.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
