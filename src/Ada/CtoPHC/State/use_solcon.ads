with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

function use_solcon ( job : integer32;
                      a : C_intarrs.Pointer;
                      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32;

-- DESCRIPTION :
--   Provides a gateway to the solutions container.

-- ON ENTRY :
--   job     =   0 : read solutions from file and put in container;
--           =   1 : write solutions in the container;
--           =   2 : return in b the length of the container;
--           =   3 : return in b the dimension of the solution vectors;
--           =   4 : return in b the multiplicity m of the solution (# in a),
--                          in c the solution as an array of 2*n+5 doubles,
--            in the following order:
--                   two doubles for the complex continuation parameter t,
--                   2*n doubles for the coefficients of the solution vector,
--                   one double for the norm of last Newton update,
--                   one double for the inverse of condition# estimate,
--                   one double for the norm of the residual;
--           =   5 : changes the solution with number in to the values 
--                   in b and c, where b is the array (n,m),
--                   where n is the dimension and m the multiplicity;
--           =   6 : appends the solution with data in b  = (n,m) and
--                   (also see job = 4 for info) to the container;
--           =   7 : clears all solutions from the container;
--           =   8 : replaces the solutions in the container by solutions
--                   with the coordinate with index a[0] dropped
--           =   9 : replaces the solutions in the container by solutions
--                   with the coordinate with name in b 
--                   and #characters in a[0] dropped
--           =  10 : prompts the user for a file name for solutions,
--                   which is then opened for opened for input;
--           =  11 : prompts the user for a file name for solutions,
--                   which is then created for output;
--           =  12 : scans the file till after "SOLUTIONS", this scanning
--                   is needed if the file starts with a system;
--           =  13 : reads from file (opened by job 10) the length and 
--                   dimension of the solutions on file;
--           =  14 : writes to file (created by job 10) the length and
--                   dimension of the solutions on file;
--           =  15 : reads the next solution from file (opened by job 10)
--                   where a must contain the length of the solution vector,
--                   on return is the data in b and c as in job 4;
--           =  16 : writes the next solution to file (created by job 11)
--                   with the number in a and data in b and c as in job 4,
--                   on return is in a the updated counter;
--           =  17 : close solution input file;
--           =  18 : close solution output file.
--           =  19 : writes "THE SOLUTIONS" banner to the defined output file;
--           =  20 : writes the length and dimension of the solutions to
--                   the defined output file;
--           =  21 : writes the next solution to the defined output file,
--                   as defined by the package PHCpack_Operations.
--
--           =  22 : computes next solution of total degree start system,
--                   on entry in a is the dimension and the solution number,
--                   on return is the data in b and c as in job 4;
--           =  23 : computes next solution of linear product start system,
--                   on entry is in a the dimension and solution counter,
--                   on return is the data in b and c as in job 4,
--                   with in a the updated counter from the loop;
--           =  24 : solves one linear system to find a solution of a
--                   linear-product start system, indexed by the data
--                   on entry in a the dimension and solution number,
--                   on return is the data in b and c as in job 4;
--           =  25 : reads the next witness point from file for the set whose
--                   index is either 1 or 2, according to the value of a,
--                   on return is the data in b and c as in job 4.
--
--           =  30 : in a is given a solution number, returns in b the number
--                   of characters to write the entire solution as string;
--           =  31 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the entire string,
--                   returns in b the string representation of the solution;
--           =  32 : in a is given a solution number, returns in b the number
--                   of characters to write the solution intro as string;
--           =  33 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the solution intro string,
--                   returns in b the string representation of the intro;
--           =  34 : in a is given a solution number, returns in b the number
--                   of characters to write the solution vector as string;
--           =  35 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the solution vector string,
--                   returns in b the string representation of the vector;
--           =  36 : in a is given a solution number, returns in b the number
--                   of characters to write the solution diagnostics as string;
--           =  37 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the solution diagnostics,
--                   returns in b the string representation of the diagnostics;
--           =  38 : on input in a[0] is the number of variables 
--                   and in a[1] is the length of characters in the string
--                   representation of a solution stored in b, the solution
--                   will be appended to the solutions container.
--           =  39 : on input in a[0] is k the index to a solution,
--                   and in a[1] is the number of variables,
--                   and in a[2] is the length of characters in the string
--                   representation of a solution stored in b, the solution
--                   k will be replaced in the solutions container.
--
-- CORRESPONDING JOBS for containers of DOUBLE DOUBLE solutions :
-- 
--   job     =  40 : read solutions from file and put in container;
--           =  41 : write solutions in the container;
--           =  42 : return in b the length of the container;
--           =  43 : return in b the dimension of the solution vectors;
--           =  44 : return in b the multiplicity m of the solution (# in a),
--                          in c the solution as an array of 4*n+10 doubles,
--           in the following order:
--                   two double doubles for the complex parameter t,
--                   4*n doubles for the coefficients of the solution vector,
--                   one double double for the norm of last Newton update,
--                   one double double for the inverse of condition# estimate,
--                   one double double for the norm of the residual;
--           =  45 : changes the double double solution with data in b and c,
--                   as the double double equivalent to job 5;
--           =  46 : appends the solution with data in b  = (n,m) and
--                   (also see job = 44 for info) to the container;
--           =  47 : clears all solutions from the container;
--           =  48 : replaces the solutions in the container by solutions
--                   with the coordinate with index a[0] dropped
--           =  49 : replaces the solutions in the container by solutions
--                   with the coordinate with name in b 
--                   and #characters in a[0] dropped
--           =  70 : in a is given a solution number, returns in b the number
--                   of characters to write the entire solution as string;
--           =  71 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the entire string,
--                   returns in b the string representation of the solution;
--           =  78 : on input in a[0] is the number of variables 
--                   and in a[1] is the length of characters in the string
--                   representation of a solution stored in b, the solution
--                   will be appended to the solutions container.
--
-- CORRESPONDING JOBS for containers of MULTIPRECISION solutions :
-- 
--   job     = 120 : read solutions from file and put in container;
--           = 121 : write solutions in the container;
--           = 122 : return in b the length of the container;
--           = 123 : return in b the dimension of the solution vectors;
--           = 127 : clears all solutions in the container;
--           = 150 : in a is given a solution number, returns in b the number
--                   of characters to write the entire solution as string;
--           = 151 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the entire string,
--                   returns in b the string representation of the solution;
--           = 158 : on input in a[0] is the number of variables 
--                   and in a[1] is the length of characters in the string
--                   representation of a solution stored in b, the solution
--                   will be appended to the solutions container.
--
-- CORRESPONDING JOBS for containers of QUAD DOUBLE solutions :
-- 
--   job     =  80 : read solutions from file and put in container;
--           =  81 : write solutions in the container;
--           =  82 : return in b the length of the container;
--           =  83 : return in b the dimension of the solution vectors;
--           =  84 : return in b the multiplicity m of the solution (# in a),
--                          in c the solution as an array of 8*n+20 doubles,
--           in the following order:
--                   two quad doubles for the complex parameter t,
--                   8*n doubles for the coefficients of the solution vector,
--                   one quad double for the norm of last Newton update,
--                   one quad double for the inverse of condition# estimate,
--                   one quad double for the norm of the residual;
--           =  85 : changes the quad double solution with data in b and c,
--                   as the quad double equivalent to job 5;
--           =  86 : appends the solution with data in b  = (n,m) and
--                   (also see job = 84 for info) to the container;
--           =  87 : clears all solutions from the container;
--           =  88 : replaces the solutions in the container by solutions
--                   with the coordinate with index a[0] dropped
--           =  89 : replaces the solutions in the container by solutions
--                   with the coordinate with name in b 
--                   and #characters in a[0] dropped
--           = 110 : in a is given a solution number, returns in b the number
--                   of characters to write the entire solution as string;
--           = 111 : on input in a[0] is a solution number and in a[1] is
--                   the number of characters for the entire string,
--                   returns in b the string representation of the solution;
--           = 118 : on input in a[0] is the number of variables 
--                   and in a[1] is the length of characters in the string
--                   representation of a solution stored in b, the solution
--                   will be appended to the solutions container.
--
-- RETRIEVE NEXT SOLUTION :
--
--   job     = 276 : if a[0] = 0 on entry, then the pointer to the current
--                   solution in the standard solutions container will be
--                   reset to the first solution, otherwise
--                   returns in b the multiplicity m of the current solution
--                   and in c the current solution as an array of 2*n+5
--                   doubles, in the following order:
--                   two doubles for the complex continuation parameter t,
--                   2*n doubles for the coefficients of the solution vector,
--                   one double for the norm of last Newton update,
--                   one double for the inverse of condition# estimate,
--                   one double for the norm of the residual;
--   job     = 277 : if a[0] = 0 on entry, then the pointer to the current
--                   solution in the dobldobl solutions container will be
--                   reset to the first solution, otherwise
--                   returns in b the multiplicity m of the current solution,
--                   and in c the current solution as an array of 4*n+10
--                   doubles, in the following order:
--                   two double doubles for the complex parameter t,
--                   4*n doubles for the coefficients of the solution vector,
--                   one double double for the norm of last Newton update,
--                   one double double for the inverse of condition# estimate,
--                   one double double for the norm of the residual;
--   job     = 278 : if a[0] = 0 on entry, then the pointer to the current
--                   solution in the quaddobl solutions container will be
--                   reset to the first solution, otherwise
--                   returns in b the multiplicity m of the current solution,
--                   and in c the current solution as an array of 8*n+20
--                   doubles, in the following order:
--                   two quad doubles for the complex parameter t,
--                   8*n doubles for the coefficients of the solution vector,
--                   one quad double for the norm of last Newton update,
--                   one quad double for the inverse of condition# estimate,
--                   one quad double for the norm of the residual.
--           = 279 : initializes the pointer to the current solution in the
--                   multiprecision container to the first solution.
--
-- MOVE POINTER to next solution in container :
--
--   job     = 300 : moves the pointer to the next standard solution
--                   in then container and returns in a[0] the cursor
--                   of the current solution, 0 if there is no solution;
--           = 301 : moves the pointer to the next dobldobl solution
--                   in then container and returns in a[0] the cursor
--                   of the current solution, 0 if there is no solution;
--           = 302 : moves the pointer to the next quaddobl solution
--                   in then container and returns in a[0] the cursor
--                   of the current solution, 0 if there is no solution;
--           = 303 : moves the pointer to the next multprec solution
--                   in then container and returns in a[0] the cursor
--                   of the current solution, 0 if there is no solution.
--
-- RETURN LENGTH of the current solution string :
--
--           = 304 : returns in a[0] the value of the cursor of the current
--                   standard solution and if a[0] is nonzero, then in b[0]
--                   is the length of the current standard solution string;
--           = 305 : returns in a[0] the value of the cursor of the current
--                   dobldobl solution and if a[0] is nonzero, then in b[0]
--                   is the length of the current dobldobl solution string;
--           = 306 : returns in a[0] the value of the cursor of the current
--                   quaddobl solution and if a[0] is nonzero, then in b[0]
--                   is the length of the current quaddobl solution string;
--           = 307 : returns in a[0] the value of the cursor of the current
--                   multprec solution and if a[0] is nonzero, then in b[0]
--                   is the length of the current multprec solution string.
--
-- RETURN CURRENT solution string :
--
--           = 308 : given in a[0] the length of the current standard solution
--                   string, returns in a[0] the value of the cursor to the
--                   current standard solution an if a[0] is nonzero, then
--                   in b on return is the current standard solution string;
--           = 309 : given in a[0] the length of the current dobldobl solution
--                   string, returns in a[0] the value of the cursor to the
--                   current dobldobl solution an if a[0] is nonzero, then
--                   in b on return is the current dobldobl solution string;
--           = 310 : given in a[0] the length of the current quaddobl solution
--                   string, returns in a[0] the value of the cursor to the
--                   current quaddobl solution an if a[0] is nonzero, then
--                   in b on return is the current quaddobl solution string;
--           = 311 : given in a[0] the length of the current multprec solution
--                   string, returns in a[0] the value of the cursor to the
--                   current multprec solution an if a[0] is nonzero, then
--                   in b on return is the current multprec solution string.
--
-- operations to read a system and its solutions into the containers :
--
--   job     = 544 : reads a standard system into the systems container 
--                   and its solutions into the solutions container where the
--                   file name is given as a string of n = a[0] characters,
--                   with the n characters are stored in given b on input;
--   job     = 545 : reads a double double system into the systems container
--                   and its solutions into the solutions container where the
--                   file name is given as a string of n = a[0] characters,
--                   with the n characters are stored in given b on input;
--   job     = 546 : reads a quad double system into the systems container
--                   and its solutions into the solutions container where the
--                   file name is given as a string of n = a[0] characters,
--                   with the n characters are stored in given b on input;
--   job     = 547 : reads a multiprecision system into the systems container
--                   and its solutions into the solutions container where the
--                   file name is given as a string of n = a[0] characters,
--                   with the n characters are stored in given b on input,
--                   the value of a[1] stores the number of decimal places
--                   as the precision for parsing the numbers;
--
-- setting the value of the continuation parameter to zero :
--
--   job     = 875 : sets the value of the continuation parameter to zero
--                   for all the solutions in the standard double precision
--                   solutions container;
--   job     = 876 : sets the value of the continuation parameter to zero
--                   for all the solutions in the double double precision
--                   solutions container;
--   job     = 877 : sets the value of the continuation parameter to zero
--                   for all the solutions in the quad double precision
--                   solutions container.
--
--   a       indicates the number of solution to work on;
--   b       array with allocated memory for integers,
--           usually only len, n, m, or the array (n,m),
--           where len is the length of the container;
--                 n is the dimension of the solution vectors; and
--                 m is the multiplicity of the solution;
--   c       array with allocated memory for double floats to store
--           the complex value for the continuation paramter t,
--           the complex coefficients (real and imaginary parts)
--           of the solution vector, err, rco, and res.
--
-- projective coordinate transformations :
--
--   job     = 894 : to the solutions in double precision,
--                   applies a 1-homogeneous projective transformation,
--                   augmenting every solution with one as extra coordinate;
--           = 895 : to the solutions in double double precision,
--                   applies a 1-homogeneous projective transformation,
--                   augmenting every solution with one as extra coordinate;
--           = 896 : to the solutions in quad double precision,
--                   applies a 1-homogeneous projective transformation,
--                   augmenting every solution with one as extra coordinate;
--           = 898 : transforms the solutions in double precision
--                   into affine coordinates, dividing every coordinate
--                   by the value of the last coordinate of the solution;
--           = 899 : transforms the solutions in double double precision
--                   into affine coordinates, dividing every coordinate
--                   by the value of the last coordinate of the solution;
--           = 900 : transforms the solutions in quad double precision
--                   into affine coordinates, dividing every coordinate
--                   by the value of the last coordinate of the solution.

-- ON RETURN :
--   0 if operation was successful, otherwise something went wrong,
--   like accessing a solution which is not there or having a job
--   outside the range of job numbers that are defined.
