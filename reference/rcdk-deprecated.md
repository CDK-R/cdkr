# Deprecated functions in the rcdk package.

These functions are provided for compatibility with older version of the
phyloseq package. They may eventually be completely removed.

## Usage

``` r
deprecated_rcdk_function(x, value, ...)
```

## Arguments

- x:

  For assignment operators, the object that will undergo a replacement
  (object inside parenthesis).

- value:

  For assignment operators, the value to replace with (the right side of
  the assignment).

- ...:

  For functions other than assignment operators, parameters to be passed
  to the modern version of the function (see table).

## Details

|             |                                                                                                |
|-------------|------------------------------------------------------------------------------------------------|
| `do.typing` | now a synonym for [`set.atom.types`](https://cdk-r.github.io/cdkr/reference/set.atom.types.md) |
