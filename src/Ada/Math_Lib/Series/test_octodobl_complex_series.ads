with Standard_Integer_Numbers;          use Standard_Integer_Numbers;

package Test_OctoDobl_Complex_Series is

-- DESCRIPTION :
--   Test on series with complex coefficients in octo double precision.

  procedure OctoDobl_Construct;

  -- DESCRIPTION :
  --   Basic test on the construction of a series.

  procedure OctoDobl_Test_Creation ( degree : in integer32 );

  -- DESCRIPTION :
  --   Verifies that 1/(1-t) = 1 + t + t^2 + ...
  --   for a truncated power series with coefficients
  --   on variable degree series.

  procedure OctoDobl_Test_Arithmetic ( degree : in integer32 );

  -- DESCRIPTION :
  --   Does a basic test on the arithmetic,
  --   on random series of the given degree.

  procedure Main;

  -- DESCRIPTION :
  --   Displays a menu and prompts for a test.

end Test_OctoDobl_Complex_Series;