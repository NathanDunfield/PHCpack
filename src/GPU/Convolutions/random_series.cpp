// The file random_series.cpp defines the functions with prototypes
// in random_series.h.

#include <cmath>
#include "random_numbers.h"

void dbl_exponentials ( int deg, double x, double *plux, double *minx )
{
   plux[0] = 1.0; minx[0] = 1.0;

   for(int k=1; k<=deg; k++)
   {
      plux[k] = plux[k-1]*x/k;
      minx[k] = minx[k-1]*(-x)/k;
   }
}

void random_dbl_exponentials
 ( int deg, double *x, double *plux, double *minx )
{
   *x = random_double();
   dbl_exponentials(deg,*x,plux,minx);
}

void cmplx_exponentials
 ( int deg, double xre, double xim,
   double *pluxre, double *pluxim, double *minxre, double *minxim )
{
   pluxre[0] = 1.0; pluxim[0] = 0.0; minxre[0] = 1.0; minxim[0] = 0.0;
   pluxre[1] = xre; pluxim[1] = xim;  minxre[1] = -xre; minxim[1] = -xim;

   for(int k=2; k<=deg; k++)
   {
      pluxre[k] = (pluxre[k-1]*xre - pluxim[k-1]*xim)/k;
      pluxim[k] = (pluxre[k-1]*xim + pluxim[k-1]*xre)/k;
      minxre[k] = (minxre[k-1]*(-xre) - minxim[k-1]*(-xim))/k;
      minxim[k] = (minxre[k-1]*(-xim) + minxim[k-1]*(-xre))/k;
   }
}

void random_cmplx_exponentials
 ( int deg, double *xre, double *xim,
   double *pluxre, double *pluxim, double *minxre, double *minxim )
{
   const double r = random_angle();

   *xre = cos(r);
   *xim = sin(r);

   cmplx_exponentials(deg,*xre,*xim,pluxre,pluxim,minxre,minxim);
}
