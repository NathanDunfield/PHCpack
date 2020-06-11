with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Complex_Solutions;         use Standard_Complex_Solutions;
with Standard_Coefficient_Circuits;      use Standard_Coefficient_Circuits;

package Standard_Refiner_Circuits is

-- DESCRIPTION :
--   Offers procedures to apply Newton's method on coefficient circuits
--   in double precision, with condition tables and cluster report.

  procedure Show_Parameters
              ( maxit : in natural32;
                tolres,tolerr,tolsing : in double_float );

  -- DESCRIPTION :
  --   Displays the values of the parameters to run several steps
  --   with Newton's method.

  -- ON ENTRY :
  --   maxit        maximum number of iterations;
  --   tolres       tolerance on the residual;
  --   tolerr       tolerance on the forward error;
  --   tolsing      tolerance on a singularity.

  procedure Set_Parameters
              ( maxit : out natural32;
                tolres,tolerr,tolsing : out double_float );

  -- DESCRIPTION :
  --   Sets default values for the parameters, and then runs
  --   and interactive loop to allow the user to modify the values.

  -- ON RETURN :
  --   maxit        maximum number of iterations;
  --   tolres       tolerance on the residual;
  --   tolerr       tolerance on the forward error;
  --   tolsing      tolerance on a singularity.

  procedure Monitor_Report
              ( idx : in integer32; fail,isreal : in boolean;
                err,rco,res,wgt,tolsing : in double_float );

  -- DESCRIPTION :
  --   Writes one line to screen with a report on a solution,
  --   to monitor the progress on the verification.

  -- ON ENTRY :
  --   idx      index number of the current solution;
  --   fail     true if Newton's method failed, false otherwise;
  --   isreal   true if real, false otherwise (only if not fail);
  --   err      forward error;
  --   rco      estimate for the inverse condition number;
  --   res      residual;
  --   wgt      weight of the coordinates;
  --   tolsing  tolerance to decide whether a solution is singular.

  procedure Run ( s : in Link_to_System; sols : in Solution_List;
                  vrb : in integer32 := 0 );

  -- DESCRIPTION :
  --   Runs several steps of Newton's method on the system s,
  --   starting at the solutions in sols.
  --   For each solution writes one line to screen.
  --   This version does not write to file.
  --   The verbose level is given in vrb.

  procedure Run ( file : in file_type;
                  s : in Link_to_System; sols : in Solution_List;
                  vrb : in integer32 := 0 );

  -- DESCRIPTION :
  --   Runs several steps of Newton's method on the system s,
  --   starting at the solutions in sols.
  --   Writes the output to file.
  --   The verbose level is given in vrb.

  procedure Main ( vrb : in integer32 := 0 );

  -- DESCRIPTION :
  --   Prompts a user for a polynomial system with solutions
  --   and then runs the refiners.
  --   The verbose level is in vrb.

  procedure Main ( infilename,outfilename : in string;
                   vrb : in integer32 := 0 );

  -- DESCRIPTION :
  --   The strings infilename and outfilename contain the names
  --   of the input and output files.  If empty, then the user
  --   will be prompted for those file names,
  --   otherwise, the names will be used for input and output.
  --   The verbose level is in vrb.

end Standard_Refiner_Circuits;
