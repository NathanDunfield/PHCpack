with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Solutions;

package Test_Standard_NewtConvSteps is

-- DESCRIPTION :
--   Tests the linearized Newton's method for power series,
--   on convolution circuits, in double precision.

  procedure Standard_Coefficient_Run
              ( p : in Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sol : in Standard_Complex_Solutions.Link_to_Solution;
                deg,maxit : in integer32;
                scale,usesvd,useqrls,lurcond : in boolean;
                stagdeg,inlined,indexed : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method in double precision,
  --   using coefficient convolutions.

  -- ON ENTRY :
  --   p        a polynomial system;
  --   sol      a solution;
  --   deg      degree of the power series;
  --   maxit    maximum number of iterations;
  --   scale    if scaling is needed;
  --   usesvd   for singular value decomposition;
  --   useqrls  for least squares after QR decomposition;
  --   lurcond  lu with condition number estimate;
  --   stagdeg  staggered in the degrees;
  --   inlined  for inlined LU factorization;
  --   indexed  for inlined LU and staggered indexed Newton.

  procedure Standard_Run
              ( p : in Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sol : in Standard_Complex_Solutions.Link_to_Solution;
                deg,maxit : in integer32;
                scale,usesvd,useqrls,lurcond : in boolean );

  -- DESCRIPTION :
  --   Runs Newton's method in double precision.

  -- ON ENTRY :
  --   p        a polynomial system;
  --   sol      a solution;
  --   deg      degree of the power series;
  --   maxit    maximum number of iterations;
  --   scale    if scaling is needed;
  --   usesvd   for singular value decomposition;
  --   useqrls  for least squares after QR decomposition;
  --   lurcond  lu with condition number estimate.

  procedure Prompt_for_Parameters
              ( overdt : in boolean; maxit : out integer32;
                scale,usesvd,useqrls,lurcond,inlined : out boolean );

  -- DESCRIPTION :
  --   Prompts the user for the parameters of a run.

  -- ON ENTRY :
  --   overdt   if overdetermined or not.

  -- ON RETURN :
  --   maxit    maximum number of iterations;
  --   scale    if scaling is needed;
  --   usesvd   for singular value decomposition;
  --   useqrls  for least squares after QR decomposition;
  --   lurcond  LU with condition number estimate;
  --   inlined  for inlined LU factorization.

  procedure Standard_Run
              ( p : in Standard_Complex_Poly_Systems.Link_to_Poly_Sys;
                sols : in Standard_Complex_Solutions.Solution_List;
                dim,deg : in integer32 );

  -- DESCRIPTION :
  --   Runs Newton's method on the first solution in the list sols 
  --   of the system p.

  procedure Standard_Test ( deg : in integer32 );

  -- DESCRIPTION :
  --   Given the degree of the power series, prompts the user
  --   for a polynomial system with a parameter, runs Newton's method.

  procedure Main;

  -- DESCRIPTION :
  --   Prompts for the degree of the power series and then runs tests.

end Test_Standard_NewtConvSteps;
