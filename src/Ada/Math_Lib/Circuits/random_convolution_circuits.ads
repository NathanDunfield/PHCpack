with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_VecVecs;
with Standard_Complex_VecVecs;
with DoblDobl_Complex_VecVecs;
with QuadDobl_Complex_VecVecs;
with Standard_Speelpenning_Convolutions;
with DoblDobl_Speelpenning_Convolutions;
with QuadDobl_Speelpenning_Convolutions;

package Random_Convolution_Circuits is

-- DESCRIPTION :
--   The functions in this package return random convolution circuits,
--   mainly for testing and benchmarking purposes.

  function Random_Exponents
             ( dim,nbr : integer32; pwr : integer32 := 1 ) 
             return Standard_Integer_VecVecs.VecVec;

  -- DESCRIPTION :
  --   Generates as many random vectors of dimension dim
  --   as the value of nbr.  All vectors have a nonzero sum.
  --   The higher power equals pow.

  function Standard_Random_Convolution_Circuit
             ( dim,deg,nbr,pwr : integer32 )
             return Standard_Speelpenning_Convolutions.Circuit;
  function DoblDobl_Random_Convolution_Circuit
             ( dim,deg,nbr,pwr : integer32 )
             return DoblDobl_Speelpenning_Convolutions.Circuit;
  function QuadDobl_Random_Convolution_Circuit
             ( dim,deg,nbr,pwr : integer32 )
             return QuadDobl_Speelpenning_Convolutions.Circuit;

  -- DESCRIPTION :
  --   Generates a sequence of random exponents and coefficients
  --   in double, double double, or quad double precision,
  --   and returns a convolution circuit.

  -- ON ENTRY :
  --   dim      dimension of the exponent vectors;
  --   deg      degree of the power series;
  --   nbr      number of products;
  --   pwr      largest power of the variables.

  function Standard_Random_Convolution_Circuits
             ( dim,deg,nbr,pwr : integer32 )
             return Standard_Speelpenning_Convolutions.Circuits;
  function DoblDobl_Random_Convolution_Circuits
             ( dim,deg,nbr,pwr : integer32 )
             return DoblDobl_Speelpenning_Convolutions.Circuits;
  function QuadDobl_Random_Convolution_Circuits
             ( dim,deg,nbr,pwr : integer32 )
             return QuadDobl_Speelpenning_Convolutions.Circuits;

  -- DESCRIPTION :
  --   Generates a sequence of random exponents and coefficients
  --   in double, double double, or quad doble precision,
  --   and returns as many convolution circuits as the value of dim.

  -- ON ENTRY :
  --   dim      dimension of the exponent vectors;
  --   deg      degree of the power series;
  --   nbr      number of products;
  --   pwr      largest power of the variables.

  function Standard_Random_System
             ( dim,deg,nbr,pwr : integer32 )
             return Standard_Speelpenning_Convolutions.Link_to_System;
  function DoblDobl_Random_System
             ( dim,deg,nbr,pwr : integer32 )
             return DoblDobl_Speelpenning_Convolutions.Link_to_System;
  function QuadDobl_Random_System
             ( dim,deg,nbr,pwr : integer32 )
             return QuadDobl_Speelpenning_Convolutions.Link_to_System;

  -- DESCRIPTION :
  --   Wrappers to the above functions to generate random convolution
  --   circuits in double, double double, and quad double precision.

  -- ON ENTRY :
  --   dim      dimension of the exponent vectors;
  --   deg      degree of the power series;
  --   nbr      number of products;
  --   pwr      largest power of the variables.

  procedure Standard_Random_Newton_Homotopy
             ( dim,deg,nbr,pwr : in integer32;
               s : out Standard_Speelpenning_Convolutions.Link_to_System;
               x : out Standard_Complex_VecVecs.Link_to_VecVec );
  procedure DoblDobl_Random_Newton_Homotopy
             ( dim,deg,nbr,pwr : in integer32;
               s : out DoblDobl_Speelpenning_Convolutions.Link_to_System;
               x : out DoblDobl_Complex_VecVecs.Link_to_VecVec );
  procedure QuadDobl_Random_Newton_Homotopy
             ( dim,deg,nbr,pwr : in integer32;
               s : out QuadDobl_Speelpenning_Convolutions.Link_to_System;
               x : out QuadDobl_Complex_VecVecs.Link_to_VecVec );

  -- DESCRIPTION :
  --   Given dimensions of random convolution circuits,
  --   generates a random vector as a solution for a Newton homotopy,
  --   in double, double double, and quad double precision.

  -- ON ENTRY :
  --   dim      dimension of the exponent vectors;
  --   deg      degree of the power series;
  --   nbr      number of products;
  --   pwr      largest power of the variables.

  -- ON RETURN :
  --   s        a generated system of convolution circuits;
  --   x        series with randomly generated leading coefficients,
  --            Speelpenning_Convolutions.Eval(s.crc,x) = 0.

end Random_Convolution_Circuits;
