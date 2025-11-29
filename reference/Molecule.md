# Operations on molecules

Various functions to perform operations on molecules.

[`get.exact.mass`](https://cdk-r.github.io/cdkr/reference/get.exact.mass.md)
returns the exact mass of a molecule
[`get.natural.mass`](https://cdk-r.github.io/cdkr/reference/get.natural.mass.md)
returns the natural exact mass of a molecule
[`convert.implicit.to.explicit`](https://cdk-r.github.io/cdkr/reference/convert.implicit.to.explicit.md)
converts implicit hydrogens to explicit hydrogens. This function does
not return any value but rather modifies the molecule object passed to
it [`is.neutral`](https://cdk-r.github.io/cdkr/reference/is.neutral.md)
returns `TRUE` if all atoms in the molecule have a formal charge of `0`,
otherwise `FALSE`

## Details

In some cases, a molecule may not have any hydrogens (such as when read
in from an MDL MOLfile that did not have hydrogens). In such cases,
[`convert.implicit.to.explicit`](https://cdk-r.github.io/cdkr/reference/convert.implicit.to.explicit.md)
will add implicit hydrogens and then convert them to explicit ones. In
addition, for such cases, make sure that the molecule has been typed
beforehand.

## Usage

get.exact.mass(mol) get.natural.mass(mol)
convert.implicit.to.explicit(mol) is.neutral(mol)

## Arguments

mol A jobjRef representing an IAtomContainer or IMolecule object

## Value

[`get.exact.mass`](https://cdk-r.github.io/cdkr/reference/get.exact.mass.md)
returns a numeric
[`get.natural.mass`](https://cdk-r.github.io/cdkr/reference/get.natural.mass.md)
returns a numeric
[`convert.implicit.to.explicit`](https://cdk-r.github.io/cdkr/reference/convert.implicit.to.explicit.md)
has no return value
[`is.neutral`](https://cdk-r.github.io/cdkr/reference/is.neutral.md)
returns a boolean.

## See also

[`get.atoms`](https://cdk-r.github.io/cdkr/reference/get.atoms.md),
[`set.atom.types`](https://cdk-r.github.io/cdkr/reference/set.atom.types.md)

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
