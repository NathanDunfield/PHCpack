with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with OctoDobl_Complex_Numbers;           use OctoDobl_Complex_Numbers;

package OctoDobl_Complex_Numbers_io is

-- DESCRIPTION :
--   This package provides input and output routines
--   for complex numbers in octo double precision.

  procedure get ( c : in out Complex_Number );
  procedure get ( file : in file_type; c : in out Complex_Number );
  procedure get ( s : in string; c : in out Complex_Number;
                  last : out integer );

  -- DESCRIPTION :
  --   Reads an octo double complex number from standard input
  --   or from file into c.

  procedure put ( c : in Complex_Number );
  procedure put ( file : in file_type; c : in Complex_Number );
  procedure put ( s : out string; c : in Complex_Number );

  -- DESCRIPTION :
  --   Writes the octo double complex number c to standard output
  --   or to file, using default precision of 128 decimal places.

  procedure put ( c : in Complex_Number; dp : in natural32 );
  procedure put ( file : in file_type;
                  c : in Complex_Number; dp : in natural32 );
  procedure put ( s : out string;
                  c : in Complex_Number; dp : in natural32 );

  -- DESCRIPTION :
  --   Writes the octo double complex number c to standard output
  --   or to file, using precision of dp decimal places.

end OctoDobl_Complex_Numbers_io;
