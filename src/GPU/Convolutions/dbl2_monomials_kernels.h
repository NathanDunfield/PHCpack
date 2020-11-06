// The file dbl2_monomials_kernels.h specifies functions to evaluate and
// differentiate a monomial at power series truncated to the same degree,
// in double double precision.

#ifndef __dbl2_monomials_kernels_h__
#define __dbl2_monomials_kernels_h__

__device__ void dbl2_convolute
 ( double *xhi, double *xlo, double *yhi, double *ylo,
   double *zhi, double *zlo, int dim, int k );
/*
 * DESCRIPTION :
 *   Thread k returns in z[k] the k-th component of the convolution
 *   of x and y, with high and low parts in hi and lo arrays.
 *   All vectors are of dimension dim. */

__device__ void cmplx2_convolute
 ( double *xrehi, double *xrelo, double *ximhi, double *ximlo,
   double *yrehi, double *yrelo, double *yimhi, double *yimlo,
   double *zrehi, double *zrelo, double *zimhi, double *zimlo,
   int dim, int k );
/*
 * DESCRIPTION :
 *   Thread k returns in z[k] the k-th component of the convolution
 *   of x and y, with real and imaginary parts in re and im arrays,
 *   and high and low parts in hi and lo arrays.
 *   All arrays are of dimension dim. */

__global__ void GPU_dbl2_speel
 ( int nvr, int deg, int *idx, double *cffhi, double *cfflo, double *inputhi,
   double *inputlo, double *forwardhi, double *forwardlo, double *backwardhi,
   double *backwardlo, double *crosshi, double *crosslo );
/*
 * DESCRIPTION :
 *   Runs the reverse mode of algorithmic differentiation
 *   of a product of variables at power series truncated to the same degree,
 *   for real coefficients in double double precision.
 *
 * REQUIRED : nvr > 2.
 *
 * ON ENTRY :
 *   nvr        number of variables in the product;
 *   deg        truncation degree of the series;
 *   idx        as many indices as the value of nvr,
 *              idx[k] defines the place of the k-th variable,
 *              with input values in input[idx[k]];
 *   cffhi      deg+1 doubles for high doubles of the coefficient series;
 *   cfflo      deg+1 doubles for low doubles of the coefficient series;
 *   inputhi    contains the high doubles of the coefficients of the series
 *              for all variables in the monomial;
 *   inputlo    contains the high doubles of the coefficients of the series
 *              for all variables in the monomial;
 *   forwardhi  contains work space for the high doubles of all nvr-1 forward
 *              products, forwardhi[k] contains space for deg+1 doubles;
 *   forwardlo  contains work space for the high doubles of all nvr-1 forward
 *              products, forwardlo[k] contains space for deg+1 doubles;
 *   backwardhi contains work space for the high doubles of all nvr-2 backward
 *              products, backwardhi[k] contains space for deg+1 doubles;
 *   backwardlo contains work space for the high doubles of all nvr-2 backward
 *              products, backwardlo[k] contains space for deg+1 doubles;
 *   crosshi    contains work space for the high doubles of all nvr-2 cross
 *              products, crosshi[k] contains space for deg+1 doubles;
 *   crosslo    contains work space for the high doubles of all nvr-2 cross
 *              products, crosslo[k] contains space for deg+1 doubles.
 *
 * ON RETURN :
 *   forwardhi  accumulates the high doubles of the forward products,
 *   forwardlo  accumulates the low doubles of the forward products,
 *              forward[nvr-1] contains the value of the product,
 *              forward[nvr-2] contains the derivative with respect
 *              to the last variable idx[nvr-1] if nvr > 2;
 *   backwardhi accumulates the high doubles of the backward products,
 *   backwardlo accumulates the low doubles of the backward products,
 *              backward[nvr-3] contains the derivative with respect
 *              to the first variable idx[0] if nvr > 2;
 *   crosshi    stores the high doubles of the cross products,
 *   crosslo    stores the low doubles of the cross products,
 *              cross[k] contains the derivatve with respect to
 *              variable idx[k+1]. */

__global__ void GPU_cmplx2_speel
 ( int nvr, int deg, int *idx,
   double *cffrehi, double *cffrelo, double *cffimhi, double *cffimlo,
   double *inputrehi, double *inputrelo, double *inputimhi, double *inputimlo,
   double *forwardrehi, double *forwardrelo, double *forwardimhi,
   double *forwardimlo, double *backwardrehi, double *backwardrelo,
   double *backwardimhi, double *backwardimlo, double *crossrehi,
   double *crossrelo, double *crossimhi, double *crossimlo );
