with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Test_Standard_Singular_Values;
with Test_DoblDobl_Singular_Values;
with Test_QuadDobl_Singular_Values;
with Test_Multprec_Singular_Values;

procedure ts_svd is

-- DESCRIPTION :
--   Main test on the Singular Value Decomposition.

  procedure Main is

  -- DESCRIPTION :
  --   Calls the tests on the Singular Value Decomposition,
  --   after prompting for the precision.

    prec : character;

  begin
    new_line;
    put_line("Testing the singular value decomposition ...");
    new_line;
    put_line("MENU to select the precision : ");
    put_line("  1. standard double precision; or");
    put_line("  2. double double precision; or");
    put_line("  3. quad double precision; or");
    put_line("  4. arbitrary multiprecision.");
    put("Type 1, 2, 3, or 4 to select the precision : ");
    Ask_Alternative(prec,"1234");
    case prec is
      when '1' => Test_Standard_Singular_Values.Main;
      when '2' => Test_DoblDobl_Singular_Values.Main;
      when '3' => Test_QuadDobl_Singular_Values.Main;
      when '4' => Test_Multprec_Singular_Values.Main;
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_svd;
