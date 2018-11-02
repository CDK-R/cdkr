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
    
    manipulator <- get("mfManipulator", envir = .rcdk.GlobalEnv)
    if(!is.character(mf)) {
        stop("Must supply a Formula string");
    }else{
        dcob <- .cdkFormula.createChemObject()
        molecularformula <- .cdkFormula.createFormulaObject()
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
    if(attr(molecule, "jclass") != "org/openscience/cdk/interfaces/IAtomContainer") {
        stop("Must supply an IAtomContainerobject")
    }
    
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
set.charge.formula <- function(formula,charge = -1) {
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

    nRule <- get("nRule", envir = .rcdk.GlobalEnv)
    rdbeRule <- get("rdbeRule", envir = .rcdk.GlobalEnv)

    for(i in 1:length(rule)){
        ##Nitrogen Rule
        if(rule[i] == "nitrogen"){
            valid <- .jcall(nRule,"D","validate",molecularFormula);
            if(valid != 1.0){
                return (FALSE)
            }
        }	  
        ##RDBE Rule
        if(rule[i] == "RDBE"){
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

generate.formula.iter <- function(mass, window = 0.01,
                                  elements = list(
                                      c('C', 0,50),
                                      c('H', 0,50),
                                      c('N', 0,50),
                                      c('O', 0,50),
                                      c('S', 0,50)),
                                  validation = FALSE,
                                  charge = 0.0,
                                  as.string=TRUE) {

    mfRange <- .jnew("org/openscience/cdk/formula/MolecularFormulaRange");
    ifac <- .jcall("org/openscience/cdk/config/Isotopes",
                   "Lorg/openscience/cdk/config/Isotopes;",
                   "getInstance");
    for (i in 1:length(elements)) {
      
      ## If the element list is 3, then we have sym, min, max
      ## otherwise it should be sym, min, max, massNumber
      if (length(elements[[i]]) == 3) {
        isotope <- .jcall(ifac,
                          "Lorg/openscience/cdk/interfaces/IIsotope;",
                          "getMajorIsotope",
                          as.character( elements[[i]][1] ), use.true.class=FALSE)
      } else if(length(elements[[i]]) == 4) {
        isotope <- .jcall(ifac,
                          "Lorg/openscience/cdk/interfaces/IIsotope;",
                          "getIsotope",
                          as.character( elements[[i]][1] ),
                          as.integer( elements[[i]][4] ),
                          use.true.class=FALSE)
        if (is.null(isotope)) stop(sprintf("Invalid mass number specified for element %s",elements[[i]][1]))
      } else stop("Elements must be 3-tuples or 4-tuples")

      .jcall(mfRange,
             returnSig="V",
             method="addIsotope",
             isotope,
             as.integer( elements[[i]][2] ),
             as.integer( elements[[i]][3] )
             )
      
    }

    ## Construct range strings
    ## rstrs <- sapply(names(elements), function(x) paste0(c(x, elements[[x]][1], elements[[x]][2]), sep='', collapse=' '))
    ## if (length(rstrs) == 0)
    ##     warning("The element specification resulted in a 0 length vector. This is worrisome")
    
    ## ## Get MF range object
    ## mfRange <- .jcall("org/guha/rcdk/util/Misc",
    ##                   "Lorg/openscience/cdk/formula/MolecularFormulaRange;",
    ##                   "getMFRange",
    ##                   .jarray(rstrs))
    
    ## construct generator
    mfgen <- .jnew("org/openscience/cdk/formula/RoundRobinFormulaGenerator",
                   get("dcob", envir = .rcdk.GlobalEnv),
                   as.double(mass-window),
                   as.double(mass+window),
                   mfRange)

    hasNext <- NA
    formula <- NA
    
    ## hasNx <- function() {
    ##   hasNext <<- .jcall(mfgen, "Lorg/openscience/cdk/interfaces/IMolecularFormula;", "getNextFormula")
    ##   if (is.jnull(hasNext)) {
    ##     ## nothing to do
    ##     formula <<- NA
    ##   } else formula <<- hasNext
    ##   return(!is.jnull(hasNext))
    ## }
    
    nextEl <- function() {
        hasNext <<- NA
        formula <- .jcall(mfgen, "Lorg/openscience/cdk/interfaces/IMolecularFormula;", "getNextFormula")
        if (is.jnull(formula)) stop("StopIteration")
        if (!as.string) {
            return(formula)
        } else {
            return(.jcall("org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator",
                          "S", "getString", formula, FALSE, TRUE))
        }
    }

    ##obj <- list(nextElem = nextEl, hasNext = hasNx)
    obj <- list(nextElem = nextEl)  
    class(obj) <- c("generate.formula2", "abstractiter", "iter")
    return(obj)
}

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
    ifac <- .jcall("org/openscience/cdk/config/Isotopes",
                   "Lorg/openscience/cdk/config/Isotopes;",
                   "getInstance");

    for (i in 1:length(elements)) {

        ## If the element list is 3, then we have sym, min, max
        ## otherwise it should be sym, min, max, massNumber
        if (length(elements[[i]]) == 3) {
            isotope <- .jcall(ifac,
                              "Lorg/openscience/cdk/interfaces/IIsotope;",
                              "getMajorIsotope",
                              as.character( elements[[i]][1] ), use.true.class=FALSE)
        } else if(length(elements[[i]]) == 4) {
            isotope <- .jcall(ifac,
                              "Lorg/openscience/cdk/interfaces/IIsotope;",
                              "getIsotope",
                              as.character( elements[[i]][1] ),
                              as.integer( elements[[i]][4] ),
                              use.true.class=FALSE)
            if (is.null(isotope)) stop(sprintf("Invalid mass number specified for element %s",elements[[i]][1]))
        } else stop("Elements must be 3-tuples or 4-tuples")

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
    if (is.null(mfSet))
        return(list())

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
            ecList[[count]] = object;
            count = count+1;
        }
    }
    ecList
}


#############################################################
##  Intern functions: Creating object
#############################################################

.cdkFormula.createChemObject <- function(){
    get("dcob", envir = .rcdk.GlobalEnv)
                                        #  dcob <- .jcall("org/openscience/cdk/DefaultChemObjectBuilder",
                                        #                 "Lorg/openscience/cdk/interfaces/IChemObjectBuilder;",
                                        #                 "getInstance")
                                        #  dcob
}

.cdkFormula.createFormulaObject <- function(){
    ##   dcob <- .cdkFormula.createChemObject()
    ##   klass <- J("org.openscience.cdk.interfaces.IMolecularFormula")$class
    ##   cfob <- .jcall(dcob,
    ##                  "Lorg/openscience/cdk/interfaces/ICDKObject;",
    ##                  "newInstance",
    ##                  klass
    ##                  );  
    ##   cfob
    .jcast(.jnew("org/openscience/cdk/formula/MolecularFormula"),
           "org/openscience/cdk/interfaces/IMolecularFormula")
}

#############################################################
## extract the molecular formula string form the java object
#############################################################
.cdkFormula.getString <- function(molecularFormula) {
    
    if (attr(molecularFormula, "jclass") != 'org/openscience/cdk/interfaces/IMolecularFormula') {
        stop("Supplied object should be a Java reference to an IMolecularFormula")
    }
    formula <- .jcall('org/openscience/cdk/tools/manipulator/MolecularFormulaManipulator',
                      'S', 'getString', molecularFormula)
}

#############################################################
## create a formula class from the molecularFormula java object
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
        #massNum          <- .jcall(isotope,"Ljava/lang/Double;","getMassNumber");
        massNum          <-  isotope$getMassNumber()
        #exactMass        <- .jcall(isotope,"Ljava/lang/Double;","getExactMass");
        exactMass        <- isotope$getExactMass()
        print(exactMass)
        isotopes         <- J("org/openscience/cdk/config/Isotopes")
        
        if (is.null(massNum)) {
         
          isos         <- isotopes$getInstance()
          majorIsotope <- isos$getMajorIsotope(isotope$getSymbol())
          
          if (!is.null(majorIsotope)) {
            
            exactMass <- majorIsotope$getExactMass()
          }
        } else {
          
          if (is.null(exactMass)) {
            isos    <- isotopes$getInstance()
            temp    <- isos$getIsotope(isotope$getSymbol(), massNum);
            
            if (!is.null(temp)) {
              exactMass <- temp$getExactMass()
            }
          }
        }
        
        #ch <- .jcall(isotope,"Ljava/lang/Double;","getExactMass");
        isotopeList[i,3] <- exactMass
    }
    
    object@string <- .cdkFormula.getString(molecularformula);
    manipulator <- get("mfManipulator", envir = .rcdk.GlobalEnv)
    cMass <- .jcall(manipulator,"D","getTotalExactMass",molecularformula);
    object@mass <- cMass;
    chargeDO <- .jcall(molecularformula,"Ljava/lang/Integer;","getCharge");
    charge <- .jcall(chargeDO,"D","doubleValue");
    object <- set.charge.formula(object,charge)
    object@isotopes <- isotopeList;
    
    return(object);
}

