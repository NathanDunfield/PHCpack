with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Double_Double_Numbers;             use Double_Double_Numbers;
with Quad_Double_Numbers;               use Quad_Double_Numbers;

package Binomial_Coefficients is

-- DESCRIPTION :
--   Exports a function to compute binomial coefficients.

  function binomial ( n,k : integer32 ) return integer32;

  -- DESCRIPTION :
  --   Returns the binomial coefficient n choose k.

  function binomial ( n,k : integer32 ) return double_float;

  -- DESCRIPTION :
  --   Returns the binomial coefficient n choose k,
  --   computed with floating-point arithmetic to avoid
  --   integer arithmetic overflow.

  function binomial ( n,k : integer32 ) return double_double;

  -- DESCRIPTION :
  --   Returns the binomial coefficient n choose k,
  --   computed with double double arithmetic for more accuracy
  --   and to avoid integer arithmetic overflow.

  function binomial ( n,k : integer32 ) return quad_double;

  -- DESCRIPTION :
  --   Returns the binomial coefficient n choose k,
  --   computed with quad double arithmetic for even more accuracy
  --   and to avoid integer arithmetic overflow.

end Binomial_Coefficients;
