# Write molecules to disk.

This function writes one or more molecules to an SD file on disk, which
can be of the single- or multi-molecule variety. In addition, if the
molecule has keyed properties, they can also be written out as SD tags.

## Usage

``` r
write.molecules(mols, filename, together = TRUE, write.props = FALSE)
```

## Arguments

- mols:

  A \`list\` of \`jobjRef\` objects representing \`IAtomContainer\`
  objects

- filename:

  The name of the SD file to write. Note that if \`together\` is
  \`FALSE\` then this argument is taken as a prefix for the name of the
  individual files

- together:

  If \`TRUE\` then all the molecules are written to a single SD file. If
  \`FALSE\` each molecule is written to an individual file

- write.props:

  If \`TRUE\`, keyed properties are included in the SD file output

## Details

In case individual SD files are desired the `together` argument can be
set ot `FALSE`. In this case, the value of `filename` is used as a
prefix, to which a numeric identifier and the suffix of ".sdf" is
appended.

## See also

[`load.molecules`](https://cdk-r.github.io/cdkr/reference/load.molecules.md),
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md),
[`iload.molecules`](https://cdk-r.github.io/cdkr/reference/iload.molecules.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
