#include <R.h>
#include <Rinternals.h>

/* Bulk of the code provided by Andrew Dalke, modified
   by me to be usable from R */

int bit_is_on(char*,int);

#define charmask(c)          ((unsigned char)((c) & 0xff))

static int to_int(int c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  }
  if (c >= 'A' && c <= 'F') {
    return c - 'A' + 10;
  }
  if (c >= 'a' && c <= 'f') {
    return c - 'a' + 10;
  }
  return -1;
}


SEXP parse_hex(SEXP hexstr, SEXP hexlen) {
   int i,j;
  const char *argbuf;
  int arglen; 

  argbuf = (const char*) CHAR(STRING_ELT(hexstr,0));
  arglen = INTEGER(hexlen)[0];
  
  char* retbuf = (char*) R_alloc(arglen/2, sizeof(char));
  for (i=j=0; i < arglen; i += 2) {
    int top = to_int(charmask(argbuf[i]));
    int bot = to_int(charmask(argbuf[i+1]));
    if (top == -1 || bot == -1) {
      return R_NilValue;
    }
    retbuf[j++] = (top << 4) + bot;
  }

  // determine the number of on bits
  int n_on = 0;
  for (i = 0; i < arglen*4; i++) if (bit_is_on(retbuf, i)) n_on++;

  // now, we save the positions of the bits
  int *bitpos = (int*) R_alloc(n_on, sizeof(int));
  j = 0;
  for (i = 0; i < arglen*4; i++) {
    if (bit_is_on(retbuf, i)) bitpos[j++] = i;
  }

  SEXP retsexp;
  PROTECT(retsexp = allocVector(INTSXP, n_on));
  for (i = 0; i < n_on; i++) INTEGER(retsexp)[i] = bitpos[i];
  UNPROTECT(1);
  return(retsexp);
}
			       

int bit_is_on(char *fp, int B) {
  return fp[B / 8] >> (B%8) & 0x01;
}

SEXP parse_jchem_binary(SEXP bstr, SEXP len) {
  int i,j;
  const char *argbuf;
  int arglen; 
  
  argbuf = (const char*) CHAR(STRING_ELT(bstr,0));
  arglen = INTEGER(len)[0];

  // determine number of 1's
  int n_on = 0;
  i = 0;
  while (i < arglen) {
    if (argbuf[i++] == 9) break;
  }
  int startPos = i;
  while (i < arglen) {
    if (argbuf[i++] == 49) n_on++;
  }
  
  // no get the actual bit positions
  int *bitpos = (int*) R_alloc(n_on, sizeof(int));
  int bitIdx = 0;
  j = 0;
  for (i = startPos; i < arglen; i++) {
    int c = argbuf[i];
    if (c != 49 && c != 48) continue;
    if (c == 49) bitpos[j++] = bitIdx;
    bitIdx++;
  }

  SEXP retsexp;
  PROTECT(retsexp = allocVector(INTSXP, n_on));
  for (i = 0; i < n_on; i++) INTEGER(retsexp)[i] = bitpos[i];
  UNPROTECT(1);
  return(retsexp);
  
}
