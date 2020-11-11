/* Tests the evaluation and differentiation of a monomial
 * in double precision. */

#include <iostream>
#include <iomanip>
#include <cstdlib>
#include <ctime>
#include <cmath>
#include <vector_types.h>
#include "random_monomials.h"
#include "dbl_monomials_host.h"
#include "dbl_monomials_kernels.h"

using namespace std;

int test_real ( int dim, int nvr, int pwr, int deg );
/*
 * DESCRIPTION :
 *   Tests the evaluation and differentiation for random real data.
 * 
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nvr      number of variables in the product;
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series. */

int test_complex ( int dim, int nvr, int pwr, int deg );
/*
 * DESCRIPTION :
 *   Tests the evaluation and differentiation for random complex data.
 * 
 * ON ENTRY :
 *   dim      dimension, total number of variables;
 *   nvr      number of variables in the product;
 *   pwr      highest power of each variable;
 *   deg      truncation degree of the series. */

int main ( void )
{
   int dim,nvr,pwr,deg;

   cout << "Give the dimension : "; cin >> dim;
   cout << "Give the number of variables, <= "; cout << dim;
   cout << " : "; cin >> nvr;
   cout << "Give the largest power of each variable : "; cin >> pwr;
   cout << "Give the degree of the series : "; cin >> deg;

   cout << endl << "Testing for real input data ... " << endl;
   test_real(dim,nvr,pwr,deg);
   cout << endl << "Testing for complex input data ..." << endl;
   test_complex(dim,nvr,pwr,deg);

   return 0;
}

int test_real ( int dim, int nvr, int pwr, int deg )
{
   int *idx = new int[nvr];         // indices of variables in the monomial
   int *exp = new int[nvr];         // exponents of the variables
   int *expfac = new int[nvr];      // exponents of common factor
   int nbrfac;                      // number of common factors
   double *cff = new double[deg+1]; // series coefficient

   // The input are dim power series of degree deg,
   // the output are nvr+1 power series of degree deg,
   // for the evaluated and differentiated monomial.

   double **input = new double*[dim];
   for(int i=0; i<dim; i++) input[i] = new double[deg+1];
   double **output_h = new double*[dim+1];
   for(int i=0; i<=dim; i++) output_h[i] = new double[deg+1];
   double **output_d = new double*[dim+1];
   for(int i=0; i<=dim; i++) output_d[i] = new double[deg+1];

   srand(time(NULL));

   bool fail = make_real_monomial(dim,nvr,pwr,deg,idx,exp,cff);

   if(fail) return 1;
 
   cout << "Generated a random monomial :" << endl;
   cout << "   the indices :";
   for(int i=0; i<nvr; i++) cout << " " << idx[i];
   cout << endl;

   cout << " the exponents :";
   for(int i=0; i<nvr; i++) cout << " " << exp[i];
   cout << endl;

   common_factors(nvr,exp,&nbrfac,expfac);

   cout << "common factors :";
   for(int i=0; i<nvr; i++) cout << " " << expfac[i];
   cout << endl;
   cout << "number of common factors : " << nbrfac << endl;

   cout << scientific << setprecision(16);
   cout << "the coefficients :" << endl;
   for(int i=0; i<=deg; i++) cout << " " << cff[i] << endl;;

   make_real_input(dim,deg,input);

   cout << "Random input series :" << endl;
   for(int i=0; i<dim; i++)
   {
      cout << "-> coefficients of series " << i << " :" << endl;
      for(int j=0; j<=deg; j++) cout << input[i][j] << endl;
   }

   CPU_dbl_evaldiff(dim,nvr,deg,idx,cff,input,output_h);
   cout << "The value of the product :" << endl;
   for(int i=0; i<=deg; i++) cout << output_h[dim][i] << endl;

   double errsum = 0.0;
   double errtot = 0.0;

   if(nvr > 2)
   {
      GPU_dbl_evaldiff(deg+1,dim,nvr,deg,idx,cff,input,output_d);
      cout << "The value of the product computed on the GPU :" << endl;
      for(int i=0; i<=deg; i++)
      {
         cout << output_d[dim][i] << endl;
         errsum = errsum + abs(output_h[dim][i] - output_d[dim][i]);
      }
      cout << "Sum of errors : " << errsum << endl; errtot += errsum;
   }
   for(int k=0; k<nvr; k++)
   {
      cout << "-> derivative for index " << idx[k] << " :" << endl;
      for(int i=0; i<=deg; i++) cout << output_h[idx[k]][i] << endl;

      if(nvr > 2)
      {
         cout << "-> derivative for index " << idx[k]
              << " computed on GPU :" << endl;
         errsum = 0.0;
         for(int i=0; i<=deg; i++)
         {
            cout << output_d[idx[k]][i] << endl;
            errsum = errsum + abs(output_h[dim][i] - output_d[dim][i]);
         }
         cout << "Sum of errors : " << errsum << endl; errtot += errsum;
      }
   }
   cout << "Total sum of all errors : " << errtot << endl;

   return 0;
}

