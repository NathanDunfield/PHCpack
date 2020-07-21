with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;
with C_Double_Arrays;                   use C_Double_Arrays;

package DoblDobl_Solutions_Interface is

-- DESCRIPTION :
--   The functions below define the interface to the container of
--   solutions in double double precision.  The integer returned by all
--   functions should be zero if the job was successful,
--   otherwise the nonzero job code is returned.

  function DoblDobl_Solutions_Read 
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRPTION :
  --   Prompts the user for solutions in double double precision
  --   and initializes the container with the user input.
  --   The verbose level is given in vrblvl.

  function DoblDobl_Solutions_Write
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Writes the solutions in double double precision
  --   to the defined output file or to screen.

  function DoblDobl_Solutions_Size 
             ( b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the number of solutions in double double precision.

  -- ON ENTRY :
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   b       the number of solutions in double double precision.

  function DoblDobl_Solutions_Dimension
             ( b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Returns the dimension of the solutions in double double precision.

  -- ON ENTRY :
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   b       the dimension of the solutions in double double precision.

  function DoblDobl_Solutions_Get
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;
           
  -- DESCRIPTION :
  --   Retrieves a solution in double double precision.

  -- ON ENTRY :
  --   a       index of the solution to be retrieved;
  --   vrblvl  the verbose level.

  -- ON RETURN :
  --   b       integer attributes of the solution;
  --   c       double attributes of the solutions.

  function DoblDobl_Solutions_Update
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;
           
  -- DESCRIPTION :
  --   Updates a solution in double double precision.

  -- ON ENTRY :
  --   a       index of the solution to be retrieved;
  --   b       integer attributes of the solution;
  --   c       double attributes of the solutions.
  --   vrblvl  the verbose level.

  function DoblDobl_Solutions_Add
             ( b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;
           
  -- DESCRIPTION :
  --   Appends a solution in double double precision.

  -- ON ENTRY :
  --   b       integer attributes of the solution;
  --   c       double attributes of the solutions.
  --   vrblvl  the verbose level.

  function DoblDobl_Solutions_Clear
             ( vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Deallocates all solutions in double double precision.

end DoblDobl_Solutions_Interface;