/* Tests the product of two series in double double precision. */

#include <ctime>
#include <cstdlib>
#include <cmath>
#include <iostream>
#include <iomanip>
#include <vector_types.h>
#include "random2_series.h"
#include "double_double_functions.h"
#include "dbl2_convolutions_host.h"
#include "dbl2_convolutions_kernels.h"

using namespace std;

double test_real ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series of 1/(1-x) with 1+x,
 *   truncated to degree deg, for real coefficients.
 *   Returns the sum of all errors. */

double test_complex ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series of 1/(1-x) with 1+x,
 *   truncated to degree deg, for complex coefficients.
 *   Returns the sum of all errors. */

double test_real_exponential ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series for exp(x) with exp(-x)
 *   for some random x in [-1,+1], for real coefficients
 *   of a series of degree truncated to deg.
 *   Returns the sum of all errors. */

double test_complex_exponential ( int deg );
/*
 * DESCRIPTION :
 *   Multiplies the power series for exp(x) with exp(-x)
 *   for some random complex number on the unit circle,
 *   for series of degree truncated to deg.
 *   Returns the sum of all errors. */

int main ( void )
{
   const int timevalue = time(NULL); // for a random seed
   srand(timevalue);

   ios_base::fmtflags f(cout.flags()); // to restore format flags
 
   cout << "Give a degree larger than one : ";
   int deg; cin >> deg;

   if(deg > 0) 
   {
      double realerror1 = test_real(deg);

      cout.flags(f);
      double complexerror1 = test_complex(deg);
      double realerror2 = test_real_exponential(deg);
      double complexerror2 = test_complex_exponential(deg);

      const double tol = 1.0e-26;

      cout << scientific << setprecision(2);
      cout << "First test on real data, sum of all errors : ";
      cout << realerror1;
      if(realerror1 < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;

      cout << "First test on complex data, sum of all errors : ";
      cout << complexerror1;
      if(complexerror1 < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;

      cout << "Second test on real data, sum of all errors : ";
      cout << realerror2;
      if(realerror2 < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;

      cout << "Second test on complex data, sum of all errors : ";
      cout << complexerror2;
      if(complexerror2 < tol)
         cout << "  pass." << endl;
      else
         cout << "  fail!" << endl;
   }
   return 0;
}

double test_real ( int deg )
{
   double *xhi = new double[deg+1];
   double *xlo = new double[deg+1];
   double *yhi = new double[deg+1];
   double *ylo = new double[deg+1];
   double *zhi_h = new double[deg+1];
   double *zlo_h = new double[deg+1];
   double *zhi_d = new double[deg+1];
   double *zlo_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xhi[k] = 1.0;
      xlo[k] = 0.0;
      yhi[k] = 0.0;
      ylo[k] = 0.0;
   }
   yhi[0] = 1.0; yhi[1] = -1.0;

   CPU_dbl2_product(deg,xhi,xlo,yhi,ylo,zhi_h,zlo_h);

   cout << "Series of 1/(1-x) multiplied with 1-x : " << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zhi[" << k << "] : " << zhi_h[k];
      cout << "  zlo[" << k << "] : " << zlo_h[k] << endl;
   }
   GPU_dbl2_product(xhi,xlo,yhi,ylo,zhi_d,zlo_d,deg,1,deg+1);

   cout << "GPU computed product :" << endl;

   double err = 0.0;

   for(int k=0; k<=deg; k++)
   {
      cout << "zhi[" << k << "] : " << zhi_h[k];
      cout << "  zlo[" << k << "] : " << zlo_h[k] << endl;
      err = err
          + abs(zhi_h[k] - zhi_d[k]) + abs(zlo_h[k] - zlo_d[k]);
   }
   cout << endl;

   cout << scientific << setprecision(16);
   cout << "the error : " << err << endl;

   return err;
}

double test_complex ( int deg )
{
   double *xrehi = new double[deg+1];
   double *xrelo = new double[deg+1];
   double *ximhi = new double[deg+1];
   double *ximlo = new double[deg+1];
   double *yrehi = new double[deg+1];
   double *yrelo = new double[deg+1];
   double *yimhi = new double[deg+1];
   double *yimlo = new double[deg+1];
   double *zrehi_h = new double[deg+1];
   double *zrelo_h = new double[deg+1];
   double *zimhi_h = new double[deg+1];
   double *zimlo_h = new double[deg+1];
   double *zrehi_d = new double[deg+1];
   double *zrelo_d = new double[deg+1];
   double *zimhi_d = new double[deg+1];
   double *zimlo_d = new double[deg+1];

   for(int k=0; k<=deg; k++)
   {
      xrehi[k] = 1.0; xrelo[k] = 0.0;
      ximhi[k] = 0.0; ximlo[k] = 0.0;
      yrehi[k] = 0.0; yrelo[k] = 0.0;
      yimhi[k] = 0.0; yimlo[k] = 0.0;
   }
   yrehi[0] = 1.0; yrehi[1] = -1.0;

   CPU_cmplx2_product
      (deg,xrehi,xrelo,ximhi,ximlo,yrehi,yrelo,yimhi,yimlo,
       zrehi_h,zrelo_h,zimhi_h,zimlo_h);

   cout << "Series of 1/(1-x) multiplied with 1-x : " << endl;

   for(int k=0; k<=deg; k++)
   {
      cout << "zrehi[" << k << "] : " << zrehi_h[k];
      cout << "  zrelo[" << k << "] : " << zrelo_h[k];
      cout << "  zimhi[" << k << "] : " << zimhi_h[k];
      cout << "  zimlo[" << k << "] : " << zimlo_h[k] << endl;
   }
   GPU_cmplx2_product(xrehi,xrelo,ximhi,ximlo,
                      yrehi,yrelo,yimhi,yimlo,
                      zrehi_d,zrelo_d,zimhi_d,zimlo_d,deg,1,deg+1,2);

   cout << "GPU computed product :" << endl;

   double err = 0.0;

   for(int k=0; k<=deg; k++)
   {
      cout << "zrehi[" << k << "] : " << zrehi_d[k];
      cout << "  zrelo[" << k << "] : " << zrelo_d[k];
      cout << "  zimhi[" << k << "] : " << zimhi_d[k];
      cout << "  zimlo[" << k << "] : " << zimlo_d[k] << endl;
      err = err
          + abs(zrehi_h[k] - zrehi_d[k]) + abs(zrelo_h[k] - zrelo_d[k])
          + abs(zimhi_h[k] - zimhi_d[k]) + abs(zimlo_h[k] - zimlo_d[k]);
   }
   cout << scientific << setprecision(16);
   cout << "the error : " << err << endl;

   return err;
}

double test_real_exponential ( int deg )
{
   double *xhi = new double[deg+1];
   double *xlo = new double[deg+1];
   double *yhi = new double[deg+1];
   double *ylo = new double[deg+1];
   double *zhi_h = new double[deg+1];
   double *zlo_h = new double[deg+1];
   double *zhi_d = new double[deg+1];
   double *zlo_d = new double[deg+1];
   double rhi,rlo;
   double fhi,flo;

   random_dbl2_exponentials(deg,&rhi,&rlo,xhi,xlo,yhi,ylo);
/*
   random_double_double(&rhi,&rlo);

   xhi[0] = 1.0; xlo[0] = 0.0; yhi[0] = 1.0; ylo[0] = 0.0;
   xhi[1] = rhi; xlo[1] = rlo; yhi[1] = -rhi; ylo[1] = -rlo;

   for(int k=2; k<=deg; k++)
   {
      ddf_mul(xhi[k-1],xlo[k-1],rhi,rlo,&xhi[k],&xlo[k]); // x[k] = x[k-1]*r;
      ddf_mul(yhi[k-1],ylo[k-1],-rhi,-rlo,&yhi[k],&ylo[k]); 
      // y[k] = y[k-1]*(-r);
      fhi = (double) k; flo = 0.0;
      ddf_div(xhi[k],xlo[k],fhi,flo,&xhi[k],&xlo[k]);
      ddf_div(yhi[k],ylo[k],fhi,flo,&yhi[k],&ylo[k]);
   }
 */

   CPU_dbl2_product(deg,xhi,xlo,yhi,ylo,zhi_h,zlo_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xhi = " << rhi << endl;
   cout << "  and xlo = " << rlo << endl;

   double sumhi = 0.0;
   double sumlo = 0.0;

   for(int k=0; k<=deg; k++) ddf_inc(&sumhi,&sumlo,zhi_h[k],zlo_h[k]);

   cout << "Summation of all coefficients in the product ..." << endl;
   cout << "high part of sum : " << sumhi << endl;
   cout << " low part of sum : " << sumlo << endl;

   GPU_dbl2_product(xhi,xlo,yhi,ylo,zhi_d,zlo_d,deg,1,deg+1);

   sumhi = 0.0; sumlo = 0.0;

   double err = 0.0;

   for(int k=0; k<=deg; k++)
   {
       ddf_inc(&sumhi,&sumlo,zhi_d[k],zlo_d[k]);
       err = err
           + abs(zhi_h[k] - zhi_d[k]) + abs(zlo_h[k] - zlo_d[k]);
   }
   cout << "Summation of all coefficients in the GPU computed product ..."
        << endl;
   cout << "high part of sum : " << sumhi << endl;
   cout << " low part of sum : " << sumlo << endl;

   cout << scientific << setprecision(16);
   cout << "the error : " << err << endl;

   return err;
}

double test_complex_exponential ( int deg )
{
   double* xrehi = new double[deg+1];
   double* xrelo = new double[deg+1];
   double* ximhi = new double[deg+1];
   double* ximlo = new double[deg+1];
   double* yrehi = new double[deg+1];
   double* yrelo = new double[deg+1];
   double* yimhi = new double[deg+1];
   double* yimlo = new double[deg+1];
   double* zrehi_h = new double[deg+1];
   double* zrelo_h = new double[deg+1];
   double* zimhi_h = new double[deg+1];
   double* zimlo_h = new double[deg+1];
   double* zrehi_d = new double[deg+1];
   double* zrelo_d = new double[deg+1];
   double* zimhi_d = new double[deg+1];
   double* zimlo_d = new double[deg+1];
   double rndrehi,rndrelo;
   double rndimhi,rndimlo;

   random_cmplx2_exponentials
      (deg,&rndrehi,&rndrelo,&rndimhi,&rndimlo,
       xrehi,xrelo,ximhi,ximlo,yrehi,yrelo,yimhi,yimlo);

   CPU_cmplx2_product(deg,xrehi,xrelo,ximhi,ximlo,
                          yrehi,yrelo,yimhi,yimlo,
                          zrehi_h,zrelo_h,zimhi_h,zimlo_h);

   cout << scientific << setprecision(16);

   cout << "Product of series of exp(x) with series of exp(-x)," << endl;
   cout << "  for xrehi = " << rndrehi;
   cout << "  and xrelo = " << rndrelo << endl;
   cout << "  for ximhi = " << rndimhi;
   cout << "  and ximlo = " << rndimlo << endl;

   double sumrehi = 0.0;
   double sumrelo = 0.0;
   double sumimhi = 0.0;
   double sumimlo = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      ddf_inc(&sumrehi,&sumrelo,zrehi_h[k],zrelo_h[k]);
      ddf_inc(&sumimhi,&sumimlo,zimhi_h[k],zimlo_h[k]);
   }
   cout << "Summation of all coefficients of the product ..." << endl;
   cout << "  sumrehi : " << sumrehi;
   cout << "  sumrelo : " << sumrelo << endl;
   cout << "  sumimhi : " << sumimhi;
   cout << "  sumimlo : " << sumimlo << endl;

   GPU_cmplx2_product(xrehi,xrelo,ximhi,ximlo,
                      yrehi,yrelo,yimhi,yimlo,
                      zrehi_d,zrelo_d,zimhi_d,zimlo_d,deg,1,deg+1,2);

   sumrehi = 0.0; sumrelo = 0.0; sumimhi = 0.0; sumimlo = 0.0;

   double err = 0.0;

   for(int k=0; k<=deg; k++) 
   {
      ddf_inc(&sumrehi,&sumrelo,zrehi_d[k],zrelo_d[k]);
      ddf_inc(&sumimhi,&sumimlo,zimhi_d[k],zimlo_d[k]);
      err = err
          + abs(zrehi_h[k] - zrehi_d[k]) + abs(zrelo_h[k] - zrelo_d[k])
          + abs(zimhi_h[k] - zimhi_d[k]) + abs(zimlo_h[k] - zimlo_d[k]);
   }
   cout << "Summation of all coefficients of the GPU computed product ..."
        << endl;
   cout << "  sumrehi : " << sumrehi;
   cout << "  sumrelo : " << sumrelo << endl;
   cout << "  sumimhi : " << sumimhi;
   cout << "  sumimlo : " << sumimlo << endl;

   cout << scientific << setprecision(16);
   cout << "the error : " << err << endl;

   return err;
}
