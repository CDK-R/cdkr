# Generate molecular fingerprints

\`get.fingerprint\` returns a \`fingerprint\` object representing
molecular fingerprint of the input molecule.

## Usage

``` r
get.fingerprint(
  molecule,
  type = "standard",
  fp.mode = "bit",
  depth = 6,
  size = 1024,
  substructure.pattern = character(),
  circular.type = "ECFP6",
  verbose = FALSE
)
```

## Arguments

- molecule:

  A `jobjRef` object to an `IAtomContaine`

- type:

  The type of fingerprint. Possible values are:

  - standard - Considers paths of a given length. The default is but can
    be changed. These are hashed fingerprints, with a default length of
    1024

  - extended - Similar to the standard type, but takes rings and atomic
    properties into account into account

  - graph - Similar to the standard type by simply considers
    connectivity

  - hybridization - Similar to the standard type, but only consider
    hybridization state

  - maccs - The popular 166 bit MACCS keys described by MDL

  - estate - 79 bit fingerprints corresponding to the E-State atom types
    described by Hall and Kier

  - pubchem - 881 bit fingerprints defined by PubChem

  - kr - 4860 bit fingerprint defined by Klekota and Roth

  - shortestpath - A fingerprint based on the shortest paths between
    pairs of atoms and takes into account ring systems, charges etc.

  - signature - A feature,count type of fingerprint, similar in nature
    to circular fingerprints, but based on the signature descriptor

  - circular - An implementation of the ECFP6 (default) fingerprint.
    Other circular types can be chosen by modifying the `circular.type`
    parameter.

  - substructure - Fingerprint based on list of SMARTS pattern. By
    default a set of functional groups is tested.

- fp.mode:

  The style of fingerprint. Specifying "\`bit\`" will return a binary
  fingerprint, "\`raw\`" returns the the original representation
  (usually sequence of integers) and "\`count\`" returns the fingerprint
  as a sequence of counts.

- depth:

  The search depth. This argument is ignored for the \`pubchem\`,
  \`maccs\`, \`kr\` and \`estate\` fingerprints

- size:

  The final length of the fingerprint. This argument is ignored for the
  \`pubchem\`, \`maccs\`, \`kr\`, \`signature\`, \`circular\` and
  \`estate\` fingerprints

- substructure.pattern:

  List of characters containing the SMARTS pattern to match. If the an
  empty list is provided (default) than the functional groups
  substructures (default in CDK) are used.

- circular.type:

  Name of the circular fingerprint type that should be computed given as
  string. Possible values are: 'ECFP0', 'ECFP2', 'ECFP4', 'ECFP6'
  (default), 'FCFP0', 'FCFP2', 'FCFP4' and 'FCFP6'.

- verbose:

  Verbose output if `TRUE`

## Value

an S4 object of class `fingerprint-class` or `featvec-class`, which can
be manipulated with the fingerprint package.

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
## get some molecules
sp <- get.smiles.parser()
smiles <- c('CCC', 'CCN', 'CCN(C)(C)', 'c1ccccc1Cc1ccccc1','C1CCC1CC(CN(C)(C))CC(=O)CC')
mols <- parse.smiles(smiles)

## get a single fingerprint using the standard
## (hashed, path based) fingerprinter
fp <- get.fingerprint(mols[[1]])

## get MACCS keys for all the molecules
fps <- lapply(mols, get.fingerprint, type='maccs')

## get Signature fingerprint
## feature, count fingerprinter
fps <- lapply(mols, get.fingerprint, type='signature', fp.mode='raw')
## get Substructure fingerprint for functional group fragments
fps <- lapply(mols, get.fingerprint, type='substructure')

## get Substructure count fingerprint for user defined fragments
mol1 <- parse.smiles("c1ccccc1CCC")[[1]]
smarts <- c("c1ccccc1", "[CX4H3][#6]", "[CX2]#[CX2]")
fps <- get.fingerprint(mol1, type='substructure', fp.mode='count',
    substructure.pattern=smarts)

## get ECFP0 count fingerprints 
mol2 <- parse.smiles("C1=CC=CC(=C1)CCCC2=CC=CC=C2")[[1]]
fps <- get.fingerprint(mol2, type='circular', fp.mode='count', circular.type='ECFP0')
```
