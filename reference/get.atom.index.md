# get.atom.index

Get the index of an atom in a molecule.

## Usage

``` r
get.atom.index(atom, mol)
```

## Arguments

- atom:

  The atom object

- mol:

  The \`IAtomContainer\` object containing the atom

## Value

An integer representing the atom index.

## Details

Acces the index of an atom in the context of an IAtomContainer. Indexing
starts from 0. If the index is not known, -1 is returned.

## See also

[`get.connected.atom`](https://cdk-r.github.io/cdkr/reference/get.connected.atom.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
