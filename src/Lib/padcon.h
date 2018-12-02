/* The file padcon.h contains prototypes to the path trackers which apply
 * Pade approximants to predict solutions, padcon = Pade continuation.
 * By default, compilation with gcc is assumed.
 * To compile with a C++ compiler such as g++,
 * the flag compilewgpp must be defined as "g++ -Dcompilewgpp=1." */

#ifndef __PADCON_H__
#define __PADCON_H__

#ifdef compilewgpp
extern "C" void adainit( void );
extern "C" int _ada_use_c2phc4c ( int task, int *a, int *b, double *c );
extern "C" void adafinal( void );
#else
extern void adainit( void );
extern int _ada_use_c2phc4c ( int task, int *a, int *b, double *c );
extern void adafinal( void );
#endif

void padcon_set_default_parameters ( void );
/*
 * DESCRIPTION :
 *   Sets the default values of the homotopy continuation parameters. */

void padcon_clear_parameters ( void );
/*
 * DESCRIPTION :
 *   Deallocates the allocated space for the parameters. */

int padcon_get_homotopy_continuation_parameter ( int k, double *val );
/*
 * DESCRIPTION :
 *   Returns in val the value of the k-th continuation parameter,
 *   if k ranges between 1 and 12.
 *
 * ON ENTRY :
 *   k        an integer number between 1 and 12.
 *
 * ON RETURN 
 *   val      the value for the k-th homotopy continuation parameter. */

int padcon_set_homotopy_continuation_parameter ( int k, double *val );
/*
 * DESCRIPTION :
 *   Sets the value of the k-th continuation parameter to val,
 *   if k ranges between 1 and 12.
 *
 * ON ENTRY :
 *   k        an integer number between 1 and 12.
 *
 * ON RETURN 
 *   val      the value for the k-th homotopy continuation parameter. */

#endif
