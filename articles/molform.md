# Handling Molecular Formulae

## Handling Molecular Formulae

### Introduction

The molecular formula is the simplest way to characterize a molecular
compound. It specifies the actual number of atoms of each element
contained in the molecule. A molecular formula is represented by the
chemical symbol of each constituent element. If a molecule contains more
than one atom for a particular element, the quantity is shown as
subscript after the chemical symbol. Otherwise, the number of neutrons
(atomic mass) that an atom is composed can differ. This different type
of atoms are known as isotopes. The number of nuclei is represented as
superscripted prefix previous to the chemical element. Generally it is
not added when the isotope that characterizes the element is the most
occurrence in nature, e.g., $C_{4}H_{11}O^{2}D$.

### Parsing a Molecule To a Molecular Formula

Front a molecule, defined as conjunct of atoms helding together by
chemical bonds, we can simplify it taking only the information about the
atoms. The `rcdk` package provides a parser to translate molecules to
molecular formlulas, the `get.mol2formula` function.

``` r
library(rcdk)
```

    ## Loading required package: rcdklibs

    ## Loading required package: rJava

``` r
sp <- get.smiles.parser()
molecule <- parse.smiles('N')[[1]]
convert.implicit.to.explicit(molecule)
formula <- get.mol2formula(molecule,charge=0)
```

Note that the above formula object is a `CDKFormula-class`. This class
contains some attributes that defines a molecular formula. For example,
the mass, the charge, the isotopes, the character representation of the
molecular formula and the
[IMolecularFormula](https://cdk.github.io/cdk/2.3/docs/api/org/openscience/cdk/interfaces/IMolecularFormula.html)
`jobjRef` object.

The molecular mass, charge and string representation for this formula
are given by

``` r
formula@mass
```

    ## [1] 17.02655

``` r
formula@charge
```

    ## [1] 0

``` r
formula@string
```

    ## [1] "H3N"

The isotopes for this formula. It is formed from three attributes.
`isoto` (the symbol expression of the isotope), `number` (number of
atoms for this isotope) and `mass` (exact mass of this isotope).

``` r
formula@isotopes
```

    ##      isoto number mass         
    ## [1,] "N"   "1"    "14.003074"  
    ## [2,] "H"   "3"    "1.007825032"

Depending of the circumstances, you may want to change the charge of the
molecular formula.

``` r
formula <- set.charge.formula(formula, charge=1)
```

### Initializing a Formula from the Symbol Expression

Other way to create a `cdkFormula` is from the symbol expression. Thus,
setting the characters of the elemental formula, the function
`get.formula` parses it to an object of `cdkFormula-class`.

``` r
formula <- get.formula('NH4', charge = 1)
formula
```

    ## cdkFormula:  [H4N]+ , mass =  18.03383 , charge =  1

### Generating Molecular Formula

Mass spectrometry is an essential and reliable technique to determine
the molecular mass of compounds. Conversely, one can use the measured
mass to identify the compound via its elemental formula. One of the
limitations of the method is the precision and accuracy of the
instrumentation. As a result, rather than specify exact masses, we
specify tolerances or ranges of possible mass, resulting in multiple
candidate formulae for a given mass window. The `generate.formula`
function returns a list of formulae which have a given mass (within an
error window)

``` r
mfSet <- generate.formula(18.03383, window=1,
    elements=list(c("C",0,50),c("H",0,50),c("N",0,50)),
    validation=FALSE)
mfSet
```

    ## [[1]]
    ## cdkFormula:  H4N , mass =  18.03437 , charge =  0 
    ## 
    ## [[2]]
    ## cdkFormula:  CH6 , mass =  18.04695 , charge =  0 
    ## 
    ## [[3]]
    ## cdkFormula:  H18 , mass =  18.14085 , charge =  0

It is important to know if an elemental formula is valid. The method
`isvalid.formula` provides this function. Two constraints can be
applied, the [nitrogen
rule](https://en.wikipedia.org/wiki/Nitrogen_rule) and the [RDBE
rule](https://fiehnlab.ucdavis.edu/projects/seven-golden-rules/ring-double-bonds)
(Ring Double Bond Equivalent).

``` r
formula <- get.formula('NH4', charge = 0)
isvalid.formula(formula,rule=c("nitrogen","RDBE"))
```

    ## [1] FALSE

We can observe that the ammonium is only valid if it is defined with
charge of +1.

``` r
formula <- get.formula('NH4', charge = 1)
isvalid.formula(formula,rule=c("nitrogen","RDBE"))
```

    ## [1] TRUE

The `generate.formula` method can perform these validation tests during
formula generation by setting `validation=TRUE`. However, this can
significantly slow down the process of genersating formulae, especially
with larger mass windows. When the default of `FALSE` is used,
nonsensical formulae may be generated, and it’s up to the user to filter
them out.

In contrast, the `generate.formula.iter` method employs the Round Robin
formula generation algorithm, which is significantly faster than the
default method. In contrast to `generate/formula`, this method returns
an iterator which allows you to process large formula sets without
excessive memory usage.

``` r
mit <- generate.formula.iter(100, charge=0, window=0.1,
                             elements=list(c("C",0,50), c("H",0,50), c("N",0,50)))
hit <- itertools::ihasNext(mit)
while (itertools::hasNext(hit)) 
    print(iterators::nextElem(hit))
```

    ## [1] "[12]C8[1]H4"
    ## [1] "[12]C7[1]H2[14]N"
    ## [1] "[12]C6[14]N2"
    ## [1] "[12]C4[1]H10[14]N3"
    ## [1] "[12]C3[1]H8[14]N4"
    ## [1] "[12]C2[1]H6[14]N5"
    ## [1] "[12]C[1]H4[14]N6"
    ## [1] "[1]H2[14]N7"

Note that by default, this function will not check for validity of the
generated formulae.

### Calculating Isotope Pattern

Due to the measurement errors in medium resolution spectrometry, a given
error window can result in a massive number of candidate formulae. The
isotope pattern of ions obtained experimentally can be compared with the
theoretical ones. The best match is reflected as the most probable
elemental formula. `rcdk` provides the function `get.isotope.pattern`
which predicts the theoretical isotope pattern given a formula.

``` r
formula <- get.formula('CHCl3', charge = 0)
isotopes <- get.isotopes.pattern(formula,minAbund=0.1)
isotopes
```

    ##          mass     abund
    ## [1,] 117.9144 1.0000000
    ## [2,] 119.9114 0.9598733
    ## [3,] 121.9085 0.3071189

In this example we generate a formula for a possible compound with a
charge ($z \approx 0$) containing the standard elements C, H, and Cl.
The isotope pattern can be visually inspected, as shown below.

``` r
plot(isotopes, type="h", xlab="m/z", ylab="Intensity")
```

![](molform_files/figure-html/unnamed-chunk-11-1.png)
