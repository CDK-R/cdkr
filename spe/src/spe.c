/* C implementation of stochastic proximity embedding.
 *
 * References: PNAS, 2002, vol 99, no 25, pg 15869
 *             J. Comp. Chem. 2003, 24, 1215
 *             J. Chem. Inf. Comp. Sci. 2003, 43, 475
 *
 * Rajarshi Guha <rajarshi@presidency.com>
 * 22/04/04
 */

#include <R.h>
#include <R_ext/Utils.h>

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

/*
 accessing a matrix via a vector. The matrix is provided
 column wise (ie col1 col2 col3) so
 1 2 3
 4 5 6
 7 8 9
 10 11 12
 is supplied as : 1 4 7 10  2 5 8 11 3 6 9 12
 and so access is: [i,j] = i + nrow * j

 (i,j start from 0 in the C code) where
 i is row and j is col
 */
#define X(_m,_i,_j,_nrow) _m[ _i + _nrow * _j ]

void get_indices(int upper, int *a, int *b)
{
    /* gives two random integers from 0 to upper-1 */
    *a = (int)(upper * unif_rand());
    while(1) {
        *b = (int)(upper * unif_rand());
        if (*b == *a) continue;
        else break;
    }
    
    /* C library's rand() is probabyl not as good as R's! 
    *a = (int)((double)upper * rand() / (RAND_MAX + 1.0));
    while (1)
      {
        R_CheckUserInterrupt();
        *b = (int)((double)upper * rand() / (RAND_MAX + 1.0));
        if (*a == *b) continue;
        else break;
      }
      */
    return;
}

double ed(double *x, int row1, int row2, int ncol,int nrow)
{
    int i;
    register double d = 0;
    for (i = 0; i < ncol; i++) 
        d += ( X(x,row1,i,nrow) - X(x,row2,i,nrow)) * ( X(x,row1,i,nrow) - X(x,row2,i,nrow));
    return(sqrt(d));
}
double cd(double *x, int row1, int row2, int ncol, int nrow)
{ /* for future use */
    double s1,s2,s3;
    int i;

    s1 = 0; s2 = 0; s3 = 0;

    for (i = 0; i < ncol ;i++)
      {
        s1 += X(x,row1,i,nrow) * X(x,row2,i,nrow);
        s2 += X(x,row1,i,nrow) * X(x,row1,i,nrow);
        s3 += X(x,row2,i,nrow) * X(x,row2,i,nrow);
      }
    return( acos(s1/sqrt(s2*s3)) );
}
    
void sample_distance(double *coord, int *nobs, int *ndim, int *samplesize, double *maxdist)
{
    /* this function will sample the distances between randomly chosen points
     * and keep track of the maximum distance calculated. This will be used
     * to get a value of rcut which is a user specified % of the maximum
     * distance found. (Probability sampling to get rcut is mentioned in
     * PNAS Dec, 10, 2002, pg 15869 */
    double maxd = -1e37;
    double d = 0;
    int i;
    int a = 0;
    int b = 0;

    GetRNGstate();
    for (i = 0; i < *samplesize; i++)
      {
        get_indices(*nobs, &a, &b);
        d = ed(coord,a,b,*ndim,*nobs);
        if (d > maxd) maxd = d;
      }
    *maxdist = maxd;
    PutRNGstate();
    return;
}

    
    

void eval_stress(double *x, double *coord,
        int *ndim, int *edim, int *nobs, 
        int *samplesize,double *stress) 
{
    int i;
    double dab,simab;
    int a = 0; int b = 0;
    long double denom = 0.0;
    long double numer = 0.0;

    GetRNGstate();
    for (i = 0; i < *samplesize; i++)
      {
        get_indices(*nobs, &a, &b);

        dab = ed(x,a,b,*edim,*nobs);
        simab = ed(coord,a,b,*ndim,*nobs);

        denom += simab;
        numer += (dab - simab) * (dab - simab) / simab;
      }
    *stress = (double) (numer/denom);
    PutRNGstate();
    return;
}
            
void  spe(double *coord, 
        double *rcut,
        int *nobs, int *ndim, int *edim, 
        double *lambda0, double *lambda1, 
        int *nstep, int *ncycle, double *x)
{
    /* x will come in as a vector of length (nobs * edim)
     * so no need to malloc it. It will also be randomly initialized
     */

    int i,j,k;
    double dab,simab,t1;
    double epsilon = 1e-10;
    double lambda = *lambda0;
    double *tx1, *tx2;
    int a = 0; int b = 0;
      
    /* alloc space */
    tx1 = (double*) R_alloc(*edim , sizeof(double));
    tx2 = (double*) R_alloc(*edim , sizeof(double));
    
    GetRNGstate();
    
    /* start self organization */
    for (i = 0; i < *ncycle; i++) {

        R_CheckUserInterrupt();

        /*
        if (*ncycle >= 10 && i % (int)(.1* (*ncycle)) == 0) 
          {
            REprintf("Cycle %d lambda = %f\n",i,lambda);
          }
        */

        for (j = 0; j < *nstep; j++) {
            get_indices(*nobs, &a, &b);


            dab = ed(x,a,b,*edim,*nobs);
            simab = ed(coord,a,b,*ndim,*nobs);

            if (simab > *rcut && dab >= simab) continue;
            else
              {
                t1 = lambda * 0.5 * (simab - dab) / (dab +epsilon);

                for (k = 0; k < *edim; k++) {
                    tx1[k] = t1 * (X(x,a,k,*nobs) - X(x,b,k,*nobs));
                    tx2[k] = t1 * (X(x,b,k,*nobs) - X(x,a,k,*nobs));
                }
                for (k = 0; k < *edim; k++) {
                    X(x,a,k,*nobs) += tx1[k];
                    X(x,b,k,*nobs) += tx2[k];
                }
            }

        }
        lambda -= ((*lambda0 - *lambda1) / (double)(*ncycle - 1.0));
        if (lambda < *lambda1) break;
    }
    PutRNGstate();
    return;
}

/*
void test(double *x, int *nr, int *nc, int *rownum) 
{
    int i,j;
    for (i = 0; i < *nr * *nc; i++)
        Rprintf("%4.2f ", x[i]);
    Rprintf("\n\n\n");

    for (i = 0; i < *nc; i++)
      {
        Rprintf("%4.2f ", X(x,*rownum-1,i,*nr));
      }
    Rprintf("\n\n");
    Rprintf("%f\n\n", ed(x, 0,3, *nc, *nr));

    return;
}
*/