int test_complex ( int dim, int nvr, int pwr, int deg )
{
   int *idx = new int[nvr];           // indices of variables in the monomial
   int *exp = new int[nvr];           // exponents of the variables
   int *expfac = new int[nvr];        // exponents of common factor
   int nbrfac;                        // number of common factors
   double *cffre = new double[deg+1]; // real parts of coefficients
   double *cffim = new double[deg+1]; // imaginary parts of coefficients

   // The input are dim power series of degree deg,
   // the output are nvr+1 power series of degree deg,
   // for the evaluated and differentiated monomial.

   double **inputre = new double*[dim];
   double **inputim = new double*[dim];
   for(int i=0; i<dim; i++)
   {
      inputre[i] = new double[deg+1];
      inputim[i] = new double[deg+1];
   }
   double **outputre_h = new double*[dim+1];
   double **outputim_h = new double*[dim+1];
   for(int i=0; i<=dim; i++)
   {
      outputre_h[i] = new double[deg+1];
      outputim_h[i] = new double[deg+1];
   }
   double **outputre_d = new double*[dim+1];
   double **outputim_d = new double*[dim+1];
   for(int i=0; i<=dim; i++)
   {
      outputre_d[i] = new double[deg+1];
      outputim_d[i] = new double[deg+1];
   }

   srand(time(NULL));

   bool fail = make_complex_monomial(dim,nvr,pwr,deg,idx,exp,cffre,cffim);

   if(fail) return 1;

   cout << "Generated a random monomial :" << endl;
   cout << "   the indices :";
   for(int i=0; i<nvr; i++) cout << " " << idx[i];
   cout << endl;

   cout << " the exponents :";
   for(int i=0; i<nvr; i++) cout << " " << exp[i];
   cout << endl;

   common_factors(nvr,exp,&nbrfac,expfac);

   cout << "common factors :";
   for(int i=0; i<nvr; i++) cout << " " << expfac[i];
   cout << endl;
   cout << "number of common factors : " << nbrfac << endl;

   cout << scientific << setprecision(16);
   cout << "the coefficients :" << endl;
   for(int i=0; i<=deg; i++)
      cout << " " << cffre[i] << "  " << cffim[i] << endl;;

   make_complex_input(dim,deg,inputre,inputim);

   cout << "Random input series :" << endl;
   for(int i=0; i<dim; i++)
   {
      cout << "-> coefficients of series " << i << " :" << endl;
      for(int j=0; j<=deg; j++)
         cout << inputre[i][j] << "  " << inputim[i][j] << endl;
   }

   CPU_cmplx_evaldiff(dim,nvr,deg,idx,cffre,cffim,inputre,inputim,
                      outputre_h,outputim_h);

   cout << "The value of the product :" << endl;
   for(int i=0; i<=deg; i++)
      cout << outputre_h[dim][i] << "  " << outputim_h[dim][i] << endl;

   double errsum = 0.0;
   double errtot = 0.0;

   if(nvr > 2)
   {
      GPU_cmplx_evaldiff(deg+1,dim,nvr,deg,idx,cffre,cffim,inputre,inputim,
                         outputre_d,outputim_d);

      cout << "The value of the product computed on the GPU :" << endl;
      for(int i=0; i<=deg; i++) 
      {
         cout << outputre_d[dim][i] << "  " << outputim_d[dim][i] << endl;
         errsum = errsum
                + abs(outputre_h[dim][i] - outputre_d[dim][i])
                + abs(outputim_h[dim][i] - outputim_d[dim][i]);
      }
      cout << "The sum of errors : " << errsum << endl; errtot += errsum;
   }
   for(int k=0; k<nvr; k++)
   {
      cout << "-> derivative for index " << idx[k] << " :" << endl;
      for(int i=0; i<=deg; i++)
         cout << outputre_h[idx[k]][i] << "  "
              << outputim_h[idx[k]][i] << endl;
      if(nvr > 2)
      {
         cout << "-> derivative for index " << idx[k]
              << " computed on GPU :" << endl;
         errsum = 0.0;
         for(int i=0; i<=deg; i++)
         {
            cout << outputre_d[idx[k]][i] << "  "
                 << outputim_d[idx[k]][i] << endl;
            errsum = errsum
                   + abs(outputre_h[dim][i] - outputre_d[dim][i])
                   + abs(outputim_h[dim][i] - outputim_d[dim][i]);
         }
         cout << "The sum of errors : " << errsum << endl; errtot += errsum;
      }
   }
   cout << "Total sum of all errors : " << errtot << endl;

   return 0;
}
