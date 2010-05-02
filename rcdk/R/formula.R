########################################################
##  set a cdkFormula function   
.IMolecularFormula <- "org/openscience/cdk/interfaces/IMolecularFormula"

setClass("cdkFormula", representation(mass = "numeric",
                                      objectJ = "jobjRef",
                                      string = "character",
                                      charge = "numeric",
                                      isotopes = "matrix"),
         prototype(mass = 0,
                   objectJ = NULL,
                   string = character(0),
                   charge = 0,
                   isotopes = matrix(nrow = 0, ncol = 0))
         )

########################################################
##  create a cdkFormula function from the characters   

get.formula <- function(mf, charge=0) {
  
  manipulator <- .jnew("org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator");
  if(!is.character(mf)) {
    stop("Must supply a Formula string");
  }else{
    dcob <- .cdkFormula.createChemObject()
    molecularformula <- .jcall(dcob,"Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                               "newMolecularFormula");
##    molecularformula <- .jcast(.jnew("org/openscience/cdk/formula/MolecularFormula"),
##                               "org/openscience/cdk/interfaces/IMolecularFormula")
    molecularFormula <- .jcall(manipulator,
                               "Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                               "getMolecularFormula",
                               mf,
                               .jcast(molecularformula,.IMolecularFormula),
                               TRUE);
  }
  
  D <- new(J("java/lang/Integer"), as.integer(charge))
  .jcall(molecularFormula,"V","setCharge",D);
  object <- .cdkFormula.createObject(.jcast(molecularFormula,.IMolecularFormula));
  return(object);
}

setMethod("show", "cdkFormula",
          function(object) {
            cat('cdkFormula: ',object@string,
                ', mass = ',object@mass, ', charge = ',
                object@charge,  '\n')
          })
########################################################
##  Set the charge to a cdkFormula function.
########################################################
get.mol2formula <- function(molecule, charge=0) {
  if(((attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IMolecule") ||
      (attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") )== FALSE) {
    stop("Must supply an IAtomContainer or IMolecule object")
  }
  if(attr(molecule, "jclass") == "org/openscience/cdk/interfaces/IMolecule")
    molecule <-.jcast(molecule, "org/openscience/cdk/interfaces/IAtomContainer")
  
  formulaJ <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                     "Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                     "getMolecularFormula",
                     molecule, use.true.class=FALSE);
  formulaJ <- .jcast(formulaJ,"org/openscience/cdk/interfaces/IMolecularFormula")
  
  ## needs that all isotopes contain the properties
  string <- .cdkFormula.getString(formulaJ)
  objectF <- .cdkFormula.createFormulaObject()
  moleculaJT <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                       "Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                       "getMolecularFormula",string,
                       .jcast(objectF,"org/openscience/cdk/interfaces/IMolecularFormula"),TRUE);
  
  Do <- new(J("java/lang/Integer"), as.integer(charge))
  .jcall(moleculaJT,"V","setCharge",Do);	   

  formula <- .cdkFormula.createObject(.jcast(moleculaJT,.IMolecularFormula))
  return(formula);
}
########################################################
##  Set the charge to a cdkFormula function.
########################################################
set.charge.formula <- function(formula,charge) {
  if (class(formula) != "cdkFormula")
    stop("Supplied object should be a cdkFormula Class")
  
  molecularFormula <- formula@objectJ;
  
  D <- new(J("java/lang/Integer"), as.integer(charge))
  .jcall(molecularFormula,"V","setCharge",D);
  
  formula@objectJ <- molecularFormula;
  formula@charge <- charge;
  
  return(formula)
}

########################################################
##  Validate a cdkFormula.
########################################################

isvalid.formula <- function(formula,rule=c("nitrogen","RDBE")){
  
  if (class(formula) != "cdkFormula")
    stop("Supplied object should be a cdkFormula Class")
  
  molecularFormula <- formula@objectJ;
  
  for(i in 1:length(rule)){
    ##Nitrogen Rule
    if(rule[i] == "nitrogen"){
      nRule <- .jnew("org/openscience/cdk/formula/rules/NitrogenRule");
      valid <- .jcall(nRule,"D","validate",molecularFormula);
      
      if(valid != 1.0){
        return (FALSE)
      }
    }	  
    ##RDBE Rule
    if(rule[i] == "RDBE"){
      rdbeRule <- .jnew("org/openscience/cdk/formula/rules/RDBERule");
      valid <- .jcall(rdbeRule,"D","validate",molecularFormula);
      
      if(valid != 1.0){
        return (FALSE)
      }
      else return(TRUE);
    }
  }
  return(TRUE);
}

#############################################################
##  Generate the isotope pattern given a formula class
#############################################################
get.isotopes.pattern <- function(formula,minAbund=0.1){
  
  if (class(formula) != "cdkFormula")
    stop("Supplied object should be a cdkFormula Class")
  
  molecularFormula <- formula@objectJ;
  
  isoGen <- .jnew("org/openscience/cdk/formula/IsotopePatternGenerator",as.double(minAbund));
  isoPattern <- .jcall(isoGen,
                       "Lorg/openscience/cdk/formula/IsotopePattern;",
                       "getIsotopes",molecularFormula);
  numIP <- .jcall(isoPattern,"I","getNumberOfIsotopes");
  
  ## create a matrix adding the mass and abundance of the isotope pattern
  iso.col <- c("mass","abund");
  
  massVSabun <- matrix(ncol=2,nrow=numIP);
  colnames(massVSabun)<-iso.col;
  for (i in 1:numIP) {
    isoContainer <- .jcall(isoPattern,"Lorg/openscience/cdk/formula/IsotopeContainer;","getIsotope",as.integer(i-1));
    massVSabun[i,1] <- .jcall(isoContainer,"D","getMass");
    massVSabun[i,2] <- .jcall(isoContainer,"D","getIntensity");
  }
  return (massVSabun);
}

########################################################
##  Generate a list of possible formula objects given a mass and 
##  a mass tolerance.
########################################################

generate.formula <- function(mass, window=0.01, 
                             elements=list(c("C",0,50),c("H",0,50),c("N",0,50),c("O",0,50),c("S",0,50)), 
                             validation=FALSE, charge=0.0){
  
  builder <- .cdkFormula.createChemObject();
  mfTool <- .jnew("org/openscience/cdk/formula/MassToFormulaTool",builder);
  ruleList <-.jcast(.jcall("org/guha/rcdk/formula/FormulaTools",
                           "Ljava/util/List;",
                           "createList"), "java/util/List")
  
  ## TOLERANCE RULE
  toleranceRule <- .jnew("org/openscience/cdk/formula/rules/ToleranceRangeRule");
  ruleG <- .jcast(toleranceRule, "org/openscience/cdk/formula/rules/IRule");
  D <- new(J("java/lang/Double"), window)
  paramsA <- .jarray(list(D,D))
  paramsB <- .jcastToArray(paramsA)
  .jcall(ruleG,"V","setParameters",paramsB);
  ruleList <-.jcall("org/guha/rcdk/formula/FormulaTools", "Ljava/util/List;", "addTo",ruleList,ruleG)
  
  
  ## ELEMENTS RULE
  elementRule <- .jnew("org/openscience/cdk/formula/rules/ElementRule");
  ruleG <- .jcast(elementRule, "org/openscience/cdk/formula/rules/IRule");
  
  chemObject <- .cdkFormula.createChemObject();
  range <- .jnew("org/openscience/cdk/formula/MolecularFormulaRange");
  ifac <- .jcall("org/openscience/cdk/config/IsotopeFactory",
                 "Lorg/openscience/cdk/config/IsotopeFactory;",
                 "getInstance",chemObject);
  
  for (i in 1:length(elements)) {
    isotope <- .jcall(ifac,
                      "Lorg/openscience/cdk/interfaces/IIsotope;",
                      "getMajorIsotope",
                      as.character( elements[[i]][1] ), use.true.class=FALSE)
    .jcall(range,
           returnSig="V",
           method="addIsotope",
           isotope,
           as.integer( elements[[i]][2] ),
           as.integer( elements[[i]][3] )
           )
  }
  
  paramsA <- .jarray(list(range))
  paramsB <- .jcastToArray(paramsA)
  .jcall(ruleG,"V","setParameters",paramsB);
  
  ruleList <-.jcall("org/guha/rcdk/formula/FormulaTools",
                    "Ljava/util/List;", "addTo",
                    .jcast(ruleList,"java/util/List"),
                    ruleG)
  
  ## Setting the rules int FormulaTools
  .jcall(mfTool,"V","setRestrictions",.jcast(ruleList,"java/util/List"));
  
  mfSet <- .jcall(mfTool,"Lorg/openscience/cdk/interfaces/IMolecularFormulaSet;",
                  "generate",mass);
  sizeSet <- .jcall(mfSet,"I","size");
  ecList <- list();
  count = 1;
  
  for (i in 1:sizeSet) {
    mf <- .jcall(mfSet,
                 "Lorg/openscience/cdk/interfaces/IMolecularFormula;",
                 "getMolecularFormula",
                 as.integer(i-1));

    .jcall(mf,"V","setCharge",new(J("java/lang/Integer"), as.integer(charge)));
    object <- .cdkFormula.createObject(.jcast(mf,
                                              "org/openscience/cdk/interfaces/IMolecularFormula"));
    
    isValid = TRUE;
    if(validation==TRUE)
      isValid = isvalid.formula(object);
    
    if(isValid==TRUE){ ## if it's true add to the list
      ecList[count] = object;
      count = count+1;
    }
  }
  ecList
}


#############################################################
##  Intern functions: Creating object
#############################################################

.cdkFormula.createChemObject <- function(){
  dcob <- .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                 "Lorg/openscience/cdk/DefaultChemObjectBuilder;",
                 "getInstance")
  dcob <- .jcast(dcob, "org/openscience/cdk/interfaces/IChemObjectBuilder")  
  dcob
}
.cdkFormula.createFormulaObject <- function(){
  dcob <- .cdkFormula.createChemObject()
  cfob <- .jcall(dcob,"Lorg/openscience/cdk/interfaces/IMolecularFormula;","newMolecularFormula");  
  cfob
##  .jcast(.jnew("org/openscience/cdk/formula/MolecularFormula"),
##         "org/openscience/cdk/interfaces/IMolecularFormula")
}

#############################################################
                                        # extract the molecular formula string form the java object
#############################################################
.cdkFormula.getString <- function(molecularFormula) {
  
  if (attr(molecularFormula, "jclass") != 'org/openscience/cdk/interfaces/IMolecularFormula') {
    stop("Supplied object should be a Java reference to an IMolecularFormula")
  }
  formula <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                    'S', 'getString', molecularFormula)
}