#' Construct an isotope pattern similarity calculator.
#'
#' A method that returns an instance of the CDK \code{IsotopePatternSimilarity}
#' class which can be used to compute similarity scores between pairs of
#' isotope abundance patterns.
#'
#' @param tol The tolerance
#' @return A \code{jobjRef} corresponding to an instance of \code{IsotopePatternSimilarity}
#' @seealso \code{\link{compare.isotope.pattern}}
#' @references \url{http://cdk.github.io/cdk/1.5/docs/api/org/openscience/cdk/formula/IsotopePatternSimilarity.html}
#' @author Miguel Rojas Cherto
get.isotope.pattern.similarity <- function(tol = NULL) {
    ips <- .jnew("org/openscience/cdk/formula/IsotopePatternSimilarity")
    if (!is.null(tol)) ips$seTolerance(tol)
    return(ips)
}

#' Construct an isotope pattern generator.
#'
#' Constructs an instance of the CDK \code{IsotopePatternGenerator}, with an optional
#' minimum abundance specified. This object can be used to generate all combinatorial
#' chemical isotopes given a structure.
#'
#' @param minAbundance The minimum abundance
#' @return A \code{jobjRef} corresponding to an instance of \code{IsotopePatternGenerator}
#' @references \url{http://cdk.github.io/cdk/1.5/docs/api/org/openscience/cdk/formula/IsotopePatternGenerator.html}
#' @author Miguel Rojas Cherto
get.isotope.pattern.generator <- function(minAbundance = NULL) {
    if (is.null(minAbundance))
        .jnew("org/openscience/cdk/formula/IsotopePatternGenerator")
    else
        .jnew("org/openscience/cdk/formula/IsotopePatternGenerator", as.double(minAbundance))
}

