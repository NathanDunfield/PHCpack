with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with C_Integer_Arrays;                  use C_Integer_Arrays;

package Diagonal_Homotopy_Interface is

-- DESCRIPTION :
--   The functions below give access to diagonal homotopies
--   to intersect solution sets.

  function Diagonal_Homotopy_Standard_Polynomial_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a polynomial in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Standard_Laurential_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a Laurent polynomial
  --   in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a Laurent polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Polynomial_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a polynomial in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Laurential_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a Laurent polynomial
  --   in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a Laurent polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Polynomial_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a polynomial in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Laurential_Set
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a witness set for a Laurent polynomial
  --   in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of variables,
  --           in a[1] is the number of characters in the string;
  --   b       the string representation of a Laurent polynomial;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Standard_Polynomial_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for polynomial systems
  --   stored as target and start systems in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Polynomial_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for polynomial systems
  --   stored as target and start systems in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Polynomial_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for polynomial systems
  --   stored as target and start systems in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Standard_Laurent_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for Laurent systems
  --   in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Laurent_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for Laurent systems
  --   in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Laurent_Make 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes a diagonal homotopy for Laurent systems
  --   in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first set;
  --   b       in b[0] is the dimension of the second set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Symbols_Doubler
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Doubles the number of symbols in the symbol table to write the
  --   solved target system to start the cascade of diagonal homotopies
  --   in extrinsic coordinates.
  --   On a succesful return, the symbol table contains the suffixed
  --   symbols to write the target system properly.

  -- ON ENTRY :
  --   a       in a[0] is the ambient dimension,
  --           equal to the original number of variables,
  --           in a[1] is the top dimension of the set,
  --           in a[2] is the number of characters in the string b;
  --   b       the sequence of symbols for the variables in the first set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Standard_Start_Solutions
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes the solutions to start the cascade to intersect
  --   two witness sets in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first witness set;
  --   b       in b[0] is the dimension of the second witness set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Start_Solutions
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes the solutions to start the cascade to intersect
  --   two witness sets in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first witness set;
  --   b       in b[0] is the dimension of the second witness set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Start_Solutions
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Makes the solutions to start the cascade to intersect
  --   two witness sets in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the dimension of the first witness set;
  --   b       in b[0] is the dimension of the second witness set;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_Standard_Collapse
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Elimates the extrinsic diagonal from system and solutions
  --   in double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of slack variables,
  --           in a[1] is the number of slack variables to be added;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_DoblDobl_Collapse
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Elimates the extrinsic diagonal from system and solutions
  --   in double double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of slack variables,
  --           in a[1] is the number of slack variables to be added;
  --   vrblvl  is the verbose level.

  function Diagonal_Homotopy_QuadDobl_Collapse
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32;

  -- DESCRIPTION :
  --   Elimates the extrinsic diagonal from system and solutions
  --   in quad double precision.

  -- ON ENTRY :
  --   a       in a[0] is the number of slack variables,
  --           in a[1] is the number of slack variables to be added;
  --   vrblvl  is the verbose level.

end Diagonal_Homotopy_Interface;
