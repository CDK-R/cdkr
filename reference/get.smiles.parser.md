# Get a SMILES parser object.

This function returns a reference to a SMILES parser object. If you are
parsing multiple SMILES strings using multiple calls to
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md),
it is preferable to create your own parser and supply it to
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md)
rather than forcing that function to instantiate a new parser for each
call

## Usage

``` r
get.smiles.parser()
```

## Value

A \`jobjRef\` object corresponding to the CDK
[SmilesParser](http://cdk.github.io/cdk/2.2/docs/api/org/openscience/cdk/smiles/SmilesParser.md)
class

## See also

[`get.smiles`](https://cdk-r.github.io/cdkr/reference/get.smiles.md),
[`parse.smiles`](https://cdk-r.github.io/cdkr/reference/parse.smiles.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