/*
 * DESCRIPTION :
 *   Runs the reverse mode of algorithmic differentiation
 *   of a product of variables at power series truncated to the same degree,
 *   for real coefficients in double double precision.
 *
 * REQUIRED : nvr > 2.
 *
 * ON ENTRY :
 *   nvr          number of variables in the product;
 *   deg          truncation degree of the series;
 *   idx          as many indices as the value of nvr,
 *                idx[k] defines the place of the k-th variable,
 *                with input values in input[idx[k]];
 *   cffrehi      high doubles of the real parts of the series coefficient
 *                the product;
 *   cffrelo      low doubles of the real parts of the series coefficient
 *                of the product;
 *   cffimhi      high doubles of the imaginary pars of the series coefficient
 *                of the product;
 *   cffimlo      high doubles of the imaginary pars of the series coefficient
 *                of the product;
 *   inputrehi    contains the high doubles of the real parts of the
 *                coefficients of the series for all variables;
 *   inputrelo    contains the low doubles of the real parts of the
 *                coefficients of the series for all variables;
 *   inputimhi    contains the high doubles of the imaginary parts of the
 *                coefficients of the series for all variables;
 *   inputimlo    contains the high doubles of the imaginary parts of the
 *                coefficients of the series for all variables;
 *   forwardrehi  contains work space for the high doubles of nvr-1 forward
 *                products, for all real parts of the coefficients,
 *                forwardrehi[k] contains space for deg+1 doubles;
 *   forwardrelo  contains work space for the low doubles of nvr-1 forward
 *                products, for all real parts of the coefficients,
 *                forwardrelo[k] contains space for deg+1 doubles;
 *   forwardimhi  contains work space for the high doubles of nvr forward
 *                products, for all imaginary parts of the coefficients,
 *                forwardimhi[k] contains space for deg+1 doubles;
 *   forwardimlo  contains work space for the high doubles of nvr forward
 *                products, for all imaginary parts of the coefficients,
 *                forwardimlo[k] contains space for deg+1 doubles;
 *   backwardrehi contains work space for all high doubles of nvr-2 backward
 *                products, for all real parts of the coefficients,
 *                backwardrehi[k] contains space for deg+1 doubles;
 *   backwardrelo contains work space for all low doubles of nvr-2 backward
 *                products, for all real parts of the coefficients,
 *                backwardrelo[k] contains space for deg+1 doubles;
 *   backwardimhi contains work space for the high doubles of nvr-2 backward
 *                products, for all imaginary parts of the coefficients,
 *                backwardimhi[k] contains space for deg+1 doubles;
 *   backwardimlo contains work space for the low doubles of nvr-2 backward
 *                products, for all imaginary parts of the coefficients,
 *                backwardimlo[k] contains space for deg+1 doubles;
 *   crossrehi    contains work space for the high doubles of nvr-2 cross
 *                products,for the real parts of the coefficients,
 *                crossrehi[k] contains space for deg+1 doubles;
 *   crossrelo    contains work space for the low doubles of nvr-2 cross
 *                products,for the real parts of the coefficients,
 *                crossrelo[k] contains space for deg+1 doubles;
 *   crossimhi    contains work space for the high doubles of nvr-2 cross
 *                products, for the imaginary parts of the coefficients,
 *                crossrelo[k] contains space for deg+1 doubles.
 *
 * ON RETURN :
 *   forwardrehi  accumulates the high doubles of the real parts
 *                of the forward products,
 *   forwardrelo  accumulates the low doubles of the real parts
 *                of the forward products,
 *   forwardimhi  accumulates the high doubles of the imaginary parts
 *                of the forward products,
 *   forwardimlo  accumulates the low doubles of the imaginary parts
 *                of the forward products,
 *                forward[nvr-1] contains the value of the product,
 *                forward[nvr-2] contains the derivative with respect
 *                to the last variable idx[nvr-1];
 *   backwardrehi accumulates the high doubles of the real parts
 *                of the backward products,
 *   backwardrelo accumulates the low doubles of the real parts
 *                of the backward products,
 *   backwardrehi accumulates the high doubles of the imaginary parts of 
 *                the backward products,
 *   backwardrelo accumulates the low doubles of the imaginary parts of 
 *                the backward products,
 *                backward[nvr-3] contains the derivative with respect
 *                to the first variable idx[0];
 *   crossrehi    stores the high doubles of the real parts
 *                of the cross products,
 *   crossrelo    stores the low doubles of the real parts
 *                of the cross products,
 *   crossimhi    stores the high doubles of the imaginary parts
 *                of the cross products,
 *   crossimlo    stores the low doubles of the imaginary parts
 *                of the cross products,
 *                cross[k] contains the derivatve with respect to
 *                variable idx[k+1]. */

