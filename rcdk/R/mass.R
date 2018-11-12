.fmla2atomcontainer <- function(f){
  .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
         "org/openscience/cdk/interfaces/IAtomContainer",
         "getAtomContainer",
         f,
         use.true.class = FALSE)
}
.atomcontainer2fmla <- function(m) {
  .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
    "org/openscience/cdk/interfaces/IMolecularFormula",
    "getMolecularFormula",
    m,
    use.true.class = FALSE)
}

get.mass <- function(obj, type = c('default','total.exact','natural.exact', 
                                   'mass.number', 'major.isotope', 'molecular.weight')) {
  if (!.check.class(obj, "org/openscience/cdk/interfaces/IAtomContainer") &&
      class(obj) != 'cdkFormula')  
    stop("molecule must be a jobjRef of Java class IAtomContainer or a cdkFormula object")
  type <- match.arg(type)
 
  ret <- NA
  if (type == 'major.isotope') {
    if (class(obj) != 'cdkFormula') {
      obj <- .atomcontainer2fmla(obj)
    } else obj <- obj@objectJ
    ret <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                  "D", "getMajorIsotopeMass", obj, use.true.class=FALSE)
  } else if (type == 'mass.number') {
    if (class(obj) != 'cdkFormula') {
      obj <- .atomcontainer2fmla(obj)
    } else obj <- obj@objectJ
    ret <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                  "D", "getTotalMassNumber", obj, use.true.class=FALSE)
  } else if (type == 'total.exact') {
    if (class(obj) == 'cdkFormula') {
      cls <- 'org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator'
      obj <- obj@objectJ
    } else cls <- 'org/openscience/cdk/tools/manipulator/AtomContainerManipulator'
    ret <- .jcall(cls, "D", "getTotalExactMass", obj, use.true.class=FALSE)
  } else if (type == 'natural.exact') {
    if (class(obj) == 'cdkFormula') {
      cls <- 'org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator'
      obj <- obj@objectJ
    } else cls <- 'org/openscience/cdk/tools/manipulator/AtomContainerManipulator'
    ret <- .jcall(cls, "D", "getTotalExactMass", obj, use.true.class=FALSE)
  } else if (type == 'molecular.weight') {
    if (class(obj) == 'cdkFormula') {
      obj <- .fmla2atomcontainer(obj)
    }
    cls <- 'org/openscience/cdk/tools/manipulator/AtomContainerManipulator'
    ret <- .jcall(cls, "D", "getMolecularWeight", obj, use.true.class=FALSE)
  }
  return(ret)
}

get.exact.mass <- function(mol) {
  return(get.mass(mol, type='total.exact'))
}

get.natural.mass <- function(mol) {
  return(get.mass(mol, type='natural.exact'))
}