#' Compare isotope patterns.
#'
#' Computes a similarity score between two different isotope abundance patterns.
#'
#' @param iso1 The first isotope pattern, which should be a \code{jobjRef} corresponding to the \code{IsotopePattern} class
#' @param iso2 The second isotope pattern, which should be a \code{jobjRef} corresponding to the \code{IsotopePattern} class
#' @param ips An instance of the \code{IsotopePatternSimilarity} class. if \code{NULL} one will be constructed automatically
#'
#' @return A numeric value between 0 and 1 indicating the similarity between the two patterns
#' @seealso \code{\link{get.isotope.pattern.similarity}}
#' @references \url{http://cdk.github.io/cdk/2.0/docs/api/org/openscience/cdk/formula/IsotopePatternSimilarity.html}
#' @author Miguel Rojas Cherto
compare.isotope.pattern <- function(iso1, iso2, ips = NULL) {
    cls <- unique(c(class(iso1), class(iso2)))
    if (length(cls) != 1) stop("Must supply Java objects of class IsotopePattern")
    if (cls != 'jobjRef') stop("Must supply Java objects of class IsotopePattern")
    if(attr(iso1, "jclass") != "org/openscience/cdk/formula/IsotopePattern" ||
       attr(iso2, "jclass") != "org/openscience/cdk/formula/IsotopePattern") {
        stop("Must supply an IsotopePattern")
    }
    if (is.null(ips)) ips <- get.isotope.pattern.similarity()
    return(ips$compare(iso1, iso2))
}
