with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Multprec_Floating_Numbers;
with Symbol_Table;
with Multprec_Complex_Polynomials_io;
with Multprec_Complex_Poly_Systems;
with Multprec_Complex_Poly_Systems_io;  use Multprec_Complex_Poly_Systems_io;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;
with PHCpack_Operations;
with Multprec_PolySys_Container;

package body Multprec_PolySys_Interface is

  function Multprec_PolySys_Read
             ( vrblvl : integer32 := 0 ) return integer32 is

    lp : Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    if vrblvl > 0 then
      put_line("-> in multprec_polysys_interface.Multprec_PolySys_Read ...");
    end if;
    new_line;
    put_line("Reading a polynomial system ...");
    get(lp);
    Multprec_PolySys_Container.Initialize(lp.all);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Polysys_interface.");
        put_line("Multprec_PolySys_Read.");
      end if;
      return 220;
  end Multprec_PolySys_Read;

  function Multprec_PolySys_Read_from_File
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    nc : constant natural := natural(v_a(v_a'first));
    use Interfaces.C;
    nbdeci : constant natural32 := natural32(v_a(v_a'first+1));
    vb : constant C_Integer_Array(0..Interfaces.C.size_t(nc))
       := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc+1));
    sv : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),vb);
    size : constant natural32
         := Multprec_Floating_Numbers.Decimal_to_Size(nbdeci);

  begin
    if vrblvl > 0 then
      put_line("-> in multprec_polysys_interface.");
      put_line("Multprec_PolySys_Read_from_File ...");
    end if;
    Multprec_Complex_Polynomials_io.Set_Working_Precision(size);
   -- new_line;
   -- put_line("Opening the file with name " & sv & " ...");
   -- put("number of decimal places : "); put(nbdeci,1); new_line;
    declare
      file : file_type;
      p : Multprec_Complex_Poly_Systems.Link_to_Poly_Sys;
    begin
      Open(file,in_file,sv);
      get(file,p);
      Multprec_PolySys_Container.Clear;
      Multprec_PolySys_Container.Initialize(p.all);
      exception 
        when NAME_ERROR =>
          put_line("File with name " & sv & " could not be found!");
          return 543;
        when USE_ERROR =>
          put_line("File with name " & sv & " could not be read!");
          return 543;
    end;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in Multprec_Polysys_interface.");
        put_line("Multprec_PolySys_Read_from_File.");
      end if;
      return 220;
  end Multprec_PolySys_Read_from_File;

  function Multprec_PolySys_Write
             ( vrblvl : in integer32 := 0 ) return integer32 is

   -- use Multprec_Complex_Polynomials;
    use Multprec_Complex_Poly_Systems;

    lp : constant Link_to_Poly_Sys := Multprec_PolySys_Container.Retrieve;
   -- nvr : natural32;

  begin
    if vrblvl > 0 then
      put_line("-> in multprec_Polysys_interface.multprec_PolySys_Write ...");
    end if;
    if lp /= null then
      if PHCpack_Operations.file_okay
      -- then put(PHCpack_Operations.output_file,lp'last,lp.all);
       then put(PHCpack_Operations.output_file,lp.all);
      -- else put(standard_output,lp'last,lp.all);
       else put(standard_output,lp.all);
      end if;
    end if;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Write.");
      end if;
      return 221;
  end Multprec_PolySys_Write;

  function Multprec_PolySys_Get_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in multprec_polysys_interface.");
      put_line("-> Multprec_PolySys_Get_Dimension ...");
    end if;
    Assign(integer32(Multprec_PolySys_Container.Dimension),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Get_Dimension.");
      end if;
      return 222;
  end Multprec_PolySys_Get_Dimension;

  function Multprec_PolySys_Set_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    n : constant integer32 := integer32(v(v'first));

  begin
    if vrblvl > 0 then
      put("-> in multprec_polysys_interface.");
      put_line("Multprec_PolySys_Set_Dimension ...");
    end if;
    Multprec_PolySys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Set_Dimension.");
      end if;
      return 223;
  end Multprec_PolySys_Set_Dimension;

  function Multprec_PolySys_Size
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    use Interfaces.C;

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    i : constant integer32 := integer32(v(v'first+1));

  begin
    if vrblvl > 0 then
      put_line("-> in multprec_polysys_interface.Multprec_PolySys_Size ...");
    end if;
    Assign(integer32(Multprec_PolySys_Container.Number_of_Terms(i)),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Size");
      end if;
      return 224;
  end Multprec_PolySys_Size;

  function Multprec_PolySys_Degree
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    equ : constant integer32 := integer32(v_a(v_a'first));
    deg : constant integer32 := Multprec_PolySys_Container.Degree(equ);

  begin
    if vrblvl > 0 then
      put_line("-> in multprec_polysys_interface.Multprec_PolySys_Degree ...");
    end if;
    Assign(deg,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Degree");
      end if;
      return 229;
  end Multprec_PolySys_Degree;

  function Multprec_PolySys_Clear
             ( vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put_line("-> in multprec_polysys_interface.Multprec_PolySys_Clear ...");
    end if;
    Multprec_PolySys_Container.Clear;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in multprec_polysys_interface.");
        put_line("Multprec_PolySys_Clear.");
      end if;
      return 227;
  end Multprec_PolySys_Clear;

end Multprec_PolySys_Interface;