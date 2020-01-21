with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Double_Double_Numbers_io;           use Double_Double_Numbers_io;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;
with Standard_Complex_VecVecs_io;        use Standard_Complex_VecVecs_io;
with DoblDobl_Complex_VecVecs_io;        use DoblDobl_Complex_VecVecs_io;
with QuadDobl_Complex_VecVecs_io;        use QUadDobl_Complex_VecVecs_io;
with Standard_Series_Matrix_Solvers;
with DoblDobl_Series_Matrix_Solvers;
with QuadDobl_Series_Matrix_Solvers;

package body Newton_Convolutions is

  function Series_Coefficients
             ( v : Standard_Complex_Vectors.Vector;
               d : integer32 )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(v'range);

  begin
    for k in res'range loop
      declare
        cff : Standard_Complex_Vectors.Vector(0..d);
      begin
        cff(0) := v(k);
        cff(1..d) := (1..d => Standard_Complex_Numbers.Create(0.0));
        res(k) := new Standard_Complex_Vectors.Vector'(cff);
      end;
    end loop;
    return res;
  end Series_Coefficients;

  function Series_Coefficients
             ( v : DoblDobl_Complex_Vectors.Vector;
               d : integer32 )
             return DoblDobl_Complex_VecVecs.VecVec is

    res : DoblDobl_Complex_VecVecs.VecVec(v'range);
    zero : constant double_double := create(0.0);

  begin
    for k in res'range loop
      declare
        cff : DoblDobl_Complex_Vectors.Vector(0..d);
      begin
        cff(0) := v(k);
        cff(1..d) := (1..d => DoblDobl_Complex_Numbers.Create(zero));
        res(k) := new DoblDobl_Complex_Vectors.Vector'(cff);
      end;
    end loop;
    return res;
  end Series_Coefficients;

  function Series_Coefficients
             ( v : QuadDobl_Complex_Vectors.Vector;
               d : integer32 )
             return QuadDobl_Complex_VecVecs.VecVec is

    res : QuadDobl_Complex_VecVecs.VecVec(v'range);
    zero : constant quad_double := create(0.0);

  begin
    for k in res'range loop
      declare
        cff : QuadDobl_Complex_Vectors.Vector(0..d);
      begin
        cff(0) := v(k);
        cff(1..d) := (1..d => QuadDobl_Complex_Numbers.Create(zero));
        res(k) := new QuadDobl_Complex_Vectors.Vector'(cff);
      end;
    end loop;
    return res;
  end Series_Coefficients;

  procedure Minus ( v : in Standard_Complex_VecVecs.VecVec ) is

    cf : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for i in v'range loop
      cf := v(i);
      for j in cf'range loop
        Standard_Complex_Numbers.Min(cf(j));
      end loop;
    end loop;
  end Minus;

  procedure Minus ( v : in DoblDobl_Complex_VecVecs.VecVec ) is

    cf : DoblDobl_Complex_Vectors.Link_to_Vector;

  begin
    for i in v'range loop
      cf := v(i);
      for j in cf'range loop
        DoblDobl_Complex_Numbers.Min(cf(j));
      end loop;
    end loop;
  end Minus;

  procedure Minus ( v : in QuadDobl_Complex_VecVecs.VecVec ) is

    cf : QuadDobl_Complex_Vectors.Link_to_Vector;

  begin
    for i in v'range loop
      cf := v(i);
      for j in cf'range loop
        QuadDobl_Complex_Numbers.Min(cf(j));
      end loop;
    end loop;
  end Minus;

  procedure Power_Divide
	      ( x : in Standard_Complex_VecVecs.VecVec;
	        f : in double_float ) is

    fac : double_float := f;
    lnk : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for k in 1..x'last loop
      lnk := x(k);
      for i in lnk'range loop
        Standard_Complex_Numbers.Div(lnk(i),fac);
      end loop;
      fac := f*fac;
    end loop;
  end Power_Divide;

  procedure Power_Divide
	      ( x : in DoblDobl_Complex_VecVecs.VecVec;
	        f : in double_double ) is

    fac : double_double := f;
    lnk : DoblDobl_Complex_Vectors.Link_to_Vector;

  begin
    for k in 1..x'last loop
      lnk := x(k);
      for i in lnk'range loop
        DoblDobl_Complex_Numbers.Div(lnk(i),fac);
      end loop;
      fac := f*fac;
    end loop;
  end Power_Divide;

  procedure Power_Divide
	      ( x : in QuadDobl_Complex_VecVecs.VecVec;
	        f : in quad_double ) is

    fac : quad_double := f;
    lnk : QuadDobl_Complex_Vectors.Link_to_Vector;

  begin
    for k in 2..x'last loop
      lnk := x(k);
      for i in lnk'range loop
        QuadDobl_Complex_Numbers.Div(lnk(i),fac);
      end loop;
      fac := f*fac;
    end loop;
  end Power_Divide;

  procedure Update ( x,y : in Standard_Complex_VecVecs.VecVec ) is

    xcf,ycf : Standard_Complex_Vectors.Link_to_Vector;

  begin
    for i in x'range loop
      xcf := x(i);
      ycf := y(i);
      for j in xcf'range loop
        Standard_Complex_Numbers.Add(xcf(j),ycf(j));
      end loop;
    end loop;
  end Update;

  procedure Update ( x,y : in DoblDobl_Complex_VecVecs.VecVec ) is

    xcf,ycf : DoblDobl_Complex_Vectors.Link_to_Vector;

  begin
    for i in x'range loop
      xcf := x(i);
      ycf := y(i);
      for j in xcf'range loop
        DoblDobl_Complex_Numbers.Add(xcf(j),ycf(j));
      end loop;
    end loop;
  end Update;

  procedure Update ( x,y : in QuadDobl_Complex_VecVecs.VecVec ) is

    xcf,ycf : QuadDobl_Complex_Vectors.Link_to_Vector;

  begin
    for i in x'range loop
      xcf := x(i);
      ycf := y(i);
      for j in xcf'range loop
        QuadDobl_Complex_Numbers.Add(xcf(j),ycf(j));
      end loop;
    end loop;
  end Update;

  function Max ( v : Standard_Complex_Vectors.Link_to_Vector )
               return double_float is

    res : double_float := Standard_Complex_Numbers.AbsVal(v(v'first));
    val : double_float;

  begin
    for k in v'first+1..v'last loop
      val := Standard_Complex_Numbers.AbsVal(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

  function Max ( v : DoblDobl_Complex_Vectors.Link_to_Vector )
               return double_double is

    res : double_double := DoblDobl_Complex_Numbers.AbsVal(v(v'first));
    val : double_double;

  begin
    for k in v'first+1..v'last loop
      val := DoblDobl_Complex_Numbers.AbsVal(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

  function Max ( v : QuadDobl_Complex_Vectors.Link_to_Vector )
               return quad_double is

    res : quad_double := QuadDobl_Complex_Numbers.AbsVal(v(v'first));
    val : quad_double;

  begin
    for k in v'first+1..v'last loop
      val := QuadDobl_Complex_Numbers.AbsVal(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

  function Max ( v : Standard_Complex_VecVecs.VecVec ) return double_float is

    res : double_float := Max(v(v'first));
    val : double_float;

  begin
    for k in v'first+1..v'last loop
      val := Max(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

  function Max ( v : DoblDobl_Complex_VecVecs.VecVec ) return double_double is

    res : double_double := Max(v(v'first));
    val : double_double;

  begin
    for k in v'first+1..v'last loop
      val := Max(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

  function Max ( v : QuadDobl_Complex_VecVecs.VecVec ) return quad_double is

    res : quad_double := Max(v(v'first));
    val : quad_double;

  begin
    for k in v'first+1..v'last loop
      val := Max(v(k));
      if val > res
       then res := val;
      end if;
    end loop;
    return res;
  end Max;

-- ONE NEWTON STEP WITH LU WITHOUT CONDITION NUMBER ESTIMATE :

  procedure LU_Newton_Step
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 1 ...");
    end if;
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    if scaledx
     then Power_Divide(s.vy,1.0);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := max(s.yv);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 2 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,1.0);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| :"); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 3 ...");
    end if;
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    if scaledx
     then Power_Divide(s.vy,fac);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 4 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,fac);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 5 ...");
    end if;
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    if scaledx
     then Power_Divide(s.vy,fac);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 6 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_lufac(s.vm,s.vy,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,fac);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

-- ONE NEWTON STEP WITH LU WITH CONDITION NUMBER ESTIMATE :

  procedure LU_Newton_Step
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                absdx,rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 7 ...");
    end if;
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    if scaledx
     then Power_Divide(s.vy,1.0);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                absdx,rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 8 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,1.0);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| :"); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in DoblDobl_Complex_VecVecs.VecVec;
                absdx,rcond  : out double_double;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 9 ...");
    end if;
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    if scaledx
     then Power_Divide(s.vy,fac);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.vy);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in DoblDobl_Complex_VecVecs.VecVec;
                absdx,rcond : out double_double;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 10 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,fac);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in QuadDobl_Complex_VecVecs.VecVec;
                absdx,rcond : out quad_double;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 11 ...");
    end if;
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    if scaledx
     then Power_Divide(s.vy,fac);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    Update(scf,s.yv);
  end LU_Newton_Step;

  procedure LU_Newton_Step
              ( file : in file_type;
                s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf : in QuadDobl_Complex_VecVecs.VecVec;
                absdx,rcond : out quad_double;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.LU_Newton_Step 12 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_lufco(s.vm,s.vy,ipvt,rcond,wrk);
    put_line(file,"dx :"); put_line(file,s.vy);
    if scaledx then
      Power_Divide(s.vy,fac);
      put_line(file,"scaled dx :"); put_line(file,s.vy);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(s.vy,s.yv);
    absdx := Max(s.yv);
    put(file,"max |dx| :"); put(file,absdx,3); new_line(file);
    Update(scf,s.yv);
  end LU_Newton_Step;

-- ONE NEWTON STEP WITH QR :

  procedure QR_Newton_Step
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float;
                qraux : out Standard_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out Standard_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 1 ...");
    end if;
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    if scaledx
     then Power_Divide(xd,1.0);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end QR_Newton_Step;

  procedure QR_Newton_Step
              ( file : in file_type;
                s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float;
                qraux : out Standard_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out Standard_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 2 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,1.0);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| :"); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end QR_Newton_Step;

  procedure QR_Newton_Step
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double;
                qraux : out DoblDobl_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out DoblDobl_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 3 ...");
    end if;
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    if scaledx
     then Power_Divide(xd,fac);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end QR_Newton_Step;

  procedure QR_Newton_Step
              ( file : in file_type;
                s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double;
                qraux : out DoblDobl_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out DoblDobl_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 4 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,fac);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end QR_Newton_Step;

  procedure QR_Newton_Step
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double;
                qraux : out QuadDobl_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out QuadDobl_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 5 ...");
    end if;
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    if scaledx
     then Power_Divide(xd,fac);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end QR_Newton_Step;

  procedure QR_Newton_Step
              ( file : in file_type;
                s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double;
                qraux : out QuadDobl_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out QuadDobl_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.QR_Newton_Step 6 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_QRLS
      (s.vm,s.vy,xd,qraux,w1,w2,w3,w4,w5,ipvt,info,wrk);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,fac);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end QR_Newton_Step;

-- ONE NEWTON STEP WITH SVD :

  procedure SVD_Newton_Step
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float;
                svl : out Standard_Complex_Vectors.Vector;
                U,V : out Standard_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_float;
                ewrk : in Standard_Complex_Vectors.Link_to_Vector;
                wrkv : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 1 ...");
    end if;
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    if scaledx
     then Power_Divide(xd,1.0);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end SVD_Newton_Step;

  procedure SVD_Newton_Step
              ( file : in file_type;
                s : in Standard_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                absdx : out double_float;
                svl : out Standard_Complex_Vectors.Vector;
                U,V : out Standard_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_float;
                ewrk : in Standard_Complex_Vectors.Link_to_Vector;
                wrkv : in Standard_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is
  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 2 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    Standard_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    Standard_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    Standard_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,1.0);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    Standard_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end SVD_Newton_Step;

  procedure SVD_Newton_Step
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double;
                svl : out DoblDobl_Complex_Vectors.Vector;
                U,V : out DoblDobl_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_double;
                ewrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
                wrkv : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 3 ...");
    end if;
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    if scaledx
     then Power_Divide(xd,fac);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end SVD_Newton_Step;

  procedure SVD_Newton_Step
              ( file : in file_type;
                s : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in DoblDobl_Complex_VecVecs.VecVec;
                absdx : out double_double;
                svl : out DoblDobl_Complex_Vectors.Vector;
                U,V : out DoblDobl_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_double;
                ewrk : in DoblDobl_Complex_Vectors.Link_to_Vector;
                wrkv : in DoblDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant double_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 4 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    DoblDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    DoblDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    DoblDobl_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,fac);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    DoblDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end SVD_Newton_Step;

  procedure SVD_Newton_Step
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double;
                svl : out QuadDobl_Complex_Vectors.Vector;
                U,V : out QuadDobl_Complex_Matrices.Matrix;
                info : out integer32; rcond : out quad_double;
                ewrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
                wrkv : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 5 ...");
    end if;
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    if scaledx
     then Power_Divide(xd,fac);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    Update(scf,dx);
  end SVD_Newton_Step;

  procedure SVD_Newton_Step
              ( file : in file_type;
                s : in QuadDobl_Speelpenning_Convolutions.Link_to_System;
                scf,dx,xd : in QuadDobl_Complex_VecVecs.VecVec;
                absdx : out quad_double;
                svl : out QuadDobl_Complex_Vectors.Vector;
                U,V : out QuadDobl_Complex_Matrices.Matrix;
                info : out integer32; rcond : out quad_double;
                ewrk : in QuadDobl_Complex_Vectors.Link_to_Vector;
                wrkv : in QuadDobl_Complex_Vectors.Link_to_Vector;
		scaledx : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    fac : constant quad_double := create(1.0);

  begin
    if vrblvl > 0 then
      put_line("-> in newton_convolutions.SVD_Newton_Step 6 ...");
    end if;
    put_line(file,"scf :"); put_line(file,scf);
    QuadDobl_Speelpenning_Convolutions.Compute(s.pwt,s.mxe,scf);
    QuadDobl_Speelpenning_Convolutions.EvalDiff(s,scf);
    put_line(file,"vy :"); put_line(file,s.vy);
    Minus(s.vy);
    QuadDobl_Series_Matrix_Solvers.Solve_by_SVD
      (s.vm,s.vy,xd,svl,U,V,info,rcond,ewrk,wrkv);
    put_line(file,"dx :"); put_line(file,xd);
    if scaledx then
      Power_Divide(xd,fac);
      put(file,"scaled dx :"); put_line(file,xd);
    end if;
    QuadDobl_Speelpenning_Convolutions.Delinearize(xd,dx);
    absdx := Max(dx);
    put(file,"max |dx| : "); put(file,absdx,3); new_line(file);
    Update(scf,dx);
  end SVD_Newton_Step;

end Newton_Convolutions;