#############################################################
                                        # create a formula class from the molecularFormula java object
#############################################################
.cdkFormula.createObject <- function(molecularformula){
  
  object <-new("cdkFormula")
  
  object@objectJ <- molecularformula;
  iterable <- .jcall(molecularformula,"Ljava/lang/Iterable;","isotopes"); 
  isoIter <- .jcall(iterable,"Ljava/util/Iterator;","iterator");
  size <- .jcall(molecularformula,"I","getIsotopeCount");
  isotopeList = matrix(ncol=3,nrow=size);
  colnames(isotopeList) <- c("isoto","number","mass");
  for(i in 1:size){
    isotope = .jcast(.jcall(isoIter,"Ljava/lang/Object;","next"), "org/openscience/cdk/interfaces/IIsotope");
    isotopeList[i,1] <- .jcall(isotope,"S","getSymbol");
    isotopeList[i,2] <- .jcall(molecularformula,"I","getIsotopeCount",isotope);
    ch <- .jcall(isotope,"Ljava/lang/Double;","getExactMass");
    isotopeList[i,3] <- .jcall(ch,"D","doubleValue");
  }
  
  object@string <- .cdkFormula.getString(molecularformula);
  manipulator <- .jnew("org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator");
  cMass <- .jcall(manipulator,"D","getTotalExactMass",molecularformula);
  object@mass <- cMass;
  chargeDO <- .jcall(molecularformula,"Ljava/lang/Integer;","getCharge");
  charge <- .jcall(chargeDO,"D","doubleValue");
  object <- set.charge.formula(object,charge)
  object@isotopes <- isotopeList;
  
  return(object);
}
