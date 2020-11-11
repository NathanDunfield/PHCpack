// The file random3_monomials.cpp defines functions specified 
// in random3_monomials.h.

#include <iostream>
#include <cstdlib>
#include <cmath>
#include "random_monomials.h"
#include "triple_double_functions.h"
#include "random3_vectors.h"
#include "random3_series.h"
#include "random3_monomials.h"

bool make_real3_monomial
 ( int dim, int nvr, int pwr, int deg, int *idx, int *exp,
   double *cffhi, double *cffmi, double *cfflo )
{
   bool fail;

   if(nvr > dim)
   {
      std::cout << "ERROR: nvr = " << nvr << " > " << dim << " dim"
                << std::endl;

      return true;
   }
   else
   {
      for(int i=0; i<=deg; i++)
      {
         // random_triple_double(&cffhi[i],&cffmi[i],&cfflo[i]);
         cffhi[i] = 1.0;
         cffmi[i] = 0.0;
         cfflo[i] = 0.0;
         if(i > 0) random_triple_double(&cffhi[i],&cffmi[i],&cfflo[i]);
      }
      for(int i=0; i<nvr; i++)
      {
         exp[i] = 1 + (rand() % pwr);
         do
         {
            idx[i] = rand() % dim;
            fail = sorted_insert(i,idx);
         }
         while(fail);
      }
      return false;
   }
}

bool make_complex3_monomial
 ( int dim, int nvr, int pwr, int deg, int *idx, int *exp,
   double *cffrehi, double *cffremi, double *cffrelo,
   double *cffimhi, double *cffimmi, double *cffimlo )
{
   bool fail;

   if(nvr > dim)
   {
      std::cout << "ERROR: nvr = " << nvr << " > " << dim << " dim"
                << std::endl;

      return true;
   }
   else
   {
      double rndhi,rndmi,rndlo,sinhi,sinmi,sinlo;

      for(int i=0; i<=deg; i++)
      {
         random_triple_double(&rndhi,&rndmi,&rndlo);    // random cos
                                                        // cos(angle)
         cffrehi[i] = rndhi; cffremi[i] = rndmi;
         cffrelo[i] = rndlo;
         tdf_sqrt(rndhi,rndmi,rndlo,&sinhi,&sinmi,&sinlo);  // cos^(angle)
         tdf_minus(&sinhi,&sinmi,&sinlo);                   // -cos^(angle)
         tdf_inc_d(&sinhi,&sinmi,&sinlo,1.0);               // 1-cos^2(angle)
         // sin is sqrt
         tdf_sqrt(sinhi,sinmi,sinlo,&cffimhi[i],&cffimmi[i],&cffimlo[i]);
      }

      for(int i=0; i<nvr; i++)
      {
         exp[i] = 1 + (rand() % pwr);
         do
         {
            idx[i] = rand() % dim;
            fail = sorted_insert(i,idx);
         }
         while(fail);
      }
      return false;
   }
}

void make_real3_input
 ( int dim, int deg, double **datahi, double **datami, double **datalo )
{
   double rndhi,rndmi,rndlo;
   double* pluxhi = new double[deg+1];
   double* pluxmi = new double[deg+1];
   double* pluxlo = new double[deg+1];
   double* minxhi = new double[deg+1];
   double* minxmi = new double[deg+1];
   double* minxlo = new double[deg+1];

   for(int i=0; i<dim; i++)
   {
      random_dbl3_exponentials
         (deg,&rndhi,&rndmi,&rndlo,pluxhi,pluxmi,pluxlo,minxhi,minxmi,minxlo);
      for(int j=0; j<=deg; j++)
      {
         datahi[i][j] = pluxhi[j];
         datami[i][j] = pluxmi[j];
         datalo[i][j] = pluxlo[j];
      }
   }
   free(pluxhi); free(pluxmi); free(pluxlo);
   free(minxhi); free(minxmi); free(minxlo); 
}

void make_complex3_input
 ( int dim, int deg, double **datarehi, double **dataremi, double **datarelo,
   double **dataimhi, double **dataimmi, double **dataimlo )
{
   double rndrehi,rndremi,rndrelo,rndimhi,rndimmi,rndimlo;
   double* pluxrehi = new double[deg+1];
   double* pluxremi = new double[deg+1];
   double* pluxrelo = new double[deg+1];
   double* pluximhi = new double[deg+1];
   double* pluximmi = new double[deg+1];
   double* pluximlo = new double[deg+1];
   double* minxrehi = new double[deg+1];
   double* minxremi = new double[deg+1];
   double* minxrelo = new double[deg+1];
   double* minximhi = new double[deg+1];
   double* minximmi = new double[deg+1];
   double* minximlo = new double[deg+1];

   for(int i=0; i<dim; i++)
   {
      random_cmplx3_exponentials(deg,
         &rndrehi,&rndremi,&rndrelo,&rndimhi,&rndimmi,&rndimlo,
         pluxrehi,pluxremi,pluxrelo,pluximhi,pluximmi,pluximlo,
         minxrehi,minxremi,minxrelo,minximhi,minximmi,minximlo);

      for(int j=0; j<=deg; j++)
      {
         datarehi[i][j] = pluxrehi[j]; dataremi[i][j] = pluxremi[j];
         datarelo[i][j] = pluxrelo[j];
         dataimhi[i][j] = pluximhi[j]; dataimmi[i][j] = pluximmi[j];
         dataimlo[i][j] = pluximlo[j];
      }
   }
   free(pluxrehi); free(pluxremi); free(pluxrelo);
   free(pluximhi); free(pluximmi); free(pluximlo);
   free(minxrehi); free(minxremi); free(minxrelo);
   free(minximhi); free(minximmi); free(minximlo); 
}
