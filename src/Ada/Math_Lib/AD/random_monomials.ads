with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Natural_Vectors;
with Standard_Complex_Monomials;
with DoblDobl_Complex_Monomials;
with QuadDobl_Complex_Monomials;

package Random_Monomials is

-- DESCRIPTION :
--   A random monomial is defined by a random complex coefficient
--   and a vector of random natural numbers.

  function Random_Exponents
             ( dim : integer32; expmax : natural32 )  
             return Standard_Natural_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns a vector of random exponents in the range 0..expmax,
  --   of dimension dim.

  function Standard_Random_Monomial
             ( dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return Standard_Complex_Monomials.Monomial;

  -- DESCRIPTION :
  --   Generates a random complex coefficient and an exponent vector
  --   of dimension dim, with entries in the range 0..expmax.
  --   The coefficient is a double complex number.
  --   If verbose, then the coefficient and exponents are shown.

  function DoblDobl_Random_Monomial
             ( dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return DoblDobl_Complex_Monomials.Monomial;

  -- DESCRIPTION :
  --   Generates a random complex coefficient and an exponent vector
  --   of dimension dim, with entries in the range 0..expmax.
  --   The coefficient is a double double complex number.
  --   If verbose, then the coefficient and exponents are shown.

  function QuadDobl_Random_Monomial
             ( dim : integer32; expmax : natural32;
               verbose : boolean := false )  
             return QuadDobl_Complex_Monomials.Monomial;

  -- DESCRIPTION :
  --   Generates a random complex coefficient and an exponent vector
  --   of dimension dim, with entries in the range 0..expmax.
  --   The coefficient is a quad double complex number.
  --   If verbose, then the coefficient and exponents are shown.
 
end Random_Monomials;