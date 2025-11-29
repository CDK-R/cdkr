# Generate Bemis-Murcko Fragments

Fragment the input molecule using the Bemis-Murcko scheme

## Usage

``` r
get.exhaustive.fragments(mols, min.frag.size = 6, as.smiles = TRUE)
```

## Arguments

- mols:

  A list of \`jobjRef\` objects of Java class \`IAtomContainer\`

- min.frag.size:

  The smallest fragment to consider (in terms of heavy atoms)

- as.smiles:

  If \`TRUE\` return the fragments as SMILES strings. If not, then
  fragments are returned as \`jobjRef\` objects

## Value

returns a list of length equal to the number of input molecules. Each
element is a character vector of SMILES strings or a list of \`jobjRef\`
objects.

## Details

A variety of methods for fragmenting molecules are available ranging
from exhaustive, rings to more specific methods such as Murcko
frameworks. Fragmenting a collection of molecules can be a useful for a
variety of analyses. In addition fragment based analysis can be a useful
and faster alternative to traditional clustering of the whole
collection, especially when it is large.

Note that exhaustive fragmentation of large molecules (with many single
bonds) can become time consuming.

## See also

\[get.murcko.fragments()\]

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)

## Examples

``` r
mol <- parse.smiles('c1ccc(cc1)CN(c2cc(ccc2[N+](=O)[O-])c3c(nc(nc3CC)N)N)C')[[1]]
mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=TRUE)
mf1 <- get.murcko.fragments(mol, as.smiles=TRUE, single.framework=FALSE)
```
