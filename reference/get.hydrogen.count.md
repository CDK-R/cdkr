# get.hydrogen.count

Get the implicit hydrogen count for the atom.

## Usage

``` r
get.hydrogen.count(atom)
```

## Arguments

- atom:

  The atom to query

## Value

An integer representing the hydrogen count

## Details

This method returns the number of implicit H's on the atom. Depending on
where the molecule was read from this may be `NULL` or an integer
greater than or equal to 0

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
