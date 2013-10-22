##Fast Tanimoto calculation
ptm <- proc.time()
mat<-m%*%t(m)
len<-length(m[,1])
s<-mat.or.vec(len,len)

for (i in 1:len){
  for (j in 1:len){
    s[i,j]<- mat[i,j]/(mat[i,i]+mat[j,j]-mat[i,j])
  }
}
proc.time() - ptm
Time taken 
##user  system elapsed 
##2.962   0.012   2.971 

## Here is for rcdk tanimoto code i guess default is tanimoto.

ptm <- proc.time()
fpsim<-fp.sim.matrix(fps)
proc.time() - ptm

#user  system elapsed 
#43.644   0.064  43.707 
