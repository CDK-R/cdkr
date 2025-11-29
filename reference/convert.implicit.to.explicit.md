# Convert implicit hydrogens to explicit.

In some cases, a molecule may not have any hydrogens (such as when read
in from an MDL MOL file that did not have hydrogens or SMILES with no
explicit hydrogens). In such cases, this method will add implicit
hydrogens and then convert them to explicit ones. The newly added H's
will not have any 2D or 3D coordinates associated with them. Ensure that
the molecule has been typed beforehand.

## Usage

``` r
convert.implicit.to.explicit(mol)
```

## Arguments

- mol:

  The molecule to query. Should be a \`jobjRef\` representing an
  \`IAtomContainer\`

## See also

[`get.hydrogen.count`](https://cdk-r.github.io/cdkr/reference/get.hydrogen.count.md),
[`remove.hydrogens`](https://cdk-r.github.io/cdkr/reference/remove.hydrogens.md),
[`set.atom.types`](https://cdk-r.github.io/cdkr/reference/set.atom.types.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
