with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Polynomial_Vectors;
with DoblDobl_Polynomial_Vectors;
with QuadDobl_Polynomial_Vectors;

package Random_Polynomial_Vectors is

-- DESCRIPTION :
--   A random polynomial vector is a vector of random polynomials.
--   A random polynomial is a vector of random monomials.
--   Each random monomial is defined by a random complex coefficient
--   and a vector of random natural numbers.

  function Standard_Random_Polynomial_Vector
             ( size,dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return Standard_Polynomial_Vectors.Polynomial_Vector;

  -- DESCRIPTION :
  --   On return is a vector of range 1..size of random polynomials.
  --   Each random polynomial is a vector of range 1..size of monomials.
  --   Each monomial has dimension dim and exponents are in range 0..expmax.
  --   The coefficients are double complex numbers.
  --   If verbose, then the coefficient and exponents are shown.

  function DoblDobl_Random_Polynomial_Vector
             ( size,dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return DoblDobl_Polynomial_Vectors.Polynomial_Vector;

  -- DESCRIPTION :
  --   On return is a vector of range 1..size of random polynomials.
  --   Each random polynomial is a vector of range 1..size of monomials.
  --   Each monomial has dimension dim and exponents are in range 0..expmax.
  --   The coefficients are double double complex numbers.
  --   If verbose, then the coefficient and exponents are shown.

  function QuadDobl_Random_Polynomial_Vector
             ( size,dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return QuadDobl_Polynomial_Vectors.Polynomial_Vector;

  -- DESCRIPTION :
  --   On return is a vector of range 1..size of random polynomials.
  --   Each random polynomial is a vector of range 1..size of monomials.
  --   Each monomial has dimension dim and exponents are in range 0..expmax.
  --   The coefficients are quad double complex numbers.
  --   If verbose, then the coefficient and exponents are shown.
 
end Random_Polynomial_Vectors;