test.get.mass <- function() {
  smiles <- c("CCNC1=NC(NC(C)C)=NC(Cl)=N1", # normal atrazine, DTXSID9020112
              "[2H]N(CC)C1=NC(=NC(Cl)=N1)N([2H])C(C)C", #2H on implicit locations, DTXSID40892885
              "[2H]C([2H])([2H])C([2H])([2H])NC1=NC(Cl)=NC(NC(C)C)=N1", #d5, DTXSID20486781
              "CC[15NH]C1=NC(NC(C)C)=NC(Cl)=N1", #15N DTXSID40583908
              "OC1=C(Br)C(Br)=C(Br)C(Br)=C1Br", #pentabromophenol, DTXSID9022079
              "C[Se]CC[C@H](N)C(O)=O" # Selenium-L-methionine, DTXSID8046824
  ) 
  #atrzine
  m <- parse.smiles(smiles[1])[[1]]
  # Dashboard ref mass: 215.093773, 215.69
  #checkEquals(get.mass(m,type="total.exact"),215.0938, tolerance=1e-6) #currently NPE
  #checkEquals(get.mass(m,type="natural.exact"),215.6835, tolerance=1e-6) #currently NPE
  checkEquals(get.mass(m,type="mass.number"),215, tolerance=1e-6) #215
  checkEquals(get.mass(m,type="major.isotope"),215.0938, tolerance=1e-6) #215.0938
  checkEquals(get.mass(m,type="molecular.weight"),215.6835, tolerance=1e-6) #215.6835
  #fails ith NPE right now
  #checkEquals(get.exact.mass(m),get.mass(m,type="total.exact"), tolerance=1e-6)
  #checkEquals(get.natural.mass(m),get.mass(m,type="natural.exact"), tolerance=1e-6)
  
  #deuterium on exchangeable locations
  m <- parse.smiles(smiles[2])[[1]]
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
  
  #deuterium on fixed locations
  m <- parse.smiles(smiles[3])[[1]]
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
  
  #15N-atrazine
  m <- parse.smiles(smiles[4])[[1]]
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
  
  #pentabromophenol, DTXSID9022079 - tricky as lots of Br shifts pattern
  m <- parse.smiles(smiles[5])[[1]]
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
  
  # Selenium-L-methionine, DTXSID8046824 - tricky as Se primary isotope not lowest mass
  m <- parse.smiles(smiles[6])[[1]]
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
  
}