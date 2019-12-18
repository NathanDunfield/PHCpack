with DoblDobl_Complex_Ring;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_VecVecs;
with Generic_Speelpenning_Convolutions;

package DoblDobl_Speelpenning_Convolutions is
  new Generic_Speelpenning_Convolutions(DoblDobl_Complex_Ring,
                                        DoblDobl_Complex_Vectors,
                                        DoblDobl_Complex_VecVecs);

-- DESCRIPTION :
--   Defines the evaluation and differentiation of products of power series
--   with convolutions computed over the ring of complex numbers,
--   in double double precision.
