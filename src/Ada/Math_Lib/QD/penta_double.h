/* file: penta_double.h */

/* This file contains the header files for a standalone,
   self-contained collection of routines for penta double arithmetic,
   based on the CAMPARY and the QD software libraries.

All functions in this library have the prefix pd_
to avoid potential name clashes with other multiple doubles. */

#ifndef __penta_double_h__
#define __penta_double_h__

/************************* normalizations ************************/

void pd_renorm5
 ( double f0, double f1, double f2, double f3, double f4, double f5,
   double *pr, double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   Definitions common to fast_renorm2L<6,5> and renorm2L_4Add1<5,5>
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   f0       most significant word;
 *   f1       second most significant word;
 *   f2       third most significant word;
 *   f3       fourth most significant word;
 *   f4       fifth most significant word;
 *   f5       sixth most significant word;
 *   pr       computed by the start of the renormalization.
 *
 * ON RETURN :
 *   pr       updated value by renormalization;
 *   r0       highest part of a penta double number;
 *   r1       second highest part of a penta double number;
 *   r2       middle part of a penta double number.
 *   r3       second lowest part of a penta double number;
 *   r4       lowest part of a penta double number. */

void pd_fast_renorm
 ( double x0, double x1, double x2, double x3, double x4, double x5,
   double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   The definition is based on the fast_renorm2L<6,5>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word;
 *   x1       second most significant word;
 *   x2       third most significant word;
 *   x3       fourth most significant word;
 *   x4       fifth most significant word;
 *   x5       least significant word.
 *
 * ON RETURN :
 *   r0       highest part of a penta double number;
 *   r1       second highest part of a penta double number;
 *   r2       middle part of a penta double number.
 *   r3       second lowest part of a penta double number;
 *   r4       lowest part of a penta double number. */

void pd_renorm_add1
 ( double x0, double x1, double x2, double x3, double x4, double y,
   double *r0, double *r1, double *r2, double *r3, double *r4 );
/*
 * DESCRIPTION :
 *   The definition is based on the renorm2L_4Add1<5,5>,
 *   from code of the specRenorm.h, generated by the CAMPARY library,
 *   in an unrolled form (Valentina Popescu, Mioara Joldes), with
 *   double double basics of QD-2.3.9 (Y. Hida, X.S. Li, and D.H. Bailey).
 *
 * ON ENTRY :
 *   x0       most significant word of a penta double x;
 *   x1       second most significant word of a penta double x;
 *   x2       third most significant word of a penta double x;
 *   x3       fourth most significant word of a penta double x;
 *   x4       least significant word of a penta double x;
 *   y        double to be added to x.
 *
 * ON RETURN :
 *   r0       highest part of x + y;
 *   r1       second highest part of x + y;
 *   r2       middle part of x + y;
 *   r3       second lowest part of x + y;
 *   r4       lowest part of x + y. */

/****************************** copy *****************************/

void pd_copy ( const double *a, double *b );
/*
 * DESCRIPTION :
 *   Copies the content of the penta double a to the penta double b. */

/******************* addition and subtraction *********************/

/* penta double = penta double + penta double */
void pd_add ( const double *a, const double *b, double *c );
/*
 * DESCRIPTION : c = a + b, or in words:
 *   Adds two penta doubles in a and b to make the penta double c. */

/* penta double = penta double + double */
void pd_add_pd_d ( const double *a, double b, double *c );
/*
 * DESCRIPTION : c = a + b, or in words:
 *   Adds the penta doubles in a and the double b
 *   to make the penta double c. */

/* penta double = - penta double */
void pd_minus ( double *a );
/*
 * DESCRIPTION :
 *   Flips the sign of a. */

/* penta double = penta double + penta double */
void pd_sub ( const double *a, const double *b, double *c );
/*
 * DESCRIPTION : c = a - b, or in words:
 *   Subtracts from the penta doubles in a
 *   the penta double in b to make the penta double c. */

/**************  multiplications and division ***********************/

/* penta double = penta double * penta double */
void pd_mul ( const double *a, const double *b, double *c );
/*
 * DESCRIPTION : c = a * b, or in words:
 *   Multiples the penta doubles a and b to make the penta double c. */

/* penta double = penta double * double */
void pd_mul_pd_d ( const double *a, double b, double *c );
/*
 * DESCRIPTION : c = a * b, or in words:
 *   Multiples the penta double a with the double b
 *   to make the penta double c. */

/* penta double = penta double / penta double */
void pd_div ( const double *a, const double *b, double *c );
/*
 * DESCRIPTION : c = a / b, or in words:
 *   Divides the penta double a by the penta double b
 *   to make the penta double c. */

/******************** random number generator **************************/

void pd_random ( double *x );
/*
 * DESCRIPTION :
 *   Returns in x a random penta double number in [0,1]. */

/************************ basic output *********************************/

void pd_write_doubles ( const double* x );
/*
 * DESCRIPTION :
 *   Writes the doubles in the penta double number x. */

#endif /* __penta_double_h__ */
