with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Test_Standard_QRLS_Solvers;
with Test_DoblDobl_QRLS_Solvers;
with Test_QuadDobl_QRLS_Solvers;
with Test_Multprec_QRLS_Solvers;

procedure ts_qrd is

-- DESCRIPTION :
--   Main test on the QR decomposition and least squares solvers.

  procedure Main is

  -- DESCRIPTION :
  --   Prompts for the precision and then launches the test
  --   for the selected precision.

    precision : character;

  begin
    new_line;
    put_line("Test on the QR decomposition and Least Squares.");
    new_line;
    put_line("MENU for the working precision :");
    put_line("  1. standard double precision");
    put_line("  2. double double precision");
    put_line("  3. quad double precision");
    put_line("  4. arbitrary multiprecision");
    put("Type 1, 2, 3, or 4 to select a precision : ");
    Ask_Alternative(precision,"1234");
    case precision is
      when '1' => Test_Standard_QRLS_Solvers.Main;
      when '2' => Test_DoblDobl_QRLS_Solvers.Main;
      when '3' => Test_QuadDobl_QRLS_Solvers.Main;
      when '4' => Test_Multprec_QRLS_Solvers.Main;
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_qrd;
