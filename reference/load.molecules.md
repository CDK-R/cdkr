# Load molecular structures from disk or URL

The CDK can read a variety of molecular structure formats. This function
encapsulates the calls to the CDK API to load a structure given its
filename or a URL to a structure file.

## Usage

``` r
load.molecules(
  molfiles = NA,
  aromaticity = TRUE,
  typing = TRUE,
  isotopes = TRUE,
  verbose = FALSE
)
```

## Arguments

- molfiles:

  A \`character\` vector of filenames. Note that the full path to the
  files should be provided. URL's can also be used as paths. In such a
  case, the URL should start with "http://"

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

- verbose:

  If \`TRUE\`, output (such as file download progress) will be bountiful

## Value

A \`list\` of CDK \`IAtomContainer\` objects, represented as \`jobjRef\`
objects in R, which can be used in other \`rcdk\` functions

## Details

Note that this method will load all molecules into memory. For files
containing tens of thousands of molecules this may lead to out of memory
errors. In such situations consider using the iterating file readers.

Note that if molecules are read in from formats that do not have rules
for handling implicit hydrogens (such as MDL MOL), the molecule will not
have implicit or explicit hydrogens. To add explicit hydrogens, make
sure that the molecule has been typed (this is \`TRUE\` by default for
this function) and then call
[`convert.implicit.to.explicit`](https://cdk-r.github.io/cdkr/reference/convert.implicit.to.explicit.md).
On the other hand for a format such as SMILES, implicit or explicit
hydrogens will be present.

## See also

[`write.molecules`](https://cdk-r.github.io/cdkr/reference/write.molecules.md),
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md),
[`iload.molecules`](https://cdk-r.github.io/cdkr/reference/iload.molecules.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
if (FALSE) { # \dontrun{
sdffile <- system.file("molfiles/dhfr00008.sdf", package="rcdk")
mols <- load.molecules(c('mol1.sdf', 'mol2.smi', sdfile))
} # }
```
