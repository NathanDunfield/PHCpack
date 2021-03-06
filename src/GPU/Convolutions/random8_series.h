// The file random8_series.h specifies functions to generate random series
// in octo double precision.

#ifndef __random8_series_h__
#define __random8_series_h__

void dbl8_exponentials
 ( int deg, double xhihihi, double xlohihi, double xhilohi, double xlolohi, 
            double xhihilo, double xlohilo, double xhilolo, double xlololo, 
   double *pluxhihihi, double *pluxlohihi, double *pluxhilohi,
   double *pluxlolohi, double *pluxhihilo, double *pluxlohilo,
   double *pluxhilolo, double *pluxlololo,
   double *minxhihihi, double *minxlohihi, double *minxhilohi,
   double *minxlolohi, double *minxhihilo, double *minxlohilo,
   double *minxhilolo, double *minxlololo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   with real coefficients in octo double precision.
 *
 * ON ENTRY :
 *   deg          degree to truncate the series;
 *   xhihihi      highest part of some octo double;
 *   xlohihi      second highest part of some octo double;
 *   xhilohi      third highest part of some octo double;
 *   xlolohi      fourth highest part of some octo double;
 *   xhihilo      fourth lowest part of some octo double;
 *   xlohilo      third lowest part of some octo double;
 *   xhilolo      second lowest part of some octo double;
 *   xlololo      lowest part of some octo double;
 *   pluxhihihi   space for deg+1 doubles for the highest doubles
 *                of the exp(+x) series;
 *   pluxlohihi   space for deg+1 doubles for the second highest doubles
 *                of the exp(+x) series;
 *   pluxhilohi   space for deg+1 doubles for the third highest doubles
 *                of the exp(+x) series;
 *   pluxlolohi   space for deg+1 doubles for the fourth highest doubles
 *                of the exp(+x) series;
 *   pluxhihilo   space for deg+1 doubles for the fourth lowest doubles
 *                of the exp(+x) series;
 *   pluxlohilo   space for deg+1 doubles for the third lowest doubles
 *                of the exp(+x) series;
 *   pluxhilolo   space for deg+1 doubles for the second lowest doubles
 *                of the exp(+x) series;
 *   pluxlololo   space for deg+1 doubles for the lowest doubles
 *                of the exp(+x) series;
 *   minxhihihi   space for deg+1 doubles for the highest doubles
 *                of the exp(-x) series;
 *   minxlohihi   space for deg+1 doubles for the second highest doubles
 *                of the exp(-x) series;
 *   minxhilohi   space for deg+1 doubles for the third highest doubles
 *                of the exp(-x) series;
 *   minxlolohi   space for deg+1 doubles for the fourth highest doubles
 *                of the exp(-x) series;
 *   minxhihilo   space for deg+1 doubles for the fourth lowest doubles
 *                of the exp(-x) series.
 *   minxlohilo   space for deg+1 doubles for the third lowest doubles
 *                of the exp(-x) series.
 *   minxhilolo   space for deg+1 doubles for the second lowest doubles
 *                of the exp(-x) series.
 *   minxlololo   space for deg+1 doubles for the lowest doubles
 *                of the exp(-x) series.
 *
 * ON RETURN :
 *   pluxhihihi   highest doubles of the series of exp(+x);
 *   pluxlohihi   second highest doubles of the series of exp(+x);
 *   pluxhilohi   third highest doubles of the series of exp(+x);
 *   pluxlolohi   fourth highest doubles of the series of exp(+x);
 *   pluxhihilo   fourth lowest doubles of the series of exp(+x);
 *   pluxlohilo   third lowest doubles of the series of exp(+x);
 *   pluxhilolo   second lowest doubles of the series of exp(+x);
 *   pluxlololo   lowest doubles of the series of exp(+x);
 *   minxhihihi   highest doubles of the series of exp(-x);
 *   minxlohihi   second highest of the series of exp(-x);
 *   minxhilohi   third highest of the series of exp(-x);
 *   minxlolohi   fourth highest of the series of exp(-x);
 *   minxhihilo   fourth lowest doubles of the series of exp(-x);
 *   minxlohilo   third lowest doubles of the series of exp(-x);
 *   minxhilolo   second lowest doubles of the series of exp(-x);
 *   minxlololo   lowest doubles of the series of exp(-x). */

void random_dbl8_exponentials
 ( int deg,
   double *xhihihi, double *xlohihi, double *xhilohi, double *xlolohi,
   double *xhihilo, double *xlohilo, double *xhilolo, double *xlololo,
   double *pluxhihihi, double *pluxlohihi, double *pluxhilohi,
   double *pluxlolohi, double *pluxhihilo, double *pluxlohilo,
   double *pluxhilolo, double *pluxlololo,
   double *minxhihihi, double *minxlohihi, double *minxhilohi,
   double *minxlolohi, double *minxhihilo, double *minxlohilo,
   double *minxhilolo, double *minxlololo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   truncated to degree deg for a random octo double x.
 *   Parameters are the same as dbl8_exponentials,
 *   except that xhihihi, xlohihi, xhilohi, xlolohi,
 *   xhihilo, xlohilo, xhilolo, and xlololo are return parameters. */

void cmplx8_exponentials
 ( int deg,
   double xrehihihi, double xrelohihi, double xrehilohi, double xrelolohi,
   double xrehihilo, double xrelohilo, double xrehilolo, double xrelololo,
   double ximhihihi, double ximlohihi, double ximhilohi, double ximlolohi,
   double ximhihilo, double ximlohilo, double ximhilolo, double ximlololo,
   double *pluxrehihihi, double *pluxrelohihi,
   double *pluxrehilohi, double *pluxrelolohi,
   double *pluxrehihilo, double *pluxrelohilo,
   double *pluxrehilolo, double *pluxrelololo,
   double *pluximhihihi, double *pluximlohihi,
   double *pluximhilohi, double *pluximlolohi,
   double *pluximhihilo, double *pluximlohilo,
   double *pluximhilolo, double *pluximlololo,
   double *minxrehihihi, double *minxrelohihi,
   double *minxrehilohi, double *minxrelolohi,
   double *minxrehihilo, double *minxrelohilo,
   double *minxrehilolo, double *minxrelololo,
   double *minximhihihi, double *minximlohihi,
   double *minximhilohi, double *minximlolohi,
   double *minximhihilo, double *minximlohilo,
   double *minximhilolo, double *minximlololo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   with complex coefficients in octo double precision.
 *
 * ON ENTRY :
 *   deg           degree to truncate the series;
 *   xrehihihi     highest double of the real part of a complex number;
 *   xrelohihi     second highest double of the real part of a complex number;
 *   xrehilohi     third highest double of the real part of a complex number;
 *   xrelolohi     fourth highest double of the real part of a complex number;
 *   xrehihilo     second lowest double of the real part of a complex number;
 *   xrelohilo     second lowest double of the real part of a complex number;
 *   xrehilolo     second lowest double of the real part of a complex number;
 *   xrelololo     lowest double of the real part of a complex number;
 *   ximhihihi     highest double of the imaginary part of a complex number;
 *   ximlohihi     second highest double of the imaginary part
 *                 of a complex number;
 *   ximhilohi     third highest double of the imaginary part
 *                 of a complex number;
 *   ximlolohi     fourth highest double of the imaginary part
 *                 of a complex number;
 *   ximhihilo     fourth lowest double of the imaginary part
 *                 of a complex number;
 *   ximlohilo     third lowest double of the imaginary part
 *                 of a complex number;
 *   ximhilolo     second lowest double of the imaginary part
 *                 of a complex number;
 *   ximlololo     lowest double of the imaginary part of a complex number;
 *   pluxrehihihi  space for deg+1 doubles for the highest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrelohihi  space for deg+1 doubles for the second highest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrehilohi  space for deg+1 doubles for the third highest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrelolohi  space for deg+1 doubles for the fourth highest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrehihilo  space for deg+1 doubles for the fourth lowest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrelohilo  space for deg+1 doubles for the third lowest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrehilolo  space for deg+1 doubles for the second lowest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluxrelololo  space for deg+1 doubles for the lowest doubles
 *                 of the real parts of the exp(+x) series;
 *   pluximhihihi  space for deg+1 doubles for the highest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximlohihi  space for deg+1 doubles for the second highest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximhilohi  space for deg+1 doubles for the third highest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximlolohi  space for deg+1 doubles for the fourth highest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximhihilo  space for deg+1 doubles for the fourth lowest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximlohilo  space for deg+1 doubles for the third lowest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximhilolo  space for deg+1 doubles for the second lowest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   pluximlololo  space for deg+1 doubles for the lowest doubles
 *                 of the imaginary parts of the exp(+x) series;
 *   minxrehihihi  space for deg+1 doubles for the highest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrelohihi  space for deg+1 doubles for the second highest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrehilohi  space for deg+1 doubles for the third highest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrelolohi  space for deg+1 doubles for the fourth highest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrehihilo  space for deg+1 doubles for the fourth lowest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrelohilo  space for deg+1 doubles for the third lowest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrehilolo  space for deg+1 doubles for the second lowest doubles
 *                 of the real parts of the exp(-x) series;
 *   minxrelololo  space for deg+1 doubles for the lowest doubles
 *                 of the real parts of the exp(-x) series;
 *   minximhihihi  space for deg+1 doubles for the highest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximlohihi  space for deg+1 doubles for the second highest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximhilohi  space for deg+1 doubles for the third highest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximlolohi  space for deg+1 doubles for the fourth highest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximhihilo  space for deg+1 doubles for the fourth lowest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximlohilo  space for deg+1 doubles for the third lowest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximhilolo  space for deg+1 doubles for the second lowest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *   minximlololo  space for deg+1 doubles for the lowest doubles
 *                 of the imaginary parts of the exp(-x) series.
 *
 * ON RETURN :
 *   pluxrehihihi  highest doubles of the real parts of the exp(+x) series
 *                 truncated to degree deg;
 *   pluxrelohihi  second highest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrehilohi  third highest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrelolohi  fourth highest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrehihilo  fourth lowest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrelohilo  third lowest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrehilolo  second lowest doubles of the real parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluxrelololo  lowest doubles of the real parts of the exp(+x) series
 *                 truncated to degree deg;
 *   pluximhihihi  highest doubles of the imaginary parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluximlohihi  second highest doubles of the imaginary parts of the
 *                 exp(+x) series truncated to degree deg;
 *   pluximhilohi  third highest doubles of the imaginary parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluximlolohi  fourth highest doubles of the imaginary parts of the
 *                 exp(+x) series truncated to degree deg;
 *   pluximhihilo  fourth lowest doubles of the imaginary parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluximlohilo  third lowest doubles of the imaginary parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluximhilolo  second lowest doubles of the imaginary parts of the exp(+x)
 *                 series truncated to degree deg;
 *   pluximlololo  lowest doubles of the imaginary parts of the exp(+x) series 
 *                 truncated to degree deg;
 *   minxrehihihi  highest doubles of the real parts of the exp(-x) series
 *                 truncated to degree deg;
 *   minxrelohihi  second highest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrehilohi  third highest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrelolohi  fourth highest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrehihilo  fourth lowest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrelohilo  third lowest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrehilolo  second lowest doubles of the real parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minxrelololo  lowest doubles of the real parts of the exp(-x) series
 *                 truncated to degree deg;
 *   minximhihihi  highest doubles of the imaginary parts of the exp(-x) 
 *                 series truncated to degree deg;
 *   minximlohihi  second highest doubles of the imaginary parts of the
 *                 exp(-x) series truncated to degree deg;
 *   minximhilohi  third highest doubles of the imaginary parts of the
 *                 exp(-x) series truncated to degree deg;
 *   minximlolohi  fourth highest doubles of the imaginary parts of the
 *                 exp(-x) series truncated to degree deg;
 *   minximhihilo  fourth lowest doubles of the imaginary parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minximlohilo  third lowest doubles of the imaginary parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minximhilolo  second lowest doubles of the imaginary parts of the exp(-x)
 *                 series truncated to degree deg;
 *   minximlololo  lowest doubles of the imaginary parts of the exp(-x) series
 *                 truncated to degree deg. */

void random_cmplx8_exponentials
 ( int deg, 
   double *xrehihihi, double *xrelohihi, double *xrehilohi, double *xrelolohi,
   double *xrehihilo, double *xrelohilo, double *xrehilolo, double *xrelololo,
   double *ximhihihi, double *ximlohihi, double *ximhilohi, double *ximlolohi,
   double *ximhihilo, double *ximlohilo, double *ximhilolo, double *ximlololo,
   double *pluxrehihihi, double *pluxrelohihi,
   double *pluxrehilohi, double *pluxrelolohi,
   double *pluxrehihilo, double *pluxrelohilo,
   double *pluxrehilolo, double *pluxrelololo,
   double *pluximhihihi, double *pluximlohihi,
   double *pluximhilohi, double *pluximlolohi,
   double *pluximhihilo, double *pluximlohilo,
   double *pluximhilolo, double *pluximlololo,
   double *minxrehihihi, double *minxrelohihi,
   double *minxrehilohi, double *minxrelolohi,
   double *minxrehihilo, double *minxrelohilo,
   double *minxrehilolo, double *minxrelololo,
   double *minximhihihi, double *minximlohihi,
   double *minximhilohi, double *minximlolohi,
   double *minximhihilo, double *minximlohilo,
   double *minximhilolo, double *minximlololo );
/*
 * DESCRIPTION :
 *   Returns power series for exp(x) and exp(-x),
 *   truncated to degree deg for a random complex octo double x.
 *   Parameters are the same as cmplx8_exponentials, except that
 *   xrehihihi, xrelohihi, xrehilohi, xrelolohi, xrehihilo, xrelohilo,
 *   xrehilolo, xrelololo, ximhihihi, ximlohihi, ximhilohi, ximlolohi,
 *   ximhihilo, ximlohilo, ximhilolo, ximlololo are return parameters. */

#endif
