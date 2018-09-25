test.documentation_bug.aromaticity_detection <- function() {
    # In the documentation the function 'do.aromaticity' is called before the
    # 'do.typing' function. Aromaticity is not detected in that way. 
    
    # Aromatic ring molecule
    m <- parse.smiles('c1ccccc1')[[1]] 
    checkTrue(! do.aromaticity(m))
    
    # Aromatic ring molecule
    m <- parse.smiles('c1ccccc1')[[1]] 
    do.typing(m)
    checkTrue(do.aromaticity(m))
}
