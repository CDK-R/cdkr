# Identify which atoms are stereocenters.

This method identifies stereocenters based on connectivity.

## Usage

``` r
get.stereocenters(mol)
```

## Arguments

- mol:

  A `jObjRef` representing an `IAtomContainer`

## Value

A logical vector of length equal in length to the number of atoms. The
i'th element is `TRUE` if the i'th element is identified as a
stereocenter

## See also

[`get.element.types`](https://cdk-r.github.io/cdkr/reference/get.element.types.md),
[`get.stereo.types`](https://cdk-r.github.io/cdkr/reference/get.stereo.types.md)

## Author

Rajarshi Guha <rajarshi.guha@gmail.com>