void GPU_dbl2_evaldiff
 ( int BS, int dim, int nvr, int deg, int *idx, double *cffhi, double *cfflo,
   double **inputhi, double **inputlo, double **outputhi, double **outputlo );
/*
 * DESCRIPTION :
 *   Allocates work space memory to store the forward, backward, and
 *   cross products in the evaluation and differentiation of a monomial.
 *
 * ON ENTRY :
 *   BS       number of threads in one block, must be deg+1;
 *   dim      total number of variables;
 *   deg      truncation degree of the series;
 *   idx      as many indices as the value of nvr,
 *            idx[k] defines the place of the k-th variable,
 *            with input values in input[idx[k]];
 *   cffhi    high doubles of the coefficient series of the product;
 *   cfflo    low doubles of the coefficient series of the product;
 *   inputhi  contains the high doubles of the coefficients of the series
 *            for all variables in the monomial;
 *   inputlo  contains the low doubles of the coefficients of the series
 *            for all variables in the monomial;
 *   outputhi has space allocated for dim+1 series of degree deg;
 *   outputlo has space allocated for dim+1 series of degree deg.
 *
 * ON RETURN :
 *   outputhi contains the high doubles of the derivatives and 
 *            the value of the monomial,
 *   outputlo contains the low doubles of the derivatives and 
 *            the value of the monomial,
 *            output[idx[k]], for k from 0 to nvr, contains the
 *            deriviative with respect to the variable idx[k];
 *            output[dim] contains the value of the product. */

void GPU_cmplx2_evaldiff
 ( int BS, int dim, int nvr, int deg, int *idx,
   double *cffrehi, double *cffrelo, double *cffimhi, double *cffimlo,
   double **inputrehi, double **inputrelo, double **inputimhi,
   double **inputimlo, double **outputrehi, double **outputrelo,
   double **outputimhi, double **outputimlo );
/*
 * DESCRIPTION :
 *   Allocates work space memory to store the forward, backward, and
 *   cross products in the evaluation and differentiation of a monomial.
 *
 * ON ENTRY :
 *   BS         number of threads in one block, must be deg+1;
 *   dim        total number of variables;
 *   deg        truncation degree of the series;
 *   idx        as many indices as the value of nvr,
 *              idx[k] defines the place of the k-th variable,
 *              with input values in input[idx[k]];
 *   cffrehi    high doubles of the real parts of the coefficient series
 *              of the product;
 *   cffrelo    low doubles of the real parts of the coefficient series
 *              of the product;
 *   cffimhi    high doubles of the imaginary parts of the coefficient series
 *              of the product;
 *   cffimlo    low doubles of the imaginary parts of the coefficient series
 *              of the product;
 *   inputrehi  contains the high doubles of the real parts of the
 *              coefficients of the series for all variables in the monomial;
 *   inputrelo  contains the low doubles of the real parts of the coefficients
 *              of the series for all variables in the monomial;
 *   inputimhi  contains the high doubles of the imaginary parts of the
 *              coefficients of the series for all variables in the monomial;
 *   inputimlo  contains the low doubles of the imaginary parts of the
 *              coefficients of the series for all variables in the monomial;
 *   outputrehi has space allocated for dim+1 series of degree deg, for the
 *              high doubles of the real parts of the output coefficients;
 *   outputrelo has space allocated for dim+1 series of degree deg, for the
 *              low doubles of the real parts of the output coefficients;
 *   outputimhi has space allocated for dim+1 series of degree deg, for the
 *              high doubles of the imaginary parts of the output;
 *   outputimlo has space allocated for dim+1 series of degree deg, for the
 *              low doubles of the imaginary parts of the output;
 *
 * ON RETURN :
 *   outputrehi contains the high doubles of the real parts of the
 *              derivatives and the value,
 *   outputrelo contains the low doubles of the real parts of the
 *              derivatives and the value,
 *   outputimhi contains the high doubles of the imaginary parts of the 
 *              derivatives and the value,
 *   outputimlo contains the low doubles of the imaginary parts of the 
 *              derivatives and the value,
 *              output[idx[k]], for k from 0 to nvr, contains the
 *              deriviative with respect to the variable idx[k];
 *              output[dim] contains the value of the product. */

#endif
