test.get.mass.atrazine <- function() {
  m <- parse.smiles("CCNC1=NC(NC(C)C)=NC(Cl)=N1")[[1]] # normal atrazine, DTXSID9020112
  f <- get.mol2formula(m)
  
  # Dashboard ref mass: 215.093773, 215.69
  #checkEquals(get.mass(m,type="total.exact"),215.0938, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),215.6835, tolerance=1e-6) #currently NPE
  checkEquals(get.mass(m,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(m,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938
  checkEquals(get.mass(m,type="molecular.weight"),215.6835, tolerance=1e-6) #215.6835
  #fails with NPE right now
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  
  ###formula testing
  checkEquals(get.mass(f,type="total.exact"),215.0938, tolerance=1e-6) 
  #checkEquals(get.mass(f,type="natural.exact"),215.6835, tolerance=1e-6) #currently returns wrong mass
  checkEquals(get.mass(f,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(f,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938 
  #checkEquals(get.mass(f,type="molecular.weight"),215.6835, tolerance=1e-6) #215.6835 # NPE
}

test.get.mass.deuterium.xchg <- function() {
  m <- parse.smiles("[2H]N(CC)C1=NC(=NC(Cl)=N1)N([2H])C(C)C")[[1]] #2H on implicit locations, DTXSID40892885
  #deuterium on exchangeable locations
  # do.aromaticity(m)
  # do.typing(m)
  # do.isotopes(m)
  # convert.implicit.to.explicit(m)
  # Dashboard ref mass: 217.106327, 217.7
  #checkEquals(get.mass(m,type="total.exact"),217.1063, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),215.6835, tolerance=1e-6) #currently NPE - have to check mass
  checkEquals(get.mass(m,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(m,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938
  checkEquals(get.mass(m,type="molecular.weight"),217.6958, tolerance=1e-6) #217.6958
  #these all fail with NPE right now
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  #checkEquals(get.exact.mass(m),217.1063, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 217.7something
}

test.get.mass.deuterium.fixed <- function() {
  m <- parse.smiles("[2H]C([2H])([2H])C([2H])([2H])NC1=NC(Cl)=NC(NC(C)C)=N1")[[1]] # #d5, DTXSID20486781
  #deuterium on fixed locations
  # Dashboard ref mass: 220.125157, 220.72
  #checkEquals(get.mass(m,type="total.exact"),220.1252, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),215.6835, tolerance=1e-6) #currently NPE - have to check mass
  checkEquals(get.mass(m,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(m,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938
  checkEquals(get.mass(m,type="molecular.weight"),220.7143, tolerance=1e-6) #217.6958
  #these fail with NPE right now
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  #checkEquals(get.exact.mass(m),220.1252, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 220.7something
}  

test.get.mass.atrazine15N <- function() {
  m <- parse.smiles("CC[15NH]C1=NC(NC(C)C)=NC(Cl)=N1")[[1]] #15N DTXSID40583908
  #15N-atrazine
  # Dashboard ref mass: 216.090808, 216.68
  #checkEquals(get.mass(m,type="total.exact"),216.0908, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),215.6835, tolerance=1e-6) #currently NPE - have to check mass
  checkEquals(get.mass(m,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(m,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938
  checkEquals(get.mass(m,type="molecular.weight"),216.6769, tolerance=1e-6) #217.6958
  # these all fail with NPE right now
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  #checkEqualsNumeric(get.exact.mass(m),216.0908, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),215.6835) #this is wrong! It should be 216.68something
}

test.get.mass.pentabromophenol<- function() {
  m <- parse.smiles("OC1=C(Br)C(Br)=C(Br)C(Br)=C1Br")[[1]] #pentabromophenol, DTXSID9022079
  #pentabromophenol, DTXSID9022079 - tricky as lots of Br shifts pattern
  # Dashboard ref mass: 483.59443, 488.593
  #checkEquals(get.mass(m,type="total.exact"),483.5944, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),488.5894, tolerance=1e-6) #currently NPE - have to check mass
  checkEquals(get.mass(m,type="mass.number"),484, tolerance=1e-6) 
  checkEquals(get.mass(m,type="major.isotope"),483.5944, tolerance=1e-6) 
  checkEquals(get.mass(m,type="molecular.weight"),488.5894, tolerance=1e-6) 
  #these all fail with NPE right now ... 
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  #checkEquals(get.exact.mass(m),483.5944, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),488.5894, tolerance=1e-6) 
  
}
test.get.mass.selenium <- function() {
  m <- parse.smiles("C[Se]CC[C@H](N)C(O)=O")[[1]] # Selenium-L-methionine, DTXSID8046824
  # Dashboard ref mass: 196.995501, 196.119
  #checkEquals(get.mass(m,type="total.exact"),196.9955, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),196.1059, tolerance=1e-6) #currently NPE - have to check mass
  checkEquals(get.mass(m,type="mass.number"),197, tolerance=1e-6) 
  checkEquals(get.mass(m,type="major.isotope"),196.9955, tolerance=1e-6) #correct
  checkEquals(get.mass(m,type="molecular.weight"),196.1059, tolerance=1e-6) 
  #these all fail with NPE right now ... 
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  #checkEquals(get.exact.mass(m),196.9955, tolerance=1e-6)
  #checkEquals(get.natural.mass(m),196.1059, tolerance=1e-6) #quite a discrepancy in ref value
  
  #formula checks on benzene
  checkEquals(get.mass(get.formula("C6H6"),type="total.exact"),78.04695, tolerance=1e-6) 
  #wrong, these two below should be Average Mass: 78.114 g/mol
  #checkEquals(get.mass(get.formula("C6H6"),type="natural.exact"),78.04695, tolerance=1e-6) 
  #checkEquals(get.mass(get.formula("C6H6"),type="molecular.weight"),78.114, tolerance=1e-6) #NPE
  checkEquals(get.mass(get.formula("C6H6"),type="mass.number"),78, tolerance=1e-6) 
  checkEquals(get.mass(get.formula("C6H6"),type="major.isotope"),78.04695, tolerance=1e-6) 
}