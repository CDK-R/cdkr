# Obtain the type of stereo element support for atom.

Supported elements types are

- Bicoordinate:

  an central atom involved in a cumulated system (not yet supported)

- Tricoordinate:

  an atom at one end of a geometric (double-bond) stereo bond or
  cumulated system

- Tetracoordinate:

  a tetrahedral atom (could also be square planar in future)

- None:

  the atom is not a (supported) stereo element type

## Usage

``` r
get.element.types(mol)
```

## Arguments

- mol:

  A `jObjRef` representing an `IAtomContainer`

## Value

A factor of length equal in length to the number of atoms, indicating
the element type

## See also

[`get.stereocenters`](https://cdk-r.github.io/cdkr/reference/get.stereocenters.md),
[`get.stereo.types`](https://cdk-r.github.io/cdkr/reference/get.stereo.types.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>
