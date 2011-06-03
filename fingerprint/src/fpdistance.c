#include <math.h>

#define X(_m,_i,_j,_nrow) _m[ _i + _nrow * _j ]

#define METRIC_TANIMOTO       1
#define METRIC_EUCLIDEAN      2

double d_tanimoto(double*,double*,int);
double d_euclidean(double*,double*,int);

/**
fp1 and fp2 should be an array of 1's and 0's, of
length equal to the size of the fingerprint
**/
void fpdistance(double *fp1, double *fp2, int *nbit, int *metric, double *ret) {
  double r = 0.0;
  switch(*metric) {
  case METRIC_TANIMOTO:
    r = d_tanimoto(fp1, fp2, *nbit);
    break;
  case METRIC_EUCLIDEAN:
    r = d_euclidean(fp1, fp2, *nbit);
  }
  *ret = r;
  return;
}

/**
http://www.daylight.com/dayhtml/doc/theory/theory.finger.html
**/
double d_tanimoto(double *fp1, double *fp2, int nbit) {
  int i;
  int nc = 0;
  int na = 0;
  int nb = 0;
  if (nbit <= 0) return(-1.0);
  for (i = 0; i < nbit; i++) {
    if (fp1[i] == 1 && fp2[i] == 1) nc++;
    if (fp1[i] == 1 && fp2[i] == 0) na++;
    if (fp2[i] == 1 && fp1[i] == 0) nb++;
  }
  return ((double) nc) / (double) (na + nb + nc);
}

/**
http://www.daylight.com/dayhtml/doc/theory/theory.finger.html
**/
double d_euclidean(double *fp1, double *fp2, int nbit) {
  int i;
  int nc = 0;
  int nd = 0;
  if (nbit <= 0) return(-1.0);
  for (i = 0; i < nbit; i++) {
    if (fp1[i] == 1 && fp2[i] == 1) nc++;
    if (fp1[i] == 0 && fp2[i] == 0) nd++;
  }
  return sqrt(((double) nc + (double) nd) / (double) nbit);
}
