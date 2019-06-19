with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems;

package Drivers_for_Reduction is

-- DESCRIPTION:
--   This package collects driver routines for reducing a polynomial
--   system w.r.t. its total degree.

  procedure Display_Info;

  -- DESCRIPTION :
  --   Displays information about reduction on screen.

  procedure Driver_for_Linear_Reduction
               ( file : in file_type; 
                 p : in out Standard_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );
  procedure Driver_for_Linear_Reduction
               ( file : in file_type; 
                 p : in out DoblDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );
  procedure Driver_for_Linear_Reduction
               ( file : in file_type; 
                 p : in out QuadDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );

  -- DESCRIPTION :
  --   The coefficient matrix of the system is triangulated,
  --   in standard double, double double, or quad double precision.

  procedure Driver_for_Sparse_Linear_Reduction
               ( file : in file_type;
                 p : in out Standard_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );
  procedure Driver_for_Sparse_Linear_Reduction
               ( file : in file_type;
                 p : in out DoblDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );
  procedure Driver_for_Sparse_Linear_Reduction
               ( file : in file_type;
                 p : in out QuadDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );

  -- DESCRIPTION :
  --   The coefficient matrix of the system is diagonalized,
  --   in standard double, double double, or quad double precision.

  procedure Driver_for_Nonlinear_Reduction
               ( file : in file_type;
                 p : in out Standard_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32 );

  -- DESCRIPTION :
  --   Combinations of S-polynomials are used to lower the total degree.

  procedure Driver_for_Overconstrained_Reduction
               ( p : in out Standard_Complex_Poly_Systems.Poly_Sys );

  -- DESCRIPTION :
  --   Random combinations are added.

  procedure Driver_for_Reduction 
               ( file : in file_type;
                 p : in out Standard_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32; exit_option : in boolean;
                 verbose : in integer32 := 0 );
  procedure Driver_for_Reduction 
               ( file : in file_type;
                 p : in out DoblDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32; exit_option : in boolean;
                 verbose : in integer32 := 0 );
  procedure Driver_for_Reduction 
               ( file : in file_type;
                 p : in out QuadDobl_Complex_Poly_Systems.Poly_Sys;
                 d : out natural32; exit_option : in boolean;
                 verbose : in integer32 := 0 );

  -- DESCRIPTION :
  --   This is an interactive driver for the reduction procedures,
  --   for systems in double, double double, and quad double precision.

  -- ON ENTRY :
  --   file         a file to write intermediate results and diagnostics on;
  --   p            a polynomial system;
  --   exit_option  if true, then the leave-option will be shown;
  --   verbose      the verbose level.

  -- ON RETURN :
  --   p            the system in a reduced form;
  --   d            total degree of the new system.

end Drivers_for_Reduction;
