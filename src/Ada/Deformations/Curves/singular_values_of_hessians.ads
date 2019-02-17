with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Double_Double_Numbers;             use Double_Double_Numbers;
with Quad_Double_Numbers;               use Quad_Double_Numbers;
with Standard_Floating_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_Matrices;
with Double_Double_Vectors;
with DoblDobl_Complex_Vectors;
with DoblDobl_Complex_Matrices;
with Quad_Double_Vectors;
with QuadDobl_Complex_Vectors;
with QuadDobl_Complex_Matrices;
with Standard_Complex_Jaco_Matrices;
with DoblDobl_Complex_Jaco_Matrices;
with QuadDobl_Complex_Jaco_Matrices;
with Standard_Complex_Hessians;
with DoblDobl_Complex_Hessians;
with QuadDobl_Complex_Hessians;

package Singular_Values_of_Hessians is

-- DESCRIPTION :
--   Given symbolic definitions of Hessian matrices,
--   evaluates the Hessians at numerical vectors and
--   returns the singular values.
--   This leads to an estimate for the distance to the nearest solution.

  procedure Singular_Values
             ( A : in out Standard_Complex_Matrices.Matrix;
               s : out Standard_Complex_Vectors.Vector );
  procedure Singular_Values
             ( A : in out DoblDobl_Complex_Matrices.Matrix;
               s : out DoblDobl_Complex_Vectors.Vector );
  procedure Singular_Values
             ( A : in out QuadDobl_Complex_Matrices.Matrix;
               s : out QuadDobl_Complex_Vectors.Vector );

  -- DESCRIPTION :
  --   Computes the singular values of A and returns the result in s,
  --   computed in double, double double, or quad double precision.

  function Standard_Singular_Values
             ( h : Standard_Complex_Hessians.Link_to_Hessian;
               x : Standard_Complex_Vectors.Vector )
             return  Standard_Floating_Vectors.Vector;
  function DoblDobl_Singular_Values
             ( h : DoblDobl_Complex_Hessians.Link_to_Hessian;
               x : DoblDobl_Complex_Vectors.Vector )
             return  Double_Double_Vectors.Vector;
  function QuadDobl_Singular_Values
             ( h : QuadDobl_Complex_Hessians.Link_to_Hessian;
               x : QuadDobl_Complex_Vectors.Vector )
             return  Quad_Double_Vectors.Vector;

  -- DESCRIPTION :
  --   Given a Hessian h and a numerical vector x,
  --   returns the singular values computed in double precision,
  --   or double double precision, or quad double precision.

  function Standard_Singular_Values
             ( h : Standard_Complex_Hessians.Array_of_Hessians;
               x : Standard_Complex_Vectors.Vector )
             return  Standard_Floating_Vectors.Vector;
  function DoblDobl_Singular_Values
             ( h : DoblDobl_Complex_Hessians.Array_of_Hessians;
               x : DoblDobl_Complex_Vectors.Vector )
             return  Double_Double_Vectors.Vector;
  function QuadDobl_Singular_Values
             ( h : QuadDobl_Complex_Hessians.Array_of_Hessians;
               x : QuadDobl_Complex_Vectors.Vector )
             return  Quad_Double_Vectors.Vector;

  -- DESCRIPTION :
  --   Given an array of Hessians h and a numerical vector x,
  --   computes the singular values in double, double double,
  --   or quad double precision.  On return is a vector of h'range,
  --   with in the i-th entry the first, largest singular value
  --   of the i-th Hessian in h evaluated at x.

  function Standard_Distance
             ( jm : in Standard_Complex_Jaco_Matrices.Jaco_Mat;
               hs : in Standard_Complex_Hessians.Array_of_Hessians;
               xt : in Standard_Complex_Vectors.Vector )
             return double_float;
  function DoblDobl_Distance
             ( jm : in DoblDobl_Complex_Jaco_Matrices.Jaco_Mat;
               hs : in DoblDobl_Complex_Hessians.Array_of_Hessians;
               xt : in DoblDobl_Complex_Vectors.Vector )
             return double_double;
  function QuadDobl_Distance
             ( jm : in QuadDobl_Complex_Jaco_Matrices.Jaco_Mat;
               hs : in QuadDobl_Complex_Hessians.Array_of_Hessians;
               xt : in QuadDobl_Complex_Vectors.Vector )
             return quad_double;

  -- DESCRIPTION :
  --   Returns an estimate to the distance to the nearest solution,
  --   in double, double double, or quad double precision.

  -- ON ENTRY :
  --   jm      Jacobian matrix of a homotopy;
  --   hs      array of Hessians of the polynomials in the homotopy;
  --   xt      solution vector and corresponding t value.

  -- REQUIRED :
  --   The number of variables of all polynomials in jm and hs
  --   correspond to the end of the range of xt.
  --   Moreover, the value for the parameter in xt is at the proper place,
  --   corresponding to the homotopy.

end Singular_Values_of_Hessians;
