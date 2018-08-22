/* The file series.c contains the definitions of the functions with
 * prototypes documented in series.h. */

#include <stdio.h>
#include "series.h"

int standard_Newton_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   /* printf("idx = %d, nbr = %d, verbose = %d\n",idx,nbr,verbose); */

   idxnbr[0] = idx;
   idxnbr[1] = nbr;

   fail = _ada_use_c2phc4c(691,idxnbr,&verbose,c);

   return fail;
}

int dobldobl_Newton_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   idxnbr[0] = idx;
   idxnbr[1] = nbr;
   fail = _ada_use_c2phc4c(692,idxnbr,&verbose,c);

   return fail;
}

int quaddobl_Newton_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   idxnbr[0] = idx;
   idxnbr[1] = nbr;
   fail = _ada_use_c2phc4c(693,idxnbr,&verbose,c);

   return fail;
}

int standard_Newton_power_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   /* printf("idx = %d, nbr = %d, verbose = %d\n",idx,nbr,verbose); */

   idxnbr[0] = idx;
   idxnbr[1] = nbr;

   fail = _ada_use_c2phc4c(694,idxnbr,&verbose,c);

   return fail;
}

int dobldobl_Newton_power_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   idxnbr[0] = idx;
   idxnbr[1] = nbr;
   fail = _ada_use_c2phc4c(695,idxnbr,&verbose,c);

   return fail;
}

int quaddobl_Newton_power_series ( int idx, int nbr, int verbose )
{
   int fail = 0;
   int idxnbr[2];
   double *c;

   idxnbr[0] = idx;
   idxnbr[1] = nbr;
   fail = _ada_use_c2phc4c(696,idxnbr,&verbose,c);

   return fail;
}

int standard_Pade_approximant
 ( int idx, int numdeg, int dendeg, int nbr, int verbose )
{
   int fail = 0;
   int pars[4];
   double *c;

   pars[0] = idx;
   pars[1] = numdeg;
   pars[2] = dendeg;
   pars[3] = nbr;
   fail = _ada_use_c2phc4c(704,pars,&verbose,c);

   return fail;
}

int dobldobl_Pade_approximant
 ( int idx, int numdeg, int dendeg, int nbr, int verbose )
{
   int fail = 0;
   int pars[4];
   double *c;

   pars[0] = idx;
   pars[1] = numdeg;
   pars[2] = dendeg;
   pars[3] = nbr;
   fail = _ada_use_c2phc4c(705,pars,&verbose,c);

   return fail;
}

int quaddobl_Pade_approximant
 ( int idx, int numdeg, int dendeg, int nbr, int verbose )
{
   int fail = 0;
   int pars[4];
   double *c;

   pars[0] = idx;
   pars[1] = numdeg;
   pars[2] = dendeg;
   pars[3] = nbr;
   fail = _ada_use_c2phc4c(706,pars,&verbose,c);

   return fail;
}
