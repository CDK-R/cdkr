test.is.connected <- function()
{
  m <- parse.smiles('CCCC')[[1]]
  connected <- is.connected(m)
  checkTrue(connected)
  m <- parse.smiles('CCCC.CCCC')[[1]]  
  connected <- is.connected(m)
  checkTrue(!connected)  
}

test.get.largest <- function() {
  m <- parse.smiles('CCCC')[[1]]
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 4)

  m <- parse.smiles('CCCC.CCCCCC.CC')[[1]]
  l <- get.largest.component(m)
  checkEquals(length(get.atoms(l)), 6)  
}

test.atom.count <- function() {
  m <- parse.smiles("CCC")[[1]]
  natom <- get.atom.count(m)
  checkEquals(natom, 3)

  convert.implicit.to.explicit(m)
  natom <- get.atom.count(m)
  checkEquals(natom, 11)  
}

test.is.neutral <- function() {
  m <- parse.smiles("CCC")[[1]]
  checkTrue(is.neutral(m))
  m <- parse.smiles('[O-]CC')[[1]]
  checkTrue(!is.neutral(m))
}

test.formula <- function() {
##   m <- load.molecules('../../../data/formulatest.mol')
##   f1 <- get.mol2formula(m[[1]]
##   checkEquals(f1@string, "C35H64N3O21P3S")
##   m <- parse.smiles("C1(C(C(C(C(C1OP(=O)(O)OCC(COC(=O)CCCCCCCNC(=O)CCCCC2SCC3C2NC(=O)N3)OC(=O)CCCCCCC)O)OP(=O)(O)O)OP(=O)(O)O)O)O")[[1]]
##   do.aromaticity(m)
##   do.typing(m)
##   do.isotopes(m)
## convert.implicit.to.explicit(m)
##   f2 <- get.mol2formula(m)
##   checkEquals(f2@string, "C35H64N3O21P3S")  
}

test.fp <- function() {
  mol <- parse.smiles("CCCCC")[[1]]
  fp <- get.fingerprint(mol, type='maccs')
  checkTrue(length(fp@bits) > 0)
  fp <- get.fingerprint(mol, type='kr')
  checkTrue(length(fp@bits) > 0)
  fp <- get.fingerprint(mol, type='shortestpath')
  checkTrue(length(fp@bits) > 0)
}

test.desc.cats <- function() {
  cats <- get.desc.categories()
  print(cats)
  checkEquals(5, length(cats))
}

test.desc.names <- function() {
  cats <- get.desc.categories()
  for (acat in cats) {
    dnames <- get.desc.names(acat)
    checkTrue(length(dnames) > 0)
  }
}

test.desc.calc <- function() {
  dnames <- get.desc.names("topological")
  mols <- parse.smiles("ccccccCCC")
  dvals <- eval.desc(mols, dnames[1])
  checkTrue(dvals[1,1] == 30)
}
