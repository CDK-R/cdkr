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
  mols <- parse.smiles("c1ccccc1CCC")
  dvals <- eval.desc(mols, dnames[1])
  checkTrue(dvals[1,1] == 1)
}

test.exact.natural.mass <- function() {
  smiles <- c("CCNC1=NC(NC(C)C)=NC(Cl)=N1", # normal atrazine, DTXSID9020112
              "[2H]N(CC)C1=NC(=NC(Cl)=N1)N([2H])C(C)C", #2H on implicit locations, DTXSID40892885
              "[2H]C([2H])([2H])C([2H])([2H])NC1=NC(Cl)=NC(NC(C)C)=N1", #d5, DTXSID20486781
              "CC[15NH]C1=NC(NC(C)C)=NC(Cl)=N1", #15N DTXSID40583908
              "OC1=C(Br)C(Br)=C(Br)C(Br)=C1Br", #pentabromophenol, DTXSID9022079
              "C[Se]CC[C@H](N)C(O)=O" # Selenium-L-methionine, DTXSID8046824
  ) 
  #atrzine
  m <- parse.smiles(smiles[1])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 215.093773, 215.69
  checkEquals(get.exact.mass(m),215.0938, tolerance=1e-6)
  checkEquals(get.natural.mass(m),215.6835, tolerance=1e-6)
  
  #deuterium on exchangeable locations
  m <- parse.smiles(smiles[2])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 217.106327, 217.7
  checkEquals(get.exact.mass(m),217.1063, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 217.7something
  
  #deuterium on fixed locations
  m <- parse.smiles(smiles[3])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 220.125157, 220.72
  checkEquals(get.exact.mass(m),220.1252, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 220.7something
  
  #15N-atrazine
  m <- parse.smiles(smiles[4])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 216.090808, 216.68
  checkEqualsNumeric(get.exact.mass(m),216.0908, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 216.68something
  
  #pentabromophenol, DTXSID9022079 - tricky as lots of Br shifts pattern
  m <- parse.smiles(smiles[5])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 483.59443, 488.593
  checkEquals(get.exact.mass(m),483.5944, tolerance=1e-6)
  checkEquals(get.natural.mass(m),488.5894, tolerance=1e-6) 
  
  # Selenium-L-methionine, DTXSID8046824 - tricky as Se primary isotope not lowest mass
  m <- parse.smiles(smiles[6])[[1]]
  do.aromaticity(m)
  do.typing(m)
  do.isotopes(m)
  convert.implicit.to.explicit(m)
  # Dashboard ref mass: 196.995501, 196.119
  checkEquals(get.exact.mass(m),196.9955, tolerance=1e-6)
  checkEquals(get.natural.mass(m),196.1059, tolerance=1e-6) #quite a discrepancy in ref value
  
  
}

