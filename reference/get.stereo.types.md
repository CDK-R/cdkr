# Obtain the stereocenter type for atom.

Supported stereo center types are

- True:

  the atom has constitutionally different neighbors

- Para:

  the atom resembles a stereo centre but has constitutionally equivalent
  neighbors (e.g. inositol, decalin). The stereocenter depends on the
  configuration of one or more stereocenters.

- Potential:

  the atom can supported stereo chemistry but has not be shown ot be a
  true or para center

- Non:

  the atom is not a stereocenter (e.g. methane)

## Usage

``` r
get.stereo.types(mol)
```

## Arguments

- mol:

  A `jObjRef` representing an `IAtomContainer`

## Value

A factor of length equal in length to the number of atoms indicating the
stereocenter type.

## See also

[`get.stereocenters`](https://cdk-r.github.io/cdkr/reference/get.stereocenters.md),
[`get.element.types`](https://cdk-r.github.io/cdkr/reference/get.element.types.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>
