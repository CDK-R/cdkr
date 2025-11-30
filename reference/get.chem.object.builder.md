# Get the default chemical object builder.

The CDK employs a builder design pattern to construct instances of new
chemical objects (e.g., atoms, bonds, parsers and so on). Many methods
require an instance of a builder object to function. While most
functions in this package handle this internally, it is useful to be
able to get an instance of a builder object when directly working with
the CDK API via \`rJava\`.

## Usage

``` r
get.chem.object.builder()
```

## Value

An instance of
[SilentChemObjectBuilder](https://cdk.github.io/cdk/2.10/docs/api/org/openscience/cdk/silent/SilentChemObjectBuilder.html)

## Details

This method returns an instance of the
[SilentChemObjectBuilder](https://cdk.github.io/cdk/2.10/docs/api/org/openscience/cdk/silent/SilentChemObjectBuilder.html).
Note that this is a static object that is created at package load time,
and the same instance is returned whenever this function is called.

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
