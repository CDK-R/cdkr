# Load molecules using an iterator.

The CDK can read a variety of molecular structure formats. Some file
formats support multiple molecules in a single file. If read using
[`load.molecules`](https://cdk-r.github.io/cdkr/reference/load.molecules.md),
all are read into memory. For very large structure files, this can lead
to out of memory errors. Instead it is recommended to use the iterating
version of the loader so that only a single molecule is read at a time.

## Usage

``` r
iload.molecules(
  molfile,
  type = "smi",
  aromaticity = TRUE,
  typing = TRUE,
  isotopes = TRUE,
  skip = TRUE
)
```

## Arguments

- molfile:

  A string containing the filename to load. Must be a local file

- type:

  Indicates whether the input file is SMILES or SDF. Valid values are
  \`"smi"\` or \`"sdf"\`

- aromaticity:

  If \`TRUE\` then aromaticity detection is performed on all loaded
  molecules. If this fails for a given molecule, then the molecule is
  set to \`NA\` in the return list

- typing:

  If \`TRUE\` then atom typing is performed on all loaded molecules. The
  assigned types will be CDK internal types. If this fails for a given
  molecule, then the molecule is set to \`NA\` in the return list

- isotopes:

  If \`TRUE\` then atoms are configured with isotopic masses

- skip:

  If \`TRUE\`, then the reader will continue reading even when faced
  with an invalid molecule. If \`FALSE\`, the reader will stop at the
  fist invalid molecule

## Details

Note that the iterating loader only supports SDF and SMILES file
formats.

## See also

[`write.molecules`](https://cdk-r.github.io/cdkr/reference/write.molecules.md),
[`load.molecules`](https://cdk-r.github.io/cdkr/reference/load.molecules.md),
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
if (FALSE) { # \dontrun{
moliter <- iload.molecules("big.sdf", type="sdf")
while(hasNext(moliter)) {
mol <- nextElem(moliter)
  print(get.property(mol, "cdk:Title"))
}
} # }
```
