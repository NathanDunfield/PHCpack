with Standard_Floating_VecVecs;
with Standard_Complex_Matrices;

package Standard_Matrix_Splitters is

-- DESCRIPTION :
--   Procedures are defined to split a matrix of complex numbers into
--   columns with the real parts and columns with the imaginary parts.
--   The mirror of the split is the merge.

  procedure Complex_Parts
              ( mat : in Standard_Complex_Matrices.Matrix;
                rvv,ivv : in Standard_Floating_VecVecs.Link_to_VecVec );

  -- DESCRIPTION :
  --   Returns in rvv the real parts of the elements in mat
  --   and in ivv the imaginary parts of the elements in mat.
  --   The vector representation of the matrix mat is column wise.

  -- REQUIRED :
  --   Space is allocated for the vectors rvv and ivv, with ranges:
  --   rvv'range = ivv'range = mat'range(2), and for all k in rvv'range:
  --   rvv(k)'range = ivv(k)'range = mat'range(1).

  -- ON ENTRY :
  --   mat      a matrix with complex numbers;
  --   rvv      space allocated for the real parts of the numbers
  --            in the columns of mat;
  --   ivv      space allocated for the imaginary parts of the numbers
  --            in the columns of mat.

  -- ON RETURN :
  --   rvv      real parts of the columns of mat;
  --   ivv      imaginary parts of the columns of mat.

  procedure Complex_Merge
              ( rvv,ivv : in Standard_Floating_VecVecs.Link_to_VecVec;
                mat : out Standard_Complex_Matrices.Matrix );

  -- DESCRIPTION :
  --   Given in rvv and ivv are the real and imaginary parts of the
  --   columns of a complex matrix, with values defined on return.
  --   Mirrors the Complex_Parts procedure.

  -- REQUIRED :
  --   rvv'range = ivv'range = mat'range(2), and for all k in rvv'range:
  --   rvv(k)'range = ivv(k)'range = mat'range(1).

  -- ON ENTRY :
  --   rvv      columns with the real parts of complex numbers;
  --   ivv      columns with the imaginary parts of complex numbers.

  -- ON RETURN :
  --   mat      matrix of complex numbers with real parts from rvv
  --            and imaginary parts from ivv.

end Standard_Matrix_Splitters;
