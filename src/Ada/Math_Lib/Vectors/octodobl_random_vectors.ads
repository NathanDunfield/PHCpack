with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Octo_Double_Vectors;
with OctoDobl_Complex_Vectors;

package OctoDobl_Random_Vectors is

-- DESCRIPTION :
--   Offers routines to generate vectors of random octo double numbers.
--   Either the seed remains hidden for the user, or the user can manage
--   the seed for independent and/or reproducible sequences of numbers.

  function Random_Vector ( first,last : integer32 )
                         return Octo_Double_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns a vector of range first..last with random octo doubles
  --   in the interval [-1,+1].

  procedure Random_Vector
              ( seed : in out integer32;
                v : out Octo_Double_Vectors.Vector );

  -- DESRIPTION :
  --   Given a seed, generates a vector v of random octo doubles,
  --   with each entry in [-1,+1].
  --   The seed is updated so the next call returns a different v.

  function Random_Vector ( first,last : integer32 )
                         return OctoDobl_Complex_Vectors.Vector;

  -- DESCRIPTION :
  --   Returns a vector of range first..last with random octo
  --   double complex numbers with real and imaginary parts in [-1,+1].

  procedure Random_Vector
              ( seed : in out integer32;
                v : out OctoDobl_Complex_Vectors.Vector );

  -- DESRIPTION :
  --   Given a seed, generates a vector v of random complex numbers of
  --   octo double precision with real and imaginary parts in [-1,+1].
  --   The seed is updated so the next call returns a different v.

end OctoDobl_Random_Vectors;
