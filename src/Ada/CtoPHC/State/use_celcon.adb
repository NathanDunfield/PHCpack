--with Standard_Integer_Vectors_io;
-- use Standard_Integer_Vectors_io;

with text_io;                           use text_io;
with Interfaces.C;                      use Interfaces.C;
with Communications_with_User;          use Communications_with_User;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Standard_Integer_Vectors;
with Standard_Floating_Vectors;
with Lists_of_Integer_Vectors;
with Lists_of_Floating_Vectors;
with Arrays_of_Integer_Vector_Lists;
with Arrays_of_Floating_Vector_Lists;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;  use Standard_Complex_Poly_Systems_io;
with DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems_io;  use DoblDobl_Complex_Poly_Systems_io;
with QuadDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Poly_Systems_io;  use QuadDobl_Complex_Poly_Systems_io;
with Standard_Complex_Laur_Systems;
with DoblDobl_Complex_Laur_Systems;
with QuadDobl_Complex_Laur_Systems;
with Standard_Complex_Solutions;
with DoblDobl_Complex_Solutions;
with QuadDobl_Complex_Solutions;
with Supports_of_Polynomial_Systems;
with Floating_Mixed_Subdivisions;
with Floating_Mixed_Subdivisions_io;    use Floating_Mixed_Subdivisions_io;
with Integer_Mixed_Subdivisions;
with Integer_Mixed_Subdivisions_io;     use Integer_Mixed_Subdivisions_io;
with Floating_Lifting_Functions;
with Floating_Integer_Convertors;
with Integer_Lifting_Utilities;         use Integer_Lifting_Utilities;
with Floating_Lifting_Utilities;        use Floating_Lifting_Utilities;
with Induced_Permutations;
with Mixed_Volume_Computation;          use Mixed_Volume_Computation;
with PHCpack_Operations;
with Standard_PolySys_Container;
with DoblDobl_PolySys_Container;
with QuadDobl_PolySys_Container;
with Standard_LaurSys_Container;
with DoblDobl_LaurSys_Container;
with QuadDobl_LaurSys_Container;
with Standard_Solutions_Container;
with DoblDobl_Solutions_Container;
with QuadDobl_Solutions_Container;
with Cells_Container;
with Integer_Cells_Container;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;

