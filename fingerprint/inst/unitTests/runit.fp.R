test.new.fp <- function()
{
  fp <- new("fingerprint", bits=c(1,2,3,4), nbit=8, provider='rg',name='foo')
  checkTrue(!is.null(fp))
}

test.distance1 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(5,6,7,8), nbit=8)
  d <- distance(fp1,fp2)
  checkEquals(d, 0)
}

test.distance2 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  d <- distance(fp1,fp2)
  checkEquals(d, 1)
}

test.and1 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fpnew <- fp1 & fp2
  bits <- fpnew@bits
  checkTrue( all(bits == c(1,2,3,4)))
}
test.and2 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(5,6,7,8), nbit=8)
  fpnew <- fp1 & fp2
  bits <- fpnew@bits
  checkEquals(length(bits),0)
}

test.or1 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(5,6,7,8), nbit=8)
  fpnew <- fp1 | fp2
  bits <- fpnew@bits
  checkTrue(all(bits == c(1,2,3,4,5,6,7,8)))
}
test.or2 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fpnew <- fp1 | fp2
  bits <- fpnew@bits
  checkTrue(all(bits == c(1,2,3,4)))
}

test.not <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  nfp1 <- !fp1
  checkTrue(all(nfp1@bits == c(5,6,7,8)))
  checkTrue(all(fp1@bits == (!nfp1)@bits))
}

test.xor1 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fpnew <- xor(fp1,fp2)
  bits <- fpnew@bits
  checkEquals(length(bits),0)
}
test.xor2 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  fp2 <- new("fingerprint",
             bits=c(5,6,7,8), nbit=8)
  fpnew <- xor(fp1,fp2)
  bits <- fpnew@bits
  checkEquals(length(bits),8)
  checkTrue(all(bits == c(1,2,3,4,5,6,7,8)))
}

test.fold1 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4), nbit=8)
  nfp <- fold(fp1)
  checkTrue(all(nfp@bits == c(1,2,3,4)))
}

test.fold2 <- function() {
  fp1 <- new("fingerprint",
             bits=c(1,2,3,4,8), nbit=8)
  nfp <- fold(fp1)
  checkTrue(all(nfp@bits == c(1,2,3,4)))
}

test.fp.to.matrix <- function() {
    fp1 <- new("fingerprint", bits=c(1,2,3,4), nbit=8)
    fp2 <- new("fingerprint", bits=c(5,6,7,8), nbit=8)
    fp3 <- new("fingerprint", bits=c(1,2,3,5,6,7,8), nbit=8)
    m1 <- fp.to.matrix(list(fp1,fp2,fp3))
    m2 <- rbind(c(1,1,1,1,0,0,0,0),
                c(0,0,0,0,1,1,1,1),
                c(1,1,1,0,1,1,1,1))
    checkTrue(all(m1 == m2))
}

test.fp.sim.matrix <- function() {
    fp1 <- new("fingerprint", bits=c(1,2,3,4), nbit=8)
    fp2 <- new("fingerprint", bits=c(5,6,7,8), nbit=8)
    fp3 <- new("fingerprint", bits=c(1,2,3,5,6,7,8), nbit=8)
    fpl <- list(fp1,fp2,fp3)
    sm <- round(fp.sim.matrix(fpl),2)
    am <- rbind(c(1,0,0.38),
                c(0,1,0.57),
                c(0.38,0.57,1))
    checkTrue(all(sm == am))
}

test.fp.balance <- function() {
  fp1 <- new("fingerprint", bits=c(1,2,3), nbit=6)  
  fp2 <- balance(fp1)
  checkEquals(12, length(fp1))
  checkEquals(c(1,2,3,10,11,12), fp2@bits)
}
