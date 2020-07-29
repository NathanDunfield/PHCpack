with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Vectors;
with Symbol_Table;
with Standard_Complex_Laurentials;
with Standard_Complex_Laur_Strings;
with Standard_Complex_Laur_Systems;
with Standard_Complex_Laur_Systems_io;  use Standard_Complex_Laur_Systems_io;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;
with PHCpack_Operations;
with Standard_LaurSys_Container;

package body Standard_LaurSys_Interface is

  function Standard_LaurSys_Read
             ( vrblvl : integer32 := 0 ) return integer32 is

    lp : Standard_Complex_Laur_Systems.Link_to_Laur_Sys;

  begin
    if vrblvl > 0 then
      put_line("-> in standard_LaurSys_interface.Standard_LaurSys_Read ...");
    end if;
    new_line;
    put_line("Reading a polynomial system ...");
    get(lp);
    Standard_LaurSys_Container.Initialize(lp.all);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Read.");
      end if;
      return 100;
  end Standard_LaurSys_Read;

  function Standard_LaurSys_Write
             ( vrblvl : in integer32 := 0 ) return integer32 is

    use Standard_Complex_Laurentials;
    use Standard_Complex_Laur_Systems;

    lp : constant Link_to_Laur_Sys := Standard_LaurSys_Container.Retrieve;
    nvr : natural32;

  begin
    if vrblvl > 0 then
      put_line("-> in standard_LaurSys_interface.Standard_LaurSys_Write ...");
    end if;
    if lp /= null then
      nvr := Number_of_Unknowns(lp(lp'first));
      if PHCpack_Operations.file_okay then
        if integer32(nvr) = lp'last then
          put(PHCpack_Operations.output_file,natural32(lp'last),lp.all);
        else
          put(PHCpack_Operations.output_file,natural32(lp'last),nvr,lp.all);
        end if;
      elsif integer32(nvr) = lp'last then
        put(standard_output,natural32(lp'last),lp.all);
      else
        put(standard_output,natural32(lp'last),nvr,lp.all);
      end if;
    end if;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Write.");
      end if;
      return 101;
  end Standard_LaurSys_Write;

  function Standard_LaurSys_Get_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put("-> in standard_LaurSys_interface.");
      put_line("-> Standard_LaurSys_Get_Dimension ...");
    end if;
    Assign(integer32(Standard_LaurSys_Container.Dimension),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Get_Dimension.");
      end if;
      return 102;
  end Standard_LaurSys_Get_Dimension;

  function Standard_LaurSys_Set_Dimension
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    n : constant integer32 := integer32(v(v'first));

  begin
    if vrblvl > 0 then
      put("-> in standard_LaurSys_interface.");
      put_line("Standard_LaurSys_Set_Dimension ...");
    end if;
    Standard_LaurSys_Container.Initialize(n);
    Symbol_Table.Init(natural32(n));
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Set_Dimension.");
      end if;
      return 103;
  end Standard_LaurSys_Set_Dimension;

  function Standard_LaurSys_Size
             ( a : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    use Interfaces.C;

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    i : constant integer32 := integer32(v(v'first+1));

  begin
    if vrblvl > 0 then
      put_line("-> in standard_LaurSys_interface.Standard_LaurSys_Size ...");
    end if;
    Assign(integer32(Standard_LaurSys_Container.Number_of_Terms(i)),a);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Size");
      end if;
      return 104;
  end Standard_LaurSys_Size;

  function Standard_LaurSys_Get_Term
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array(0..2)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    i : constant integer32 := integer32(v(1));
    j : constant natural32 := natural32(v(2));
    t : constant Standard_Complex_Laurentials.Term
      := Standard_LaurSys_Container.Retrieve_Term(i,j);

  begin
    if vrblvl > 0 then
      put("-> in standard_LaurSys_interface.");
      put_line("Standard_LaurSys_Get_Term ...");
    end if;
    Assign(t.cf,c);
    Assign(t.dg.all,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Get_Term");
      end if;
      return 105;
  end Standard_LaurSys_Get_Term;

  function Standard_LaurSys_Add_Term
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               c : C_dblarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v : constant C_Integer_Array(0..1)
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));
    n : constant integer32 := integer32(v(0));
    i : constant integer32 := integer32(v(1));
    e : Standard_Integer_Vectors.Vector(1..n);
    t : Standard_Complex_Laurentials.Term;

  begin
    if vrblvl > 0 then
      put("-> in standard_LaurSys_interface.");
      put_line("Standard_LaurSys_Add_Term ...");
    end if;
    Assign(c,t.cf);
    Assign(natural32(n),b,e);
    t.dg := new Standard_Integer_Vectors.Vector'(e);
    Standard_LaurSys_Container.Add_Term(i,t);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Add_Term");
      end if;
      return 106;
  end Standard_LaurSys_Add_Term;

  function Standard_LaurSys_String_Save
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    use Interfaces.C;

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    nc : constant integer := integer(v_a(v_a'first));
    n : constant natural32 := natural32(v_a(v_a'first+1));
    k : constant integer32 := integer32(v_a(v_a'first+2));
    nc1 : constant Interfaces.C.size_t := Interfaces.C.size_t(nc-1);
    v_b : constant C_Integer_Array(0..nc1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(nc));
    s : constant String(1..nc) := C_Integer_Array_to_String(natural32(nc),v_b);
    p : Standard_Complex_Laurentials.Poly;

  begin
    if vrblvl > 0 then
      put("-> in standard_laursys_interface.");
      put_line("Standard_LaurSys_String_Save.");
    end if;
   -- put("Polynomial "); put(k,1);
   -- put(" given as string of "); put(integer32(nc),1);
   -- put_line(" characters.");
   -- put("n = "); put(n,1); new_line;
   -- put("Symbol_Table.Number = "); put(Symbol_Table.Number,1); new_line;
   -- put("The string : "); put_line(s);
    if Symbol_Table.Empty then
   --   put_line("initializing symbol table ...");
      Symbol_Table.Init(n);
    elsif Symbol_Table.Maximal_Size < n then
   --   put_line("resetting symbol table ...");
      Symbol_Table.Clear;
      Symbol_Table.Init(n);
   -- else
   --   put_line("symbol table is okay");
    end if;
    p := Standard_Complex_Laur_Strings.Parse(n,s);
    Standard_LaurSys_Container.Add_Poly(k,p);
    Standard_Complex_Laurentials.Clear(p);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_Laursys_interface.");
        put_line("Standard_LaurSys_String_Save.");
      end if;
      return 74;
  end Standard_LaurSys_String_Save;

  function Standard_LaurSys_String_Size
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant Standard_Complex_Laurentials.Poly
      := Standard_LaurSys_Container.Retrieve_Poly(equ);
    sz : constant integer32
       := integer32(Standard_Complex_Laur_Strings.Size_Limit(p));

  begin
    if vrblvl > 0 then
      put("-> in standard_laursys_interface.");
      put_line("Standard_LaurSys_String_Size ...");
    end if;
    Assign(sz,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_laursys_interface.");
        put_line("Standard_LaurSys_String_Size.");
      end if;
      return 604;
  end Standard_LaurSys_String_Size;

  function Standard_LaurSys_String_Load 
             ( a : C_intarrs.Pointer;
               b : C_intarrs.Pointer;
               vrblvl : integer32 := 0 ) return integer32 is

    v_a : constant C_Integer_Array
        := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(1));
    equ : constant integer32 := integer32(v_a(v_a'first));
    p : constant Standard_Complex_Laurentials.Poly
      := Standard_LaurSys_Container.Retrieve_Poly(equ);
    s : constant string := Standard_Complex_Laur_Strings.Write(p);
    sv : constant Standard_Integer_Vectors.Vector
       := String_to_Integer_Vector(s);
    slast : constant integer32 := integer32(s'last);

  begin
    if vrblvl > 0 then
      put("-> in standard_laursys_interface.");
      put_line("Standard_LaurSys_String_Load.");
    end if;
   -- put("Polynomial "); put(equ,1); put(" : "); put_line(s);
   -- put("#characters : "); put(s'last,1); new_line;
    Assign(slast,a);
    Assign(sv,b);
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_laursys_interface.");
        put_line("Standard_LaurSys_String_Load.");
      end if;
      return 128;
  end Standard_LaurSys_String_Load;

  function Standard_LaurSys_Clear
             ( vrblvl : integer32 := 0 ) return integer32 is
  begin
    if vrblvl > 0 then
      put_line("-> in standard_LaurSys_interface.Standard_LaurSys_Clear ...");
    end if;
    Standard_LaurSys_Container.Clear;
    return 0;
  exception
    when others => 
      if vrblvl > 0 then
        put("Exception raised in standard_LaurSys_interface.");
        put_line("Standard_LaurSys_Clear.");
      end if;
      return 107;
  end Standard_LaurSys_Clear;

end Standard_LaurSys_Interface;
