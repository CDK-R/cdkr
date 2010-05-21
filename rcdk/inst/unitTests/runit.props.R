test.set.props <- function() {
  m <- parse.smiles("CCCC")[[1]]
  set.property(m, "foo", "bar")
  checkEquals(get.property(m,"foo"), "bar")
}

test.get.properties <- function() {
  m <- parse.smiles("CCCC")[[1]]
  set.property(m, "foo", "bar")
  set.property(m, "baz", 1.23)  
  props <- get.properties(m)
  checkEquals(length(props), 2)
  checkTrue(all(sort(names(props)) == c('baz','foo')))
  checkEquals(props$foo,'bar')
  checkEquals(props$baz,1.23)  
}