function use_celcon ( job : integer32;
                      a : C_intarrs.Pointer;
                      b : C_intarrs.Pointer;
                      c : C_dblarrs.Pointer ) return integer32 is

  function Select_Point ( L : Lists_of_Integer_Vectors.List; k : natural32 )
                        return Standard_Integer_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the k-th point from the list L.

    use Lists_of_Integer_Vectors;

    res : Standard_Integer_Vectors.Link_to_Vector;
    tmp : List := L;

  begin
    for i in 1..(k-1) loop
      exit when Is_Null(tmp);
      tmp := Tail_Of(tmp);
    end loop;
    if not Is_Null(tmp)
     then res := Head_Of(tmp);
    end if;
    return res;
  end Select_Point;

  function Select_Point ( L : Lists_of_Floating_Vectors.List; k : natural32 )
                        return Standard_Floating_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the k-th point from the list L.

    use Lists_of_Floating_Vectors;

    res : Standard_Floating_Vectors.Link_to_Vector;
    tmp : List := L;

  begin
    for i in 1..(k-1) loop
      exit when Is_Null(tmp);
      tmp := Tail_Of(tmp);
    end loop;
    if not Is_Null(tmp)
     then res := Head_Of(tmp);
    end if;
    return res;
  end Select_Point;

  function Job0 return integer32 is  -- read mcc and initialize container

    use Arrays_of_Floating_Vector_Lists;
    use Floating_mixed_Subdivisions;
  
    file : file_type;
    n,m : natural32;
    r : integer32;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    lif : Link_to_Array_of_Lists;
    sub : Mixed_Subdivision;

  begin
    new_line;
    put_line("Reading the file name for a mixed-cell configuration.");
    Read_Name_and_Open_File(file);
    get(file,n,m,mix,sub);
    close(file);
    r := mix'last;
    lif := new Array_of_Lists'(Lifted_Supports(r,sub));
    Cells_Container.Initialize(mix,lif,sub);
    return 0;
  end Job0;

  function Job1 return integer32 is -- write the mcc in the container

    use Floating_mixed_Subdivisions;

    mcc : Mixed_Subdivision := Cells_Container.Retrieve;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    n,mv : natural32;

  begin
    if not Is_Null(mcc) then
      n := Cells_Container.Dimension;
      mix := Cells_Container.Type_of_Mixture;
      put(standard_output,n-1,mix.all,mcc,mv);
      put("The mixed volume is "); put(mv,1); put_line(".");
    end if;
    return 0;
  end Job1;

  function Job4 return integer32 is -- return type of mixture

    use Standard_Integer_Vectors;
    mix : Link_to_Vector;
    r : integer32;

  begin
    mix := Cells_Container.Type_of_Mixture;
    if mix /= null
     then r := mix'last; Assign(mix.all,b);
     else r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job4;

  function Job5 return integer32 is -- return cardinalities of supports

    use Lists_of_Floating_Vectors;
    use Arrays_of_Floating_Vector_Lists;

    lif : Link_to_Array_of_Lists;
    r : integer32;

  begin
    lif := Cells_Container.Lifted_Supports;
    if lif /= null then
      r := lif'last;
      declare
        nl : Standard_Integer_Vectors.Vector(1..r);
      begin
        for i in nl'range loop
          nl(i) := integer32(Length_Of(lif(i)));
        end loop;
        Assign(nl,b);
      end;
    else
      r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job5;

  function Job6 return integer32 is -- return point in support

    use Arrays_of_Floating_Vector_Lists;

    lif : Link_to_Array_of_Lists;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array := C_intarrs.Value(b);
    k_a : constant integer32 := integer32(v_a(v_a'first));
    k_b : constant natural32 := natural32(v_b(v_b'first));
    use Standard_Floating_Vectors;
    lpt : Link_to_Vector;

  begin
    lif := Cells_Container.Lifted_Supports;
   -- put("retrieving point "); put(k_b,1);
   -- put(" from list "); put(k_a,1); put_line(" ...");
    if lif /= null then
      lpt := Select_Point(lif(k_a),k_b);
      if lpt /= null then
        Assign(lpt.all,c);     
        return 0;
      end if;
    end if;
    return 1;
  end Job6;

  function Job7 return integer32 is -- return innner normal

    use Floating_mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if fail
     then return 1;
     else Assign(mic.nor.all,c); return 0;
    end if;
  end Job7;

  function Job8 return integer32 is -- return #elements in cell

    use Lists_of_Floating_Vectors;
    use Floating_Mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      declare
        nl : Standard_Integer_Vectors.Vector(mic.pts'range);
      begin
        for i in mic.pts'range loop
          nl(i) := integer32(Length_Of(mic.pts(i)));
        end loop;
        Assign(nl,b);
      end;
      return 0;
    end if;
    return 1;
  end Job8;

  function Job9 return integer32 is -- return point in a cell

    use Floating_Mixed_Subdivisions;

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array
        := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    k : constant natural32 := natural32(v_a(v_a'first));
    i : constant integer32 := integer32(v_b(v_b'first));
    j : constant natural32 := natural32(v_b(v_b'first+1));
    mic : Mixed_Cell;
    fail : boolean;
    use Standard_Floating_Vectors;
    lpt : Link_to_Vector;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      lpt := Select_Point(mic.pts(i),j);
      if lpt /= null 
       then Assign(lpt.all,c); return 0;
      end if;
    end if;
    return 1;
  end Job9;

  function Job10 return integer32 is -- return mixed volume of a cell

    use Floating_Mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    mic : Mixed_Cell;
    fail : boolean;
    mv : natural32;
    n : constant integer32 := integer32(Cells_Container.Dimension)-1;
    use Standard_Integer_Vectors;

  begin
    Cells_Container.Retrieve(k,mic,fail);
    if fail or mix = null then
      return 1;
    else
      Mixed_Volume(n,mix.all,mic,mv);
      Assign(integer32(mv),b);
      return 0;
    end if;
  end Job10;

  function Job11 return integer32 is -- sets type of mixture

    v : constant C_Integer_Array := C_intarrs.Value(a);
    r : constant integer32 := integer32(v(v'first));
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := new Standard_Integer_Vectors.Vector(1..r);
    r1 : constant Interfaces.C.size_t := Interfaces.C.size_t(r-1);
    mbv : constant C_Integer_Array(0..r1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(r));

  begin
    for i in 0..r-1 loop
      mix(i+1) := integer32(mbv(Interfaces.C.size_t(i)));
    end loop;
    Cells_Container.Initialize(mix);
    return 0;
  end Job11;

  function Job12 return integer32 is -- append point to a support

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    n : constant integer32 := integer32(vb(vb'first));
    x : Standard_Floating_Vectors.Vector(1..n);
    fail : boolean;

  begin
    Assign(natural32(n),c,x);
    fail := Cells_Container.Append_to_Support(k,x);
    if fail
     then return 1;
     else return 0;
    end if;
  end Job12;

  function Job13 return integer32 is -- append mixed cell to container

    va : constant C_Integer_Array
       := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    r : constant integer32 := integer32(va(va'first));
    n : constant integer32 := integer32(va(va'first+1));
    d : constant Interfaces.C.size_t := Interfaces.C.size_t(va(2));
    vb : constant C_Integer_Array(0..d-1)
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(d));
    m : constant integer32 := integer32(vb(0));
    x : Standard_Floating_Vectors.Vector(1..n);
    cnt : Standard_Integer_Vectors.Vector(1..r);
    lab : Standard_Integer_Vectors.Vector(1..m);

  begin
   -- put("  r = "); put(r,1);
   -- put("  n = "); put(n,1);
   -- put("  d = "); put(natural(d),1); new_line;
    for i in cnt'range loop
      cnt(i) := integer32(vb(Interfaces.C.size_t(i)));
    end loop;
    for i in lab'range loop
      lab(i) := integer32(vb(Interfaces.C.size_t(i+r)));
    end loop;
   -- put("the number of points in each support :"); put(cnt); new_line;
   -- put("the labels of points in each support :"); put(lab); new_line;
    Assign(natural32(n),c,x);
    Cells_Container.Append_Mixed_Cell(cnt,lab,x);
    return 0;
  end Job13;

  function Job15 return integer32 is -- retrieve a mixed cell

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    cnt,lab : Standard_Integer_Vectors.Link_to_Vector;
    normal : Standard_Floating_Vectors.Link_to_Vector;
    fail : boolean;

  begin
    Cells_Container.Retrieve_Mixed_Cell(k,fail,cnt,lab,normal);
    if fail then
      return 1;
    else
      declare
        sum : constant integer32 := Standard_Integer_Vectors.Sum(cnt.all);
        cntlab : Standard_Integer_Vectors.Vector(1..cnt'last+lab'last+1);
        ind : integer32 := 0;
      begin
        ind := ind + 1;
        cntlab(ind) := sum;
        for i in cnt'range loop
          ind := ind + 1;
          cntlab(ind) := cnt(i);
        end loop;
        for i in lab'range loop
          ind := ind + 1;
          cntlab(ind) := lab(i);
        end loop;
        Assign(cntlab,b);
      end;
      Assign(normal.all,c);
      return 0;
    end if;
  end Job15;

  function Job17 return integer32 is -- init random coefficient system

    q : Standard_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a random coefficient polynomial system ...");
    get(q);
    Cells_Container.Initialize_Random_Standard_Coefficient_System(q.all);
    return 0;
  end Job17;

  function Job27 return integer32 is -- init random dd coefficient system

    q : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a random coefficient polynomial system ...");
    get(q);
    Cells_Container.Initialize_Random_DoblDobl_Coefficient_System(q.all);
    return 0;
  end Job27;

  function Job37 return integer32 is -- init random qd coefficient system

    q : QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys;

  begin
    new_line;
    put_line("Reading a random coefficient polynomial system ...");
    get(q);
    Cells_Container.Initialize_Random_QuadDobl_Coefficient_System(q.all);
    return 0;
  end Job37;

  function Job18 return integer32 is -- write random coefficient system

    q : constant Standard_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_Standard_Coefficient_System;

  begin
    if PHCpack_Operations.Is_File_Defined then
      put_line(PHCpack_Operations.output_file,q.all);
      new_line(PHCpack_Operations.output_file);
      put_line(PHCpack_Operations.output_file,"THE SOLUTIONS :");
    else
      put_line(standard_output,q.all);
      new_line(standard_output);
      put_line(standard_output,"THE SOLUTIONS :");
    end if;
    return 0;
  end Job18;

  function Job28 return integer32 is -- write random dd coefficient system

    q : constant DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_DoblDobl_Coefficient_System;

  begin
    if PHCpack_Operations.Is_File_Defined then
      put_line(PHCpack_Operations.output_file,q.all);
      new_line(PHCpack_Operations.output_file);
      put_line(PHCpack_Operations.output_file,"THE SOLUTIONS :");
    else
      put_line(standard_output,q.all);
      new_line(standard_output);
      put_line(standard_output,"THE SOLUTIONS :");
    end if;
    return 0;
  end Job28;

  function Job38 return integer32 is -- write random qd coefficient system

    q : constant QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_QuadDobl_Coefficient_System;

  begin
    if PHCpack_Operations.Is_File_Defined then
      put_line(PHCpack_Operations.output_file,q.all);
      new_line(PHCpack_Operations.output_file);
      put_line(PHCpack_Operations.output_file,"THE SOLUTIONS :");
    else
      put_line(standard_output,q.all);
      new_line(standard_output);
      put_line(standard_output,"THE SOLUTIONS :");
    end if;
    return 0;
  end Job38;

  function Job19 return integer32 is -- copy into st systems container

    q : constant Standard_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_Standard_Coefficient_System;

  begin
    Standard_PolySys_Container.Initialize(q.all);
    return 0;
  end Job19;

  function Job29 return integer32 is -- copy into dd systems container

    q : constant DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_DoblDobl_Coefficient_System;

  begin
    DoblDobl_PolySys_Container.Initialize(q.all);
    return 0;
  end Job29;

  function Job39 return integer32 is -- copy into qd systems container

    q : constant QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := Cells_Container.Retrieve_Random_QuadDobl_Coefficient_System;

  begin
    QuadDobl_PolySys_Container.Initialize(q.all);
    return 0;
  end Job39;

  function Job20 return integer32 is -- copy from systems container

    q : constant Standard_Complex_Poly_Systems.Link_to_Poly_Sys
      := Standard_PolySys_Container.Retrieve;

  begin
    Cells_Container.Initialize_Random_Standard_Coefficient_System(q.all);
    return 0;
  end Job20;

  function Job30 return integer32 is -- copy from dd systems container

    q : constant DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := DoblDobl_PolySys_Container.Retrieve;

  begin
    Cells_Container.Initialize_Random_DoblDobl_Coefficient_System(q.all);
    return 0;
  end Job30;

  function Job40 return integer32 is -- copy from qd systems container

    q : constant QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys
      := QuadDobl_PolySys_Container.Retrieve;

  begin
    Cells_Container.Initialize_Random_QuadDobl_Coefficient_System(q.all);
    return 0;
  end Job40;

  function Job22 return integer32 is -- solve a standard start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
   -- put("Entering Job22 with k = "); put(k,1); put_line(" ...");
    Cells_Container.Solve_Standard_Start_System(k,mv);
    Assign(integer32(mv),b);
   -- put("... leaving Job22 with mv = "); put(mv,1); put_line(".");
    return 0;
  end Job22;

  function Job32 return integer32 is -- solve a dobldobl start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
   -- put("Entering Job22 with k = "); put(k,1); put_line(" ...");
    Cells_Container.Solve_DoblDobl_Start_System(k,mv);
    Assign(integer32(mv),b);
   -- put("... leaving Job22 with mv = "); put(mv,1); put_line(".");
    return 0;
  end Job32;

  function Job42 return integer32 is -- solve a quaddobl start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
   -- put("Entering Job22 with k = "); put(k,1); put_line(" ...");
    Cells_Container.Solve_QuadDobl_Start_System(k,mv);
    Assign(integer32(mv),b);
   -- put("... leaving Job22 with mv = "); put(mv,1); put_line(".");
    return 0;
  end Job42;

  function Job23 return integer32 is -- track a solution path

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    vb : constant C_Integer_Array
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    i : constant natural32 := natural32(vb(vb'first));
    otp : constant natural32 := natural32(vb(vb'first+1));

  begin
    Cells_Container.Track_Standard_Solution_Path(k,i,otp);
    return 0;
  end Job23;

  function Job33 return integer32 is -- track a solution path

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    vb : constant C_Integer_Array
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    i : constant natural32 := natural32(vb(vb'first));
    otp : constant natural32 := natural32(vb(vb'first+1));

  begin
    Cells_Container.Track_DoblDobl_Solution_Path(k,i,otp);
    return 0;
  end Job33;

  function Job43 return integer32 is -- track a solution path

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    vb : constant C_Integer_Array
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    i : constant natural32 := natural32(vb(vb'first));
    otp : constant natural32 := natural32(vb(vb'first+1));

  begin
    Cells_Container.Track_QuadDobl_Solution_Path(k,i,otp);
    return 0;
  end Job43;

  function Job24 return integer32 is -- copy target solution to st container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : Standard_Complex_Solutions.Link_to_Solution;

    use Standard_Complex_Solutions;

  begin
    ls := Cells_Container.Retrieve_Standard_Target_Solution(k,i);
    if ls /= null
     then Standard_Solutions_Container.Append(ls.all);
    end if;
    return 0;
  end Job24;

  function Job34 return integer32 is -- copy target solution to dd container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : DoblDobl_Complex_Solutions.Link_to_Solution;

    use DoblDobl_Complex_Solutions;

  begin
    ls := Cells_Container.Retrieve_DoblDobl_Target_Solution(k,i);
    if ls /= null
     then DoblDobl_Solutions_Container.Append(ls.all);
    end if;
    return 0;
  end Job34;

  function Job44 return integer32 is -- copy target solution to qd container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : QuadDobl_Complex_Solutions.Link_to_Solution;

    use QuadDobl_Complex_Solutions;

  begin
    ls := Cells_Container.Retrieve_QuadDobl_Target_Solution(k,i);
    if ls /= null
     then QuadDobl_Solutions_Container.Append(ls.all);
    end if;
    return 0;
  end Job44;

  function Job48 return integer32 is -- copy start solution to st container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : Standard_Complex_Solutions.Link_to_Solution;

  begin
    ls := Cells_Container.Retrieve_Standard_Start_Solution(k,i);
    Standard_Solutions_Container.Append(ls.all);
    return 0;
  end Job48;

  function Job49 return integer32 is -- copy start solution to dd container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : DoblDobl_Complex_Solutions.Link_to_Solution;

  begin
    ls := Cells_Container.Retrieve_DoblDobl_Start_Solution(k,i);
    DoblDobl_Solutions_Container.Append(ls.all);
    return 0;
  end Job49;

  function Job50 return integer32 is -- copy start solution to qd container

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    i : constant natural32 := natural32(vb(vb'first));
    ls : QuadDobl_Complex_Solutions.Link_to_Solution;

  begin
    ls := Cells_Container.Retrieve_QuadDobl_Start_Solution(k,i);
    QuadDobl_Solutions_Container.Append(ls.all);
    return 0;
  end Job50;

  function Job25 return integer32 is -- permute system in st container 

    use Floating_mixed_Subdivisions;

    mixsub : constant Mixed_Subdivision := Cells_Container.Retrieve;
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    lp : constant Standard_Complex_Poly_Systems.Link_to_Poly_Sys
       := Standard_PolySys_Container.Retrieve;
    lq : constant Standard_Complex_Laur_Systems.Link_to_Laur_Sys
       := Standard_LaurSys_Container.Retrieve;
    use Standard_Complex_Poly_Systems,Standard_Complex_Laur_Systems;

  begin
    if lp /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lp'range)
            := Supports_of_Polynomial_Systems.Create(lp.all);
        stlb : constant double_float 
             := Floating_Lifting_Functions.Lifting_Bound(lp.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        Induced_Permutations.Remove_Artificial_Origin(ls,stlb);
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
       -- put("the permutation : "); put(ip); new_line;
       -- put_line("before permute :"); put(lp.all);
        Induced_Permutations.Permute(ip,lp.all);
       -- put_line("after permute :"); put(lp.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    if lq /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lq'range)
            := Supports_of_Polynomial_Systems.Create(lq.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
        Induced_Permutations.Permute(ip,lq.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    return 0;
  end Job25;

  function Job35 return integer32 is -- permute system in dd container 

    use Floating_mixed_Subdivisions;

    mixsub : constant Mixed_Subdivision := Cells_Container.Retrieve;
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    lp : constant DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys
       := DoblDobl_PolySys_Container.Retrieve;
    lq : constant DoblDobl_Complex_Laur_Systems.Link_to_Laur_Sys
       := DoblDobl_LaurSys_Container.Retrieve;
    use DoblDobl_Complex_Poly_Systems,DoblDobl_Complex_Laur_Systems;

  begin
    if lp /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lp'range)
            := Supports_of_Polynomial_Systems.Create(lp.all);
        stlb : constant double_float 
             := Floating_Lifting_Functions.Lifting_Bound(lp.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        Induced_Permutations.Remove_Artificial_Origin(ls,stlb);
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
       -- put("the permutation : "); put(ip); new_line;
       -- put_line("before permute :"); put(lp.all);
        Induced_Permutations.Permute(ip,lp.all);
       -- put_line("after permute :"); put(lp.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    if lq /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lq'range)
            := Supports_of_Polynomial_Systems.Create(lq.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
        Induced_Permutations.Permute(ip,lq.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    return 0;
  end Job35;

  function Job45 return integer32 is -- permute system in qd container 

    use Floating_mixed_Subdivisions;

    mixsub : constant Mixed_Subdivision := Cells_Container.Retrieve;
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Cells_Container.Type_of_Mixture;
    lp : constant QuadDobl_Complex_Poly_Systems.Link_to_Poly_Sys
       := QuadDobl_PolySys_Container.Retrieve;
    lq : constant QuadDobl_Complex_Laur_Systems.Link_to_Laur_Sys
       := QuadDobl_LaurSys_Container.Retrieve;
    use QuadDobl_Complex_Poly_Systems,QuadDobl_Complex_Laur_Systems;

  begin
    if lp /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lp'range)
            := Supports_of_Polynomial_Systems.Create(lp.all);
        stlb : constant double_float 
             := Floating_Lifting_Functions.Lifting_Bound(lp.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        Induced_Permutations.Remove_Artificial_Origin(ls,stlb);
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
       -- put("the permutation : "); put(ip); new_line;
       -- put_line("before permute :"); put(lp.all);
        Induced_Permutations.Permute(ip,lp.all);
       -- put_line("after permute :"); put(lp.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    if lq /= null then
      declare
        sup : Arrays_of_Integer_Vector_Lists.Array_of_Lists(lq'range)
            := Supports_of_Polynomial_Systems.Create(lq.all);
        fs : Arrays_of_Floating_Vector_Lists.Array_of_Lists(sup'range)
           := Floating_Integer_Convertors.Convert(sup);
        ls : Arrays_of_Floating_Vector_Lists.Array_of_Lists(mix'range)
           := Floating_Lifting_Utilities.Lifted_Supports(mix'last,mixsub);
        ip : Standard_Integer_Vectors.Vector(fs'range);
      begin
        ip := Induced_Permutations.Permutation(fs,ls,mix.all);
        Induced_Permutations.Permute(ip,lq.all);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(fs);
        Arrays_of_Floating_Vector_Lists.Deep_Clear(ls);
        Arrays_of_Integer_Vector_Lists.Deep_Clear(sup);
      end;
    end if;
    return 0;
  end Job45;

  function Job46 return integer32 is -- mixed volume computation

    mv : constant natural32 := Cells_Container.Mixed_Volume;

  begin
    Assign(integer32(mv),a);
    return 0;
  end Job46;

  function Job47 return integer32 is -- initialize #distinct supports

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    nbr : constant natural32 := natural32(v_a(v_a'first));

  begin
    Cells_Container.Initialize_Supports(nbr);
    return 0;
  end Job47;

  function Job51 return integer32 is  -- read mcc and initialize container

    use Arrays_of_Integer_Vector_Lists;
    use Integer_Mixed_Subdivisions;
  
    file : file_type;
    n,m : natural32;
    r : integer32;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    lif : Link_to_Array_of_Lists;
    sub : Mixed_Subdivision;

  begin
    new_line;
    put_line("Reading the file name for a mixed-cell configuration.");
    Read_Name_and_Open_File(file);
    get(file,n,m,mix,sub);
    close(file);
    r := mix'last;
    lif := new Array_of_Lists'(Lifted_Supports(r,sub));
    Integer_Cells_Container.Initialize(mix,lif,sub);
    return 0;
  end Job51;

  function Job52 return integer32 is -- write the mcc in the container

    use Integer_Mixed_Subdivisions;

    mcc : Mixed_Subdivision := Integer_Cells_Container.Retrieve;
    mix : Standard_Integer_Vectors.Link_to_Vector;
    n,mv : natural32;

  begin
    if not Is_Null(mcc) then
      n := Integer_Cells_Container.Dimension;
      mix := Integer_Cells_Container.Type_of_Mixture;
      put(standard_output,n-1,mix.all,mcc,mv);
      put("The mixed volume is "); put(mv,1); put_line(".");
    end if;
    return 0;
  end Job52;

  function Job55 return integer32 is -- return type of mixture

    use Standard_Integer_Vectors;
    mix : Link_to_Vector;
    r : integer32;

  begin
    mix := Integer_Cells_Container.Type_of_Mixture;
    if mix /= null
     then r := mix'last; Assign(mix.all,b);
     else r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job55;

  function Job56 return integer32 is -- return cardinalities of supports

    use Lists_of_Integer_Vectors;
    use Arrays_of_Integer_Vector_Lists;

    lif : Link_to_Array_of_Lists;
    r : integer32;

  begin
    lif := Integer_Cells_Container.Lifted_Supports;
    if lif /= null then
      r := lif'last;
      declare
        nl : Standard_Integer_Vectors.Vector(1..r);
      begin
        for i in nl'range loop
          nl(i) := integer32(Length_Of(lif(i)));
        end loop;
        Assign(nl,b);
      end;
    else
      r := 0;
    end if;
    Assign(r,a);
    return 0;
  end Job56;

  function Job57 return integer32 is -- return point in support

    use Arrays_of_Integer_Vector_Lists;

    lif : Link_to_Array_of_Lists;
    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array := C_intarrs.Value(b);
    k_a : constant integer32 := integer32(v_a(v_a'first));
    k_b : constant natural32 := natural32(v_b(v_b'first));
    use Standard_Integer_Vectors;
    lpt : Link_to_Vector;

  begin
    lif := Integer_Cells_Container.Lifted_Supports;
   -- put("retrieving point "); put(k_b,1);
   -- put(" from list "); put(k_a,1); put_line(" ...");
    if lif /= null then
      lpt := Select_Point(lif(k_a),k_b);
      if lpt /= null then
        declare
          fltlpt : Standard_Floating_Vectors.Vector(lpt'range);
        begin
          for k in lpt'range loop
            fltlpt(k) := double_float(lpt(k));
          end loop;
          Assign(fltlpt,c);     
        end;
        return 0;
      end if;
    end if;
    return 1;
  end Job57;

  function Job58 return integer32 is -- return innner normal

    use Integer_Mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Integer_Cells_Container.Retrieve(k,mic,fail);
    if fail then
      return 1;
    else
      declare
        fltnor : Standard_Floating_Vectors.Vector(mic.nor'range);
      begin
        for k in mic.nor'range loop
          fltnor(k) := double_float(mic.nor(k));
        end loop;
        Assign(fltnor,c); return 0;
      end;
    end if;
  end Job58;

  function Job59 return integer32 is -- return #elements in cell

    use Lists_of_Integer_Vectors;
    use Integer_Mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mic : Mixed_Cell;
    fail : boolean;

  begin
    Integer_Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      declare
        nl : Standard_Integer_Vectors.Vector(mic.pts'range);
      begin
        for i in mic.pts'range loop
          nl(i) := integer32(Length_Of(mic.pts(i)));
        end loop;
        Assign(nl,b);
      end;
      return 0;
    end if;
    return 1;
  end Job59;

  function Job60 return integer32 is -- return point in a cell

    use Integer_Mixed_Subdivisions;

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    v_b : constant C_Integer_Array
        := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(2));
    k : constant natural32 := natural32(v_a(v_a'first));
    i : constant integer32 := integer32(v_b(v_b'first));
    j : constant natural32 := natural32(v_b(v_b'first+1));
    mic : Mixed_Cell;
    fail : boolean;
    use Standard_Integer_Vectors;
    lpt : Link_to_Vector;

  begin
    Integer_Cells_Container.Retrieve(k,mic,fail);
    if not fail then
      lpt := Select_Point(mic.pts(i),j);
      if lpt /= null then
        declare
          fltlpt : Standard_Floating_Vectors.Vector(lpt'range);
        begin
          for k in lpt'range loop
            fltlpt(k) := double_float(lpt(k));
          end loop;
          Assign(fltlpt,c);
        end;
        return 0;
      end if;
    end if;
    return 1;
  end Job60;

  function Job61 return integer32 is -- return mixed volume of a cell

    use Integer_Mixed_Subdivisions;

    v : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(v(v'first));
    mix : constant Standard_Integer_Vectors.Link_to_Vector
        := Integer_Cells_Container.Type_of_Mixture;
    mic : Mixed_Cell;
    fail : boolean;
    mv : natural32;
    n : constant integer32 := integer32(Integer_Cells_Container.Dimension)-1;

    use Standard_Integer_Vectors;

  begin
   -- put("The dimension : "); put(n,1); new_line;
   -- put("retrieving mixed cell "); put(k,1); put_line(" ...");
    Integer_Cells_Container.Retrieve(k,mic,fail);
    if fail or mix = null then
     -- put_line("failure!");
      return 1;
    else
     -- put("The type of mixture :"); put(mix); new_line;
      Mixed_Volume(n,mix.all,mic,mv);
     -- put("The mixed volume mv is "); put(mv,1); put_line(".");
      Assign(integer32(mv),b);
      return 0;
    end if;
  end Job61;

  function Job62 return integer32 is -- initialize #distinct supports

    v_a : constant C_Integer_Array := C_intarrs.Value(a);
    nbr : constant natural32 := natural32(v_a(v_a'first));

  begin
    Integer_Cells_Container.Initialize_Supports(nbr);
    return 0;
  end Job62;

  function Job63 return integer32 is -- sets type of mixture

    v : constant C_Integer_Array := C_intarrs.Value(a);
    r : constant integer32 := integer32(v(v'first));
    mix : Standard_Integer_Vectors.Vector(1..r);
    lnkmix : Standard_Integer_Vectors.Link_to_Vector;
    r1 : constant Interfaces.C.size_t := Interfaces.C.size_t(r-1);
    mbv : constant C_Integer_Array(0..r1)
        := C_Intarrs.Value(b,Interfaces.C.ptrdiff_t(r));

  begin
    for i in 0..r-1 loop
      mix(i+1) := integer32(mbv(Interfaces.C.size_t(i)));
    end loop;
    lnkmix := new Standard_Integer_Vectors.Vector'(mix);
    Integer_Cells_Container.Initialize(lnkmix);
    return 0;
  end Job63;

  function Job64 return integer32 is -- append point to a support

    va : constant C_Integer_Array := C_intarrs.Value(a);
    vb : constant C_Integer_Array := C_intarrs.Value(b);
    k : constant natural32 := natural32(va(va'first));
    n : constant integer32 := integer32(vb(vb'first));
    x : Standard_Integer_Vectors.Vector(1..n);
    fltx : Standard_Floating_Vectors.Vector(1..n);
    fail : boolean;

  begin
    Assign(natural32(n),c,fltx);
    for k in 1..n loop
      x(k) := integer32(fltx(k));
    end loop;
    fail := Integer_Cells_Container.Append_to_Support(k,x);
    if fail
     then return 1;
     else return 0;
    end if;
  end Job64;

  function Job65 return integer32 is -- append mixed cell to container

    va : constant C_Integer_Array
       := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(3));
    r : constant integer32 := integer32(va(va'first));
    n : constant integer32 := integer32(va(va'first+1));
    d : constant Interfaces.C.size_t := Interfaces.C.size_t(va(2));
    vb : constant C_Integer_Array(0..d-1)
       := C_intarrs.Value(b,Interfaces.C.ptrdiff_t(d));
    m : constant integer32 := integer32(vb(0));
    x : Standard_Integer_Vectors.Vector(1..n);
    fltx : Standard_Floating_Vectors.Vector(1..n);
    cnt : Standard_Integer_Vectors.Vector(1..r);
    lab : Standard_Integer_Vectors.Vector(1..m);

  begin
   -- put("  r = "); put(r,1);
   -- put("  n = "); put(n,1);
   -- put("  d = "); put(natural(d),1); new_line;
    for i in cnt'range loop
      cnt(i) := integer32(vb(Interfaces.C.size_t(i)));
    end loop;
    for i in lab'range loop
      lab(i) := integer32(vb(Interfaces.C.size_t(i+r)));
    end loop;
   -- put("the number of points in each support :"); put(cnt); new_line;
   -- put("the labels of points in each support :"); put(lab); new_line;
    Assign(natural32(n),c,fltx);
    for k in 1..n loop
      x(k) := integer32(fltx(k));
    end loop;
    Integer_Cells_Container.Append_Mixed_Cell(cnt,lab,x);
    return 0;
  end Job65;

  function Job67 return integer32 is -- retrieve a mixed cell

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    cnt,lab : Standard_Integer_Vectors.Link_to_Vector;
    normal : Standard_Integer_Vectors.Link_to_Vector;
    fail : boolean;

  begin
    Integer_Cells_Container.Retrieve_Mixed_Cell(k,fail,cnt,lab,normal);
    if fail then
      return 1;
    else
      declare
        sum : constant integer32 := Standard_Integer_Vectors.Sum(cnt.all);
        cntlab : Standard_Integer_Vectors.Vector(1..cnt'last+lab'last+1);
        ind : integer32 := 0;
        fltnor : Standard_Floating_Vectors.Vector(normal'range);
      begin
        ind := ind + 1;
        cntlab(ind) := sum;
        for i in cnt'range loop
          ind := ind + 1;
          cntlab(ind) := cnt(i);
        end loop;
        for i in lab'range loop
          ind := ind + 1;
          cntlab(ind) := lab(i);
        end loop;
        Assign(cntlab,b);
        for k in normal'range loop
          fltnor(k) := double_float(normal(k));
        end loop;
        Assign(fltnor,c);
      end;
      return 0;
    end if;
  end Job67;

  function Job69 return integer32 is
  begin
    if Cells_Container.Is_Stable
     then Assign(1,a);
     else Assign(0,a);
    end if;
    return 0;
  end Job69;

  function Job70 return integer32 is

    nbr : constant natural32 := Cells_Container.Number_of_Original_Cells;

  begin
    Assign(integer32(nbr),a);
    return 0;
  end Job70;

  function Job71 return integer32 is

    nbr : constant natural32 := Cells_Container.Number_of_Stable_Cells;

  begin
    Assign(integer32(nbr),a);
    return 0;
  end Job71;

  function Job72 return integer32 is -- solve a stable standard start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
    Cells_Container.Solve_Stable_Standard_Start_System(k,mv);
    Assign(integer32(mv),b);
    return 0;
  end Job72;

  function Job73 return integer32 is -- solve a stable dobldobl start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
    Cells_Container.Solve_Stable_DoblDobl_Start_System(k,mv);
    Assign(integer32(mv),b);
    return 0;
  end Job73;

  function Job74 return integer32 is -- solve a stable quaddobl start system

    va : constant C_Integer_Array := C_intarrs.Value(a);
    k : constant natural32 := natural32(va(va'first));
    mv : natural32;

  begin
    Cells_Container.Solve_Stable_QuadDobl_Start_System(k,mv);
    Assign(integer32(mv),b);
    return 0;
  end Job74;
 
  function Handle_Jobs return integer32 is
  begin
    case job is
      when 0 => return Job0;   -- read a mcc and initialize the container
      when 1 => return Job1;   -- write the mcc in the container
      when 2 => Assign(integer32(Cells_Container.Length),a); return 0;
      when 3 => Assign(integer32(Cells_Container.Dimension),a); return 0;
      when 4 => return Job4;   -- return type of mixture
      when 5 => return Job5;   -- return cardinalities of supports
      when 6 => return Job6;   -- return point in support 
      when 7 => return Job7;   -- return innner normal
      when 8 => return Job8;   -- return #elements in cell
      when 9 => return Job9;   -- return point in a cell
      when 10 => return Job10; -- return mixed volume of a cell
      when 11 => return Job11; -- set type of mixture
      when 12 => return Job12; -- append point to a support
      when 13 => return Job13; -- append mixed cell to container
      when 14 => Cells_Container.Clear; return 0;
      when 15 => return Job15; -- retrieve a mixed cell
      when 16 => Cells_Container.Generate_Random_Standard_Coefficient_System;
                 return 0;
      when 17 => return Job17; -- initialize random coefficient system
      when 18 => return Job18; -- write random coefficient system
      when 19 => return Job19; -- copy into systems container
      when 20 => return Job20; -- copy from systems container
      when 21 => Cells_Container.Standard_Polyhedral_Homotopy; return 0;
      when 22 => return Job22; -- solve a standard start system
      when 23 => return Job23; -- track path in standard precision
      when 24 => return Job24; -- copy target solution to st container
      when 25 => return Job25; -- permute a standard target system
      when 26 => Cells_Container.Generate_Random_DoblDobl_Coefficient_System;
                 return 0;
      when 27 => return Job27; -- init random dobldobl coefficient system
      when 28 => return Job28; -- write random dobldobl coefficient system
      when 29 => return Job29; -- copy into dobldobl systems container
      when 30 => return Job30; -- copy from dobldobl systems container
      when 31 => Cells_Container.DoblDobl_Polyhedral_Homotopy; return 0;
      when 32 => return Job32; -- solve a dobldobl start system
      when 33 => return Job33; -- track path in double double precision
      when 34 => return Job34; -- copy target solution to dd container
      when 35 => return Job35; -- permute dobldobl target system
      when 36 => Cells_Container.Generate_Random_QuadDobl_Coefficient_System;
                 return 0;
      when 37 => return Job37; -- init random quaddobl coefficient system
      when 38 => return Job38; -- write random quaddobl coefficient system
      when 39 => return Job39; -- copy into quaddobl systems container
      when 40 => return Job40; -- copy from quaddobl systems container
      when 41 => Cells_Container.QuadDobl_Polyhedral_Homotopy; return 0;
      when 42 => return Job42; -- solve a quaddobl start system
      when 43 => return Job43; -- track path in quad double precision
      when 44 => return Job44; -- copy target solution to qd container
      when 45 => return Job45; -- permute quaddobl target system
      when 46 => return Job46; -- mixed volume computation
      when 47 => return Job47; -- initialize number of distinct supports
      when 48 => return Job48; -- copy start solution to st container
      when 49 => return Job49; -- copy start solution to dd container
      when 50 => return Job50; -- copy start solution to qd container
      when 51 => return Job51; -- read mcc, initialize integer cells
      when 52 => return Job52; -- write mcc from the integer cells container
      when 53 => Assign(integer32(Integer_Cells_Container.Length),a);
                 return 0;
      when 54 => Assign(integer32(Integer_Cells_Container.Dimension),a);
                 return 0;
      when 55 => return Job55; -- return type of mixture for integer cells
      when 56 => return Job56; -- return cardinalities of supports
      when 57 => return Job57; -- return integer point in support 
      when 58 => return Job58; -- return integer innner normal
      when 59 => return Job59; -- return #elements in integer cell
      when 60 => return Job60; -- return point in a integer cell
      when 61 => return Job61; -- return mixed volume of a integer cell
      when 62 => return Job62; -- set number of supports
      when 63 => return Job63; -- set type of mixture
      when 64 => return Job64; -- append point to a support
      when 65 => return Job65; -- append mixed cell to container
      when 66 => Integer_Cells_Container.Clear; return 0;
      when 67 => return Job67; -- retrieve a mixed cell
      when 68 => Integer_Cells_Container.Make_Subdivision; return 0;
      when 69 => return Job69; -- returns Is_Stable
      when 70 => return Job70; -- return the number of original cells
      when 71 => return Job71; -- return the number of stable cells
      when 72 => return Job72; -- solve a stable standard start system
      when 73 => return Job73; -- solve a stable dobldobl start system
      when 74 => return Job74; -- solve a stable quaddobl start system
      when others => put_line("invalid operation"); return 1;
    end case;
  exception
    when others => put("Exception raised in use_celcon handling job ");
                   put(job,1); put_line(".  Will try to ignore...");
                   return 1;
  end Handle_Jobs;

begin
  return Handle_Jobs;
end use_celcon;
