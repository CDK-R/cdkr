# Compare isotope patterns.

Computes a similarity score between two different isotope abundance
patterns.

## Usage

``` r
compare.isotope.pattern(iso1, iso2, ips = NULL)
```

## Arguments

- iso1:

  The first isotope pattern, which should be a `jobjRef` corresponding
  to the `IsotopePattern` class

- iso2:

  The second isotope pattern, which should be a `jobjRef` corresponding
  to the `IsotopePattern` class

- ips:

  An instance of the `IsotopePatternSimilarity` class. if `NULL` one
  will be constructed automatically

## Value

A numeric value between 0 and 1 indicating the similarity between the
two patterns

## References

[http://cdk.github.io/cdk/2.3/docs/api/org/openscience/cdk/formula/IsotopePatternSimilarity.html](http://cdk.github.io/cdk/2.3/docs/api/org/openscience/cdk/formula/IsotopePatternSimilarity.md)

## See also

[`get.isotope.pattern.similarity`](https://cdk-r.github.io/cdkr/reference/get.isotope.pattern.similarity.md)

## Author

Miguel Rojas Cherto
