# Operations on Atoms

[`get.symbol`](https://cdk-r.github.io/cdkr/reference/get.symbol.md)
returns the chemical symbol for an atom
[`get.point3d`](https://cdk-r.github.io/cdkr/reference/get.point3d.md)
returns the 3D coordinates of the atom
[`get.point2d`](https://cdk-r.github.io/cdkr/reference/get.point2d.md)
returns the 2D coordinates of the atom
[`get.atomic.number`](https://cdk-r.github.io/cdkr/reference/get.atomic.number.md)
returns the atomic number of the atom
[`get.hydrogen.count`](https://cdk-r.github.io/cdkr/reference/get.hydrogen.count.md)
returns the number of implicit H’s on the atom. Depending on where the
molecule was read from this may be `NULL` or an integer greater than or
equal to `0`
[`get.charge`](https://cdk-r.github.io/cdkr/reference/get.charge.md)
returns the partial charge on the atom. If charges have not been set the
return value is `NULL`, otherwise the appropriate charge.
[`get.formal.charge`](https://cdk-r.github.io/cdkr/reference/get.formal.charge.md)
returns the formal charge on the atom. By default the formal charge will
be `0` (i.e., `NULL` is never returned)
[`is.aromatic`](https://cdk-r.github.io/cdkr/reference/is.aromatic.md)
returns `TRUE` if the atom is aromatic, `FALSE` otherwise
[`is.aliphatic`](https://cdk-r.github.io/cdkr/reference/is.aliphatic.md)
returns `TRUE` if the atom is part of an aliphatic chain, `FALSE`
otherwise
[`is.in.ring`](https://cdk-r.github.io/cdkr/reference/is.in.ring.md)
returns `TRUE` if the atom is in a ring, `FALSE` otherwise
[`get.atom.index`](https://cdk-r.github.io/cdkr/reference/get.atom.index.md)
eturns the index of the atom in the molecule (starting from `0`)
[`get.connected.atoms`](https://cdk-r.github.io/cdkr/reference/get.connected.atoms.md)
returns a list of atoms that are connected to the specified atom

## Usage

get.symbol(atom) get.point3d(atom) get.point2d(atom)
get.atomic.number(atom) get.hydrogen.count(atom) get.charge(atom)
get.formal.charge(atom) get.connected.atoms(atom, mol)
get.atom.index(atom, mol) is.aromatic(atom) is.aliphatic(atom)
is.in.ring(atom) set.atom.types(mol)

## Arguments

atom A jobjRef representing an IAtom object mol A jobjRef representing
an IAtomContainer object

## Value

In the case of
[`get.point3d`](https://cdk-r.github.io/cdkr/reference/get.point3d.md)
the return value is a 3-element vector containing the X, Y and Z
co-ordinates of the atom. If the atom does not have 3D coordinates, it
returns a vector of the form `c(NA,NA,NA)`. Similarly for
[`get.point2d`](https://cdk-r.github.io/cdkr/reference/get.point2d.md),
in which case the return vector is of length `2`.

## Author

Rajarshi Guha (<rajarshi.guha@gmail.com>)
