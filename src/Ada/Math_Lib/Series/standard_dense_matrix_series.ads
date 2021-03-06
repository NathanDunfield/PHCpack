with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Complex_VecMats;
with Standard_Dense_Series;
with Standard_Dense_Series_Matrices;
with Standard_Dense_Vector_Series;

package Standard_Dense_Matrix_Series is

-- DESCRIPTION :
--   A series matrix is a matrix of truncated power series, with complex
--   numbers as coefficients.  A matrix series is a truncated power series,
--   where the coefficients are matrices.  As a data type, a matrix series
--   is represented as an array of matrices, of maximum degree.

  type Matrix is record
    deg : integer32; -- the last power in the series
                     -- the error is of order deg+1
    cff : Standard_Complex_VecMats.VecMat(0..Standard_Dense_Series.max_deg);
     -- only coefficients in the range 0..deg are defined
     -- all vectors in cff have the same range
  end record;

-- CONSTRUCTORS :

  function Create ( A : Standard_Dense_Series_Matrices.Matrix )
                  return Standard_Dense_Matrix_Series.Matrix;

  -- DESCRIPTION :
  --   A matrix which has as entries truncated power series
  --   is converted into a series with matrices as coefficients.
  --   The range(1) of the matrix on entry is 1..n, where n is the
  --   number of rows in A and range(2) is the number of columns of A.
  --   The range of the matrix on return is 1..d, where d is the
  --   degree of each series in A.

  -- REQUIRED :
  --   The assumption is that every series in A has the same degree d.

  function Create ( A : Standard_Dense_Matrix_Series.Matrix )
                  return Standard_Dense_Series_Matrices.Matrix;

  -- DESCRIPTION :
  --   A truncated power series with matrices as coefficients
  --   is converted into a matrix of truncated power series.
  --   The matrix on entry has range 1..d, where d is v.deg.
  --   The range(1) of the matrix on return is to 1..A.cff(i)'last(1)
  --   and its range(2) is 1..m, where m = A.cff(i)'last(2).

  -- REQUIRED :
  --   The degree of A must be at least zero, at least one of
  --   the coefficients in A must be defined.

-- MULTIPLIER :

  function Multiply
             ( mat : Standard_Dense_Matrix_Series.Matrix;
               vec : Standard_Dense_Vector_Series.Vector )
             return Standard_Dense_Vector_Series.Vector;

  -- DESCRIPTION :
  --   Multiplies the matrix series with the vector series,
  --   also convoluting the additional terms of higher degrees,
  --   up to the maximum degree.

  -- REQUIRED : mat.deg = vec.deg.

-- DESTRUCTOR :

  procedure Clear ( A : in out Matrix );

  -- DESCRIPTION :
  --   Deallocates all coefficients in the series.
  --   On return, the degree of A equals -1, because all coefficients
  --   of A, all A(i), have been deallocated.

end Standard_Dense_Matrix_Series;
