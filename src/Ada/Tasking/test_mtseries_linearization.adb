with duration_io;
with Ada.Calendar;
with Time_Stamps;
with Communications_with_User;           use Communications_with_User;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Double_Double_Numbers_io;           use Double_Double_Numbers_io;
with Triple_Double_Numbers_io;           use Triple_Double_Numbers_io;
with Quad_Double_Numbers_io;             use Quad_Double_Numbers_io;
with Standard_Complex_Vectors_io;        use Standard_Complex_Vectors_io;
with Standard_Complex_VecVecs_io;        use Standard_Complex_VecVecs_io;
with Standard_Complex_Matrices;
with Standard_Complex_VecMats_io;        use Standard_Complex_VecMats_io;
with DoblDobl_Complex_Vectors_io;        use DoblDobl_Complex_Vectors_io;
with DoblDobl_Complex_VecVecs_io;        use DoblDobl_Complex_VecVecs_io;
with DoblDobl_Complex_Matrices;
with DoblDobl_Complex_VecMats_io;        use DoblDobl_Complex_VecMats_io;
with TripDobl_Complex_Vectors_io;        use TripDobl_Complex_Vectors_io;
with TripDobl_Complex_VecVecs_io;        use TripDobl_Complex_VecVecs_io;
with TripDobl_Complex_Matrices;
with TripDobl_Complex_VecMats_io;        use TripDobl_Complex_VecMats_io;
with QuadDobl_Complex_Vectors_io;        use QuadDobl_Complex_Vectors_io;
with QuadDobl_Complex_VecVecs_io;        use QuadDobl_Complex_VecVecs_io;
with QuadDobl_Complex_Matrices;
with QuadDobl_Complex_VecMats_io;        use QuadDobl_Complex_VecMats_io;
with QuadDobl_Complex_Vectors_cv;
with QuadDobl_Complex_Matrices_cv;
with Standard_Complex_Singular_Values;
with DoblDobl_Complex_Singular_Values;
with TripDobl_Complex_Singular_Values;
with QuadDobl_Complex_Singular_Values;
with Standard_Complex_Series_Vectors;
with Standard_Complex_Series_Vectors_io; use Standard_Complex_Series_Vectors_io;
with Standard_Complex_Series_Matrices;
with Standard_Complex_Vector_Series_io;  use Standard_Complex_Vector_Series_io;
with Standard_Complex_Matrix_Series;
with Standard_Complex_Matrix_Series_io;  use Standard_Complex_Matrix_Series_io;
with Standard_Random_Series_Vectors;
with Standard_Random_Series_Matrices;
with Standard_Series_Matrix_Solvers;
with DoblDobl_Complex_Series_Vectors;
with DoblDobl_Complex_Series_Vectors_io; use DoblDobl_Complex_Series_Vectors_io;
with DoblDobl_Complex_Series_Matrices;
with DoblDobl_Complex_Vector_Series_io;  use DoblDobl_Complex_Vector_Series_io;
with DoblDobl_Complex_Matrix_Series;
with DoblDobl_Complex_Matrix_Series_io;  use DoblDobl_Complex_Matrix_Series_io;
with DoblDobl_Random_Series_Vectors;
with DoblDobl_Random_Series_Matrices;
with DoblDobl_Series_Matrix_Solvers;
with TripDobl_Complex_Series_Vectors;
with TripDobl_Complex_Series_Vectors_io; use TripDobl_Complex_Series_Vectors_io;
with TripDobl_Complex_Series_Matrices;
with TripDobl_Complex_Vector_Series_io;  use TripDobl_Complex_Vector_Series_io;
with TripDobl_Complex_Matrix_Series;
with TripDobl_Complex_Matrix_Series_io;  use TripDobl_Complex_Matrix_Series_io;
with TripDobl_Random_Series_Vectors;
with TripDobl_Random_Series_Matrices;
with TripDobl_Series_Matrix_Solvers;
with QuadDobl_Complex_Series_Vectors;
with QuadDobl_Complex_Series_Vectors_io; use QuadDobl_Complex_Series_Vectors_io;
with QuadDobl_Complex_Series_Matrices;
with QuadDobl_Complex_Vector_Series_io;  use QuadDobl_Complex_Vector_Series_io;
with QuadDobl_Complex_Matrix_Series;
with QuadDobl_Complex_Matrix_Series_io;  use QuadDobl_Complex_Matrix_Series_io;
with QuadDobl_Random_Series_Vectors;
with QuadDobl_Random_Series_Matrices;
with QuadDobl_Series_Matrix_Solvers;
with Series_Coefficient_Vectors;
with Evaluation_Differentiation_Errors;  use Evaluation_Differentiation_Errors;
with Standard_Speelpenning_Convolutions;
with DoblDobl_Speelpenning_Convolutions;
with TripDobl_Speelpenning_Convolutions;
with QuadDobl_Speelpenning_Convolutions;
with Multitasked_Series_Linearization;   use Multitasked_Series_Linearization;

package body Test_mtSeries_Linearization is

  function Error ( xs : Standard_Complex_Vector_Series.Vector;
                   bscff : Standard_Complex_VecVecs.VecVec;
                   output : boolean := true ) return double_float is

    err : double_float;

  begin
    if output then
      put_line("The generated leading vector series of the solution :");
      put_line(xs.cff(0));
      put_line("The computed leading vector series of the solution :");
      put_line(bscff(0));
    end if;
    err := Difference(xs.cff(0),bscff(0));
    for k in 1..xs.deg loop
      if output then
        put("The generated term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(xs.cff(k));
        put("The computed term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(bscff(k));
      end if;
      err := err + Difference(xs.cff(k),bscff(k));
    end loop;
    return err;
  end Error;

  function Error ( xs : DoblDobl_Complex_Vector_Series.Vector;
                   bscff : DoblDobl_Complex_VecVecs.VecVec;
                   output : boolean := true ) return double_double is

    err : double_double;

  begin
    if output then
      put_line("The generated leading vector series of the solution :");
      put_line(xs.cff(0));
      put_line("The computed leading vector series of the solution :");
      put_line(bscff(0));
    end if;
    err := Difference(xs.cff(0),bscff(0));
    for k in 1..xs.deg loop
      if output then
        put("The generated term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(xs.cff(k));
        put("The computed term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(bscff(k));
      end if;
      err := err + Difference(xs.cff(k),bscff(k));
    end loop;
    return err;
  end Error;

  function Error ( xs : TripDobl_Complex_Vector_Series.Vector;
                   bscff : TripDobl_Complex_VecVecs.VecVec;
                   output : boolean := true ) return triple_double is

    err : triple_double;

  begin
    if output then
      put_line("The generated leading vector series of the solution :");
      put_line(xs.cff(0));
      put_line("The computed leading vector series of the solution :");
      put_line(bscff(0));
    end if;
    err := Difference(xs.cff(0),bscff(0));
    for k in 1..xs.deg loop
      if output then
        put("The generated term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(xs.cff(k));
        put("The computed term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(bscff(k));
      end if;
      err := err + Difference(xs.cff(k),bscff(k));
    end loop;
    return err;
  end Error;

  function Error ( xs : QuadDobl_Complex_Vector_Series.Vector;
                   bscff : QuadDobl_Complex_VecVecs.VecVec;
                   output : boolean := true ) return quad_double is

    err : quad_double;

  begin
    if output then
      put_line("The generated leading vector series of the solution :");
      put_line(xs.cff(0));
      put_line("The computed leading vector series of the solution :");
      put_line(bscff(0));
    end if;
    err := Difference(xs.cff(0),bscff(0));
    for k in 1..xs.deg loop
      if output then
        put("The generated term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(xs.cff(k));
        put("The computed term "); put(k,1);
        put_line(" of the vector series of the solution :");
        put_line(bscff(k));
      end if;
      err := err + Difference(xs.cff(k),bscff(k));
    end loop;
    return err;
  end Error;

  function Compute_Speedup
             ( serial,multi : duration;
               verbose : boolean := false ) return duration is

    speedup : Duration := 0.0;
 
  begin
    if serial + 1.0 /= 1.0 then
      speedup := serial/multi;
      if verbose then
        put("The speedup : ");
        duration_io.put(speedup,1,3); new_line;
      end if;
    end if;
    return speedup;
  end Compute_Speedup;

  procedure Show_Speedup
              ( nbt : in integer32; serial,multi : in duration ) is

    speedup,efficiency : Duration;
 
  begin
    if serial + 1.0 /= 1.0 then
      speedup := serial/multi;
      put("The speedup : "); duration_io.put(speedup,1,3); new_line;
      efficiency := speedup/duration(nbt);
      efficiency := duration(100)*efficiency;
      put("  efficiency : "); duration_io.put(efficiency,2,2); new_line;
    end if;
  end Show_Speedup;

  procedure Standard_Run
              ( nbt,neq,nvr : in integer32;
                vm : in Standard_Complex_VecMats.VecMat;
                vb : in Standard_Complex_VecVecs.VecVec;
                xs : in Standard_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean ) is

    ans : character;
    err : double_float;
    ipvt : Standard_Integer_Vectors.Vector(1..nvr);
    info : integer32;
    wrk : constant Standard_Complex_Vectors.Link_to_Vector
        := new Standard_Complex_Vectors.Vector(1..neq);
    ewrk : constant Standard_Complex_Vectors.Link_to_Vector
         := new Standard_Complex_Vectors.Vector(1..neq);
    wks : constant Standard_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    deg : constant integer32 := vm'last;
    sol : constant Standard_Complex_VecVecs.VecVec(0..deg)
        := Standard_Speelpenning_Convolutions.Linearized_Allocation(nvr,deg);
    qraux,u1,u2,u3,u4,u5 : Standard_Complex_Vectors.Vector(1..neq);
    w1,w2,w3,w4,w5 : Standard_Complex_VecVecs.VecVec(1..nbt)
                   := Allocate_Work_Space(nbt,neq);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    rcond : double_float;
    mm : constant integer32
       := Standard_Complex_Singular_Values.Min0(neq,nvr);
    S : Standard_Complex_Vectors.Vector(1..mm);
    U,Ut : Standard_Complex_Matrices.Matrix(1..neq,1..neq);
    V : Standard_Complex_Matrices.Matrix(1..nvr,1..nvr);
    utb : constant Standard_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    sub : constant Standard_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,nvr);

    use Ada.Calendar;

  begin
    if nbt > 1 then
      multstart := Ada.Calendar.Clock;
      if neq > nvr then
        if usesvd then
          Multitasked_Solve_by_SVD
            (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
        else
          Multitasked_Solve_by_QRLS
           (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
        end if;
      else
        Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
      end if;
      multstop := Ada.Calendar.Clock;
      mltelp := multstop - multstart;
      put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
      Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
      Show_Speedup(nbt,serelp,mltelp);
    elsif nbt = 1 then
      put("Run multitasked code ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans = 'y' then
        multstart := Ada.Calendar.Clock;
        if neq > nvr then
          if usesvd then
            Multitasked_Solve_by_SVD
              (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
          else
            Multitasked_Solve_by_QRLS
              (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
          end if;
        else
          Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
        end if;
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        put_line("-> Elapsed time with one task :");
        Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        Show_Speedup(nbt,serelp,mltelp);
      else
        seristart := Ada.Calendar.Clock;
        if neq > nvr then
          Standard_Series_Matrix_Solvers.Solve_by_QRLS
            (vm,vb,sol,qraux,u1,u2,u3,u4,u5,ipvt,info,wrk);
        else
          Standard_Series_Matrix_Solvers.Solve_by_lufac(vm,vb,ipvt,info,wrk);
        end if;
        seristop := Ada.Calendar.Clock;
        serelp := seristop - seristart;
        put_line("-> Elapsed time without multitasking : ");
        Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
      end if;
    end if;
    put("info : "); put(info,1); new_line;
    if neq > nvr
     then err := Error(xs,sol,nbrotp);
     else err := Error(xs,vb,nbrotp);
    end if;
    put("Sum of errors :"); put(err,3); new_line;
  end Standard_Run;

  procedure DoblDobl_Run
              ( nbt,neq,nvr : in integer32;
                vm : in DoblDobl_Complex_VecMats.VecMat;
                vb : in DoblDobl_Complex_VecVecs.VecVec;
                xs : in DoblDobl_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean ) is

    ans : character;
    err : double_double;
    ipvt : Standard_Integer_Vectors.Vector(1..nvr);
    info : integer32;
    wrk : constant DoblDobl_Complex_Vectors.Link_to_Vector
        := new DoblDobl_Complex_Vectors.Vector(1..neq);
    ewrk : constant DoblDobl_Complex_Vectors.Link_to_Vector
         := new DoblDobl_Complex_Vectors.Vector(1..neq);
    wks : constant DoblDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    deg : constant integer32 := vm'last;
    sol : constant DoblDobl_Complex_VecVecs.VecVec(0..deg)
        := DoblDobl_Speelpenning_Convolutions.Linearized_Allocation(nvr,deg);
    qraux,u1,u2,u3,u4,u5 : DoblDobl_Complex_Vectors.Vector(1..neq);
    w1,w2,w3,w4,w5 : DoblDobl_Complex_VecVecs.VecVec(1..nbt)
                   := Allocate_Work_Space(nbt,neq);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    rcond : double_double;
    mm : constant integer32
       := DoblDobl_Complex_Singular_Values.Min0(neq,nvr);
    S : DoblDobl_Complex_Vectors.Vector(1..mm);
    U,Ut : DoblDobl_Complex_Matrices.Matrix(1..neq,1..neq);
    V : DoblDobl_Complex_Matrices.Matrix(1..nvr,1..nvr);
    utb : constant DoblDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    sub : constant DoblDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,nvr);

    use Ada.Calendar;

  begin
    if nbt > 1 then
      multstart := Ada.Calendar.Clock;
      if neq > nvr then
        if usesvd then
          Multitasked_Solve_by_SVD
            (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
        else
          Multitasked_Solve_by_QRLS
            (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
        end if;
      else
        Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
      end if;
      multstop := Ada.Calendar.Clock;
      mltelp := multstop - multstart;
      put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
      Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
      Show_Speedup(nbt,serelp,mltelp);
    elsif nbt = 1 then
      put("Run multitasked code ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans = 'y' then
        multstart := Ada.Calendar.Clock;
        if neq > nvr then
          if usesvd then
            Multitasked_Solve_by_SVD
              (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
          else
            Multitasked_Solve_by_QRLS
              (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
          end if;
        else
          Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
        end if;
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        put_line("-> Elapsed time with one task :");
        Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        Show_Speedup(nbt,serelp,mltelp);
      else
        seristart := Ada.Calendar.Clock;
        if neq > nvr then
          DoblDobl_Series_Matrix_Solvers.Solve_by_QRLS
            (vm,vb,sol,qraux,u1,u2,u3,u4,u5,ipvt,info,wrk);
        else
          DoblDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,vb,ipvt,info,wrk);
        end if;
        seristop := Ada.Calendar.Clock;
        serelp := seristop - seristart;
        put_line("-> Elapsed time without multitasking : ");
        Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
      end if;
    end if;
    put("info : "); put(info,1); new_line;
    if neq > nvr
     then err := Error(xs,sol,nbrotp);
     else err := Error(xs,vb,nbrotp);
    end if;
    put("Sum of errors : "); put(err,3); new_line;
  end DoblDobl_Run;

  procedure TripDobl_Run
              ( nbt,neq,nvr : in integer32;
                vm : in TripDobl_Complex_VecMats.VecMat;
                vb : in TripDobl_Complex_VecVecs.VecVec;
                xs : in TripDobl_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean ) is

    ans : character;
    err : triple_double;
    ipvt : Standard_Integer_Vectors.Vector(1..nvr);
    info : integer32;
    wrk : constant TripDobl_Complex_Vectors.Link_to_Vector
        := new TripDobl_Complex_Vectors.Vector(1..neq);
    ewrk : constant TripDobl_Complex_Vectors.Link_to_Vector
         := new TripDobl_Complex_Vectors.Vector(1..neq);
    wks : constant TripDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    deg : constant integer32 := vm'last;
    sol : constant TripDobl_Complex_VecVecs.VecVec(0..deg)
        := TripDobl_Speelpenning_Convolutions.Linearized_Allocation(nvr,deg);
    qraux,u1,u2,u3,u4,u5 : TripDobl_Complex_Vectors.Vector(1..neq);
    w1,w2,w3,w4,w5 : TripDobl_Complex_VecVecs.VecVec(1..nbt)
                   := Allocate_Work_Space(nbt,neq);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    rcond : triple_double;
    mm : constant integer32
       := TripDobl_Complex_Singular_Values.Min0(neq,nvr);
    S : TripDobl_Complex_Vectors.Vector(1..mm);
    U,Ut : TripDobl_Complex_Matrices.Matrix(1..neq,1..neq);
    V : TripDobl_Complex_Matrices.Matrix(1..nvr,1..nvr);
    utb : constant TripDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    sub : constant TripDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,nvr);

    use Ada.Calendar;

  begin
    if nbt > 1 then
      multstart := Ada.Calendar.Clock;
      if neq > nvr then
        if usesvd then
          Multitasked_Solve_by_SVD
            (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
        else
          Multitasked_Solve_by_QRLS
            (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
        end if;
      else
        Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
      end if;
      multstop := Ada.Calendar.Clock;
      mltelp := multstop - multstart;
      put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
      Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
      Show_Speedup(nbt,serelp,mltelp);
    elsif nbt = 1 then
      put("Run multitasked code ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans = 'y' then
        multstart := Ada.Calendar.Clock;
        if neq > nvr then
          if usesvd then
            Multitasked_Solve_by_SVD
              (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
          else
            Multitasked_Solve_by_QRLS
              (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
          end if;
        else
          Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
        end if;
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        put_line("-> Elapsed time with one task :");
        Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        Show_Speedup(nbt,serelp,mltelp);
      else
        seristart := Ada.Calendar.Clock;
        if neq > nvr then
          TripDobl_Series_Matrix_Solvers.Solve_by_QRLS
            (vm,vb,sol,qraux,u1,u2,u3,u4,u5,ipvt,info,wrk);
        else
          TripDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,vb,ipvt,info,wrk);
        end if;
        seristop := Ada.Calendar.Clock;
        serelp := seristop - seristart;
        put_line("-> Elapsed time without multitasking : ");
        Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
      end if;
    end if;
    put("info : "); put(info,1); new_line;
    if neq > nvr
     then err := Error(xs,sol,nbrotp);
     else err := Error(xs,vb,nbrotp);
    end if;
    put("Sum of errors : "); put(err,3); new_line;
  end TripDobl_Run;

  procedure QuadDobl_Run
              ( nbt,neq,nvr : in integer32;
                vm : in QuadDobl_Complex_VecMats.VecMat;
                vb : in QuadDobl_Complex_VecVecs.VecVec;
                xs : in QuadDobl_Complex_Vector_Series.Vector;
                mltelp,serelp : in out Duration;
                output,nbrotp,usesvd : in boolean ) is

    ans : character;
    err : quad_double;
    ipvt : Standard_Integer_Vectors.Vector(1..neq);
    info : integer32;
    wrk : constant QuadDobl_Complex_Vectors.Link_to_Vector
        := new QuadDobl_Complex_Vectors.Vector(1..neq);
    wks : constant QuadDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    ewrk : constant QuadDobl_Complex_Vectors.Link_to_Vector
         := new QuadDobl_Complex_Vectors.Vector(1..neq);
    deg : constant integer32 := vm'last;
    sol : constant QuadDobl_Complex_VecVecs.VecVec(0..deg)
        := QuadDobl_Speelpenning_Convolutions.Linearized_Allocation(nvr,deg);
    qraux,u1,u2,u3,u4,u5 : QuadDobl_Complex_Vectors.Vector(1..neq);
    w1,w2,w3,w4,w5 : QuadDobl_Complex_VecVecs.VecVec(1..nbt)
                   := Allocate_Work_Space(nbt,neq);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    rcond : quad_double;
    mm : constant integer32
       := QuadDobl_Complex_Singular_Values.Min0(neq,nvr);
    S : QuadDobl_Complex_Vectors.Vector(1..mm);
    U,Ut : QuadDobl_Complex_Matrices.Matrix(1..neq,1..neq);
    V : QuadDobl_Complex_Matrices.Matrix(1..nvr,1..nvr);
    utb : constant QuadDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,neq);
    sub : constant QuadDobl_Complex_VecVecs.VecVec(1..nbt)
        := Allocate_Work_Space(nbt,nvr);

    use Ada.Calendar;

  begin
    if nbt > 1 then
      multstart := Ada.Calendar.Clock;
      if neq > nvr then
        if usesvd then
          Multitasked_Solve_by_SVD
            (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
        else
          Multitasked_Solve_by_QRLS
            (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
        end if;
      else
        Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
      end if;
      multstop := Ada.Calendar.Clock;
      mltelp := multstop - multstart;
      put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
      Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
      Show_Speedup(nbt,serelp,mltelp);
    elsif nbt = 1 then
      put("Run multitasked code ? (y/n) ");
      Ask_Yes_or_No(ans);
      if ans = 'y' then
        multstart := Ada.Calendar.Clock;
        if neq > nvr then
          if usesvd then
            Multitasked_Solve_by_SVD
              (nbt,vm,vb,sol,S,U,Ut,V,info,rcond,ewrk,wks,utb,sub,output);
          else
            Multitasked_Solve_by_QRLS
              (nbt,vm,vb,sol,qraux,w1,w2,w3,w4,w5,ipvt,info,wks,output);
          end if;
        else
          Multitasked_Solve_by_lufac(nbt,vm,vb,ipvt,info,wks,output);
        end if;
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        put_line("-> Elapsed time with one task :");
        Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        Show_Speedup(nbt,serelp,mltelp);
      else
        seristart := Ada.Calendar.Clock;
        if neq > nvr then
          QuadDobl_Series_Matrix_Solvers.Solve_by_QRLS
            (vm,vb,sol,qraux,u1,u2,u3,u4,u5,ipvt,info,wrk);
        else
          QuadDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,vb,ipvt,info,wrk);
        end if;
        seristop := Ada.Calendar.Clock;
        serelp := seristop - seristart;
        put_line("-> Elapsed time without multitasking : ");
        Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
      end if;
    end if;
    put("info : "); put(info,1); new_line;
    if neq > nvr
     then err := Error(xs,sol,nbrotp);
     else err := Error(xs,vb,nbrotp);
    end if;
    put("Sum of errors : "); put(err,3); new_line;
  end QuadDobl_Run;

  procedure Prompt_for_Flags
              ( neq,nvr : in integer32; 
                nbrotp,otp,usesvd : out boolean ) is

    ans : character;

  begin
    put("Output of numbers ? (y/n) "); Ask_Yes_or_No(ans);
    nbrotp := (ans = 'y');
    put("Output during multitasking ? (y/n) "); Ask_Yes_or_No(ans);
    otp := (ans = 'y');
    if neq > nvr then
      put("Use singular value decomposition ? (y/n) "); Ask_Yes_or_No(ans);
      usesvd := (ans = 'y');
    else
      usesvd := false;
    end if;
  end Prompt_for_Flags;

  procedure Standard_Test ( m,n,d : in integer32 ) is

    use Standard_Complex_Series_Matrices; -- for the sA*sx operation

    nbt : integer32 := 0;
    sA : constant Standard_Complex_Series_Matrices.Matrix(1..m,1..n)
       := Standard_Random_Series_Matrices.Random_Series_Matrix(1,m,1,n,d);
    As : constant Standard_Complex_Matrix_Series.Matrix 
       := Standard_Complex_Matrix_Series.Create(sA); 
    vmbackup : constant Standard_Complex_VecMats.VecMat(0..As.deg)
             := Series_Coefficient_Vectors.Standard_Series_Coefficients(As);
    vm : Standard_Complex_VecMats.VecMat(vmbackup'range);
    sx : constant Standard_Complex_Series_Vectors.Vector(1..n)
       := Standard_Random_Series_Vectors.Random_Series_Vector(1,n,d);
    xs : constant Standard_Complex_Vector_Series.Vector(d)
       := Standard_Complex_Vector_Series.Create(sx);
    sb : constant Standard_Complex_Series_Vectors.Vector(1..m) := sA*sx;
    bs : constant Standard_Complex_Vector_Series.Vector(d)
       := Standard_Complex_Vector_Series.Create(sb);
    sbcff : constant Standard_Complex_VecVecs.VecVec(1..m)
          := Series_Coefficient_Vectors.Standard_Series_Coefficients(sb);
    bscff : constant Standard_Complex_VecVecs.VecVec(0..bs.deg)
          := Series_Coefficient_Vectors.Standard_Series_Coefficients(bs);
    bswrk : Standard_Complex_VecVecs.VecVec(bscff'range);
    nbrotp,otp,usesvd : boolean;
    mult_elapsed,seri_elapsed : Duration := 0.0;

  begin
    Prompt_for_Flags(m,n,nbrotp,otp,usesvd);
    if nbrotp then
      put_line("The coefficients of the matrix series :"); put(As);
      put_line("The coefficient matrices : "); put(vmbackup);
      put_line("The exact solution x :"); put_line(sx);
      put_line("The coefficients of the vector series x :"); put(xs);
      put_line("The right hand side vector b :"); put_line(sb);
      put_line("The coefficients of b : "); put_line(sbcff);
      put_line("The coefficients of the vector series b :"); put(bs);
      put_line("The coefficients of the vector series b :"); put_line(bscff);
    end if;
    loop
      new_line;
      put("Give the number of tasks (0 to exit) : "); get(nbt);
      exit when (nbt = 0);
      Standard_Complex_VecMats.Copy(vmbackup,vm);
      Standard_Complex_VecVecs.Copy(bscff,bswrk);
      Standard_Run
        (nbt,m,n,vm,bswrk,xs,mult_elapsed,seri_elapsed,otp,nbrotp,usesvd);
    end loop;
  end Standard_Test;

  procedure DoblDobl_Test ( m,n,d : in integer32 ) is

    use DoblDobl_Complex_Series_Matrices; -- for the sA*sx operation

    nbt : integer32 := 0;
    sA : constant DoblDobl_Complex_Series_Matrices.Matrix(1..m,1..n)
       := DoblDobl_Random_Series_Matrices.Random_Series_Matrix(1,m,1,n,d);
    As : constant DoblDobl_Complex_Matrix_Series.Matrix 
       := DoblDobl_Complex_Matrix_Series.Create(sA); 
    vmbackup : constant DoblDobl_Complex_VecMats.VecMat(0..As.deg)
             := Series_Coefficient_Vectors.DoblDobl_Series_Coefficients(As);
    vm : DoblDobl_Complex_VecMats.VecMat(vmbackup'range);
    sx : constant DoblDobl_Complex_Series_Vectors.Vector(1..n)
       := DoblDobl_Random_Series_Vectors.Random_Series_Vector(1,n,d);
    xs : constant DoblDobl_Complex_Vector_Series.Vector(d)
       := DoblDobl_Complex_Vector_Series.Create(sx);
    sb : constant DoblDobl_Complex_Series_Vectors.Vector(1..m) := sA*sx;
    bs : constant DoblDobl_Complex_Vector_Series.Vector(d)
       := DoblDobl_Complex_Vector_Series.Create(sb);
    sbcff : constant DoblDobl_Complex_VecVecs.VecVec(1..m)
          := Series_Coefficient_Vectors.DoblDobl_Series_Coefficients(sb);
    bscff : constant DoblDobl_Complex_VecVecs.VecVec(0..bs.deg)
          := Series_Coefficient_Vectors.DoblDobl_Series_Coefficients(bs);
    bswrk : DoblDobl_Complex_VecVecs.VecVec(bscff'range);
    nbrotp,otp,usesvd : boolean;
    mult_elapsed,seri_elapsed : Duration := 0.0;

  begin
    Prompt_for_Flags(m,n,nbrotp,otp,usesvd);
    if nbrotp then
      put_line("The coefficients of the matrix series :"); put(As);
      put_line("The coefficient matrices : "); put(vmbackup);
      put_line("The exact solution x :"); put_line(sx);
      put_line("The coefficients of the vector series x :"); put(xs);
      put_line("The right hand side vector b :"); put_line(sb);
      put_line("The coefficients of b : "); put_line(sbcff);
      put_line("The coefficients of the vector series b :"); put(bs);
      put_line("The coefficients of the vector series b :"); put_line(bscff);
    end if;
    loop
      new_line;
      put("Give the number of tasks (0 to exit) : "); get(nbt);
      exit when (nbt = 0);
      DoblDobl_Complex_VecMats.Copy(vmbackup,vm);
      DoblDobl_Complex_VecVecs.Copy(bscff,bswrk);
      DoblDobl_Run
        (nbt,m,n,vm,bswrk,xs,mult_elapsed,seri_elapsed,otp,nbrotp,usesvd);
    end loop;
  end DoblDobl_Test;

  procedure TripDobl_Test ( m,n,d : in integer32 ) is

    use TripDobl_Complex_Series_Matrices; -- for the sA*sx operation

    nbt : integer32 := 0;
    sA : constant TripDobl_Complex_Series_Matrices.Matrix(1..m,1..n)
       := TripDobl_Random_Series_Matrices.Random_Series_Matrix(1,m,1,n,d);
    As : constant TripDobl_Complex_Matrix_Series.Matrix 
       := TripDobl_Complex_Matrix_Series.Create(sA); 
    vmbackup : constant TripDobl_Complex_VecMats.VecMat(0..As.deg)
             := Series_Coefficient_Vectors.TripDobl_Series_Coefficients(As);
    vm : TripDobl_Complex_VecMats.VecMat(vmbackup'range);
    sx : constant TripDobl_Complex_Series_Vectors.Vector(1..n)
       := TripDobl_Random_Series_Vectors.Random_Series_Vector(1,n,d);
    xs : constant TripDobl_Complex_Vector_Series.Vector(d)
       := TripDobl_Complex_Vector_Series.Create(sx);
    sb : constant TripDobl_Complex_Series_Vectors.Vector(1..m) := sA*sx;
    bs : constant TripDobl_Complex_Vector_Series.Vector(d)
       := TripDobl_Complex_Vector_Series.Create(sb);
    sbcff : constant TripDobl_Complex_VecVecs.VecVec(1..m)
          := Series_Coefficient_Vectors.TripDobl_Series_Coefficients(sb);
    bscff : constant TripDobl_Complex_VecVecs.VecVec(0..bs.deg)
          := Series_Coefficient_Vectors.TripDobl_Series_Coefficients(bs);
    bswrk : TripDobl_Complex_VecVecs.VecVec(bscff'range);
    nbrotp,otp,usesvd : boolean;
    mult_elapsed,seri_elapsed : Duration := 0.0;

  begin
    Prompt_for_Flags(m,n,nbrotp,otp,usesvd);
    if nbrotp then
      put_line("The coefficients of the matrix series :"); put(As);
      put_line("The coefficient matrices : "); put(vmbackup);
      put_line("The exact solution x :"); put_line(sx);
      put_line("The coefficients of the vector series x :"); put(xs);
      put_line("The right hand side vector b :"); put_line(sb);
      put_line("The coefficients of b : "); put_line(sbcff);
      put_line("The coefficients of the vector series b :"); put(bs);
      put_line("The coefficients of the vector series b :"); put_line(bscff);
    end if;
    loop
      new_line;
      put("Give the number of tasks (0 to exit) : "); get(nbt);
      exit when (nbt = 0);
      TripDobl_Complex_VecMats.Copy(vmbackup,vm);
      TripDobl_Complex_VecVecs.Copy(bscff,bswrk);
      TripDobl_Run
        (nbt,m,n,vm,bswrk,xs,mult_elapsed,seri_elapsed,otp,nbrotp,usesvd);
    end loop;
  end TripDobl_Test;

  procedure QuadDobl_Test ( m,n,d : in integer32 ) is

    use QuadDobl_Complex_Series_Matrices; -- for the sA*sx operation

    nbt : integer32 := 0;
    sA : constant QuadDobl_Complex_Series_Matrices.Matrix(1..m,1..n)
       := QuadDobl_Random_Series_Matrices.Random_Series_Matrix(1,m,1,n,d);
    As : constant QuadDobl_Complex_Matrix_Series.Matrix 
       := QuadDobl_Complex_Matrix_Series.Create(sA); 
    vmbackup : constant QuadDobl_Complex_VecMats.VecMat(0..As.deg)
             := Series_Coefficient_Vectors.QuadDobl_Series_Coefficients(As);
    vm : QuadDobl_Complex_VecMats.VecMat(vmbackup'range);
    sx : constant QuadDobl_Complex_Series_Vectors.Vector(1..n)
       := QuadDobl_Random_Series_Vectors.Random_Series_Vector(1,n,d);
    xs : constant QuadDobl_Complex_Vector_Series.Vector(d)
       := QuadDobl_Complex_Vector_Series.Create(sx);
    sb : constant QuadDobl_Complex_Series_Vectors.Vector(1..m) := sA*sx;
    bs : constant QuadDobl_Complex_Vector_Series.Vector(d)
       := QuadDobl_Complex_Vector_Series.Create(sb);
    sbcff : constant QuadDobl_Complex_VecVecs.VecVec(1..m)
          := Series_Coefficient_Vectors.QuadDobl_Series_Coefficients(sb);
    bscff : constant QuadDobl_Complex_VecVecs.VecVec(0..bs.deg)
          := Series_Coefficient_Vectors.QuadDobl_Series_Coefficients(bs);
    bswrk : QuadDobl_Complex_VecVecs.VecVec(bscff'range);
    nbrotp,otp,usesvd : boolean;
    seri_elapsed,mult_elapsed : Duration := 0.0;

  begin
    Prompt_for_Flags(m,n,nbrotp,otp,usesvd);
    if nbrotp then
      put_line("The coefficients of the matrix series :"); put(As);
      put_line("The coefficient matrices : "); put(vmbackup);
      put_line("The exact solution x :"); put_line(sx);
      put_line("The coefficients of the vector series x :"); put(xs);
      put_line("The right hand side vector b :"); put_line(sb);
      put_line("The coefficients of b : "); put_line(sbcff);
      put_line("The coefficients of the vector series b :"); put(bs);
      put_line("The coefficients of the vector series b :"); put_line(bscff);
    end if;
    loop
      new_line;
      put("Give the number of tasks (0 to exit) : "); get(nbt);
      exit when (nbt = 0);
      QuadDobl_Complex_VecMats.Copy(vmbackup,vm);
      QuadDobl_Complex_VecVecs.Copy(bscff,bswrk);
      QuadDobl_Run
        (nbt,m,n,vm,bswrk,xs,mult_elapsed,seri_elapsed,otp,nbrotp,usesvd);
    end loop;
  end QuadDobl_Test;

  procedure Standard_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in Standard_Complex_VecMats.VecMat;
                b : in Standard_Complex_VecVecs.VecVec;
		verbose : in boolean := false ) is

    ipvt : Standard_Integer_Vectors.Vector(1..n);
    info : integer32;
    wrk : constant Standard_Complex_Vectors.Link_to_Vector
        := new Standard_Complex_Vectors.Vector(1..n);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    serelp,mltelp,speedup,efficiency : duration;
    nbt : integer32 := 2;
    vm : Standard_Complex_VecMats.VecMat(A'range);
    bw : Standard_Complex_VecVecs.VecVec(b'range);

    use Ada.Calendar;

  begin
    put_line(file,"double precision");
    Standard_Complex_VecMats.Copy(A,vm);
    Standard_Complex_VecVecs.Copy(b,bw);
    seristart := Ada.Calendar.Clock;
    Standard_Series_Matrix_Solvers.Solve_by_lufac(vm,bw,ipvt,info,wrk);
    seristop := Ada.Calendar.Clock;
    serelp := seristop - seristart;
    put(file,"  1 : "); duration_io.put(file,serelp,1,3); new_line(file);
    flush(file);
    if verbose then
      put_line("-> Elapsed time without multitasking : ");
      Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
    end if;
    for k in 1..nbruns loop
      declare
        wks : Standard_Complex_VecVecs.VecVec(1..nbt)
            := Allocate_Work_Space(nbt,n);
      begin
        Standard_Complex_VecMats.Copy(A,vm);
        Standard_Complex_VecVecs.Copy(b,bw);
        multstart := Ada.Calendar.Clock;
        Multitasked_Solve_by_lufac(nbt,vm,bw,ipvt,info,wks,false);
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        if verbose then
          put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
          Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        end if;
	speedup := Compute_Speedup(serelp,mltelp,verbose);
        put(file,nbt,3);
        put(file," : "); duration_io.put(file,mltelp,1,3);
        put(file," : "); duration_io.put(file,speedup,1,3);
        efficiency := speedup/duration(nbt);
        efficiency := duration(100)*efficiency;
        put(file," : "); duration_io.put(file,efficiency,2,2);
        new_line(file); flush(file);
        Standard_Complex_VecVecs.Clear(wks);
        nbt := nbt + inc;
      end;
    end loop;
  end Standard_Benchmark;

  procedure DoblDobl_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in DoblDobl_Complex_VecMats.VecMat;
                b : in DoblDobl_Complex_VecVecs.VecVec;
                verbose : in boolean := false ) is

    ipvt : Standard_Integer_Vectors.Vector(1..n);
    info : integer32;
    wrk : constant DoblDobl_Complex_Vectors.Link_to_Vector
        := new DoblDobl_Complex_Vectors.Vector(1..n);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    serelp,mltelp,speedup,efficiency : duration;
    vm : DoblDobl_Complex_VecMats.VecMat(A'range);
    bw : DoblDobl_Complex_VecVecs.VecVec(b'range);
    nbt : integer32 := 2;

    use Ada.Calendar;

  begin
    put_line(file,"double double precision");
    DoblDobl_Complex_VecMats.Copy(A,vm);
    DoblDobl_Complex_VecVecs.Copy(b,bw);
    seristart := Ada.Calendar.Clock;
    DoblDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,bw,ipvt,info,wrk);
    seristop := Ada.Calendar.Clock;
    serelp := seristop - seristart;
    put(file,"  1 : "); duration_io.put(file,serelp,1,3); new_line(file);
    flush(file);
    if verbose then
      put_line("-> Elapsed time without multitasking : ");
      Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
    end if;
    for k in 1..nbruns loop
      declare
        wks : DoblDobl_Complex_VecVecs.VecVec(1..nbt)
            := Allocate_Work_Space(nbt,n);
      begin
        DoblDobl_Complex_VecMats.Copy(A,vm);
        DoblDobl_Complex_VecVecs.Copy(b,bw);
        multstart := Ada.Calendar.Clock;
        Multitasked_Solve_by_lufac(nbt,vm,bw,ipvt,info,wks,false);
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        if verbose then
          put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
          Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        end if;
	speedup := Compute_Speedup(serelp,mltelp,verbose);
        put(file,nbt,3);
        put(file," : "); duration_io.put(file,mltelp,1,3);
        put(file," : "); duration_io.put(file,speedup,1,3);
        efficiency := speedup/duration(nbt);
        efficiency := duration(100)*efficiency;
        put(file," : "); duration_io.put(file,efficiency,2,2);
        new_line(file); flush(file);
        DoblDobl_Complex_VecVecs.Clear(wks);
        nbt := nbt + inc;
      end;
    end loop;
  end DoblDobl_Benchmark;

  procedure TripDobl_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in TripDobl_Complex_VecMats.VecMat;
                b : in TripDobl_Complex_VecVecs.VecVec;
                verbose : in boolean := false ) is

    ipvt : Standard_Integer_Vectors.Vector(1..n);
    info : integer32;
    wrk : constant TripDobl_Complex_Vectors.Link_to_Vector
        := new TripDobl_Complex_Vectors.Vector(1..n);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    serelp,mltelp,speedup,efficiency : duration;
    vm : TripDobl_Complex_VecMats.VecMat(A'range);
    bw : TripDobl_Complex_VecVecs.VecVec(b'range);
    nbt : integer32 := 2;

    use Ada.Calendar;

  begin
    put_line(file,"double double precision");
    TripDobl_Complex_VecMats.Copy(A,vm);
    TripDobl_Complex_VecVecs.Copy(b,bw);
    seristart := Ada.Calendar.Clock;
    TripDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,bw,ipvt,info,wrk);
    seristop := Ada.Calendar.Clock;
    serelp := seristop - seristart;
    put(file,"  1 : "); duration_io.put(file,serelp,1,3); new_line(file);
    flush(file);
    if verbose then
      put_line("-> Elapsed time without multitasking : ");
      Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
    end if;
    for k in 1..nbruns loop
      declare
        wks : TripDobl_Complex_VecVecs.VecVec(1..nbt)
            := Allocate_Work_Space(nbt,n);
      begin
        TripDobl_Complex_VecMats.Copy(A,vm);
        TripDobl_Complex_VecVecs.Copy(b,bw);
        multstart := Ada.Calendar.Clock;
        Multitasked_Solve_by_lufac(nbt,vm,bw,ipvt,info,wks,false);
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        if verbose then
          put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
          Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        end if;
	speedup := Compute_Speedup(serelp,mltelp,verbose);
        put(file,nbt,3);
        put(file," : "); duration_io.put(file,mltelp,1,3);
        put(file," : "); duration_io.put(file,speedup,1,3);
        efficiency := speedup/duration(nbt);
        efficiency := duration(100)*efficiency;
        put(file," : "); duration_io.put(file,efficiency,2,2);
        new_line(file); flush(file);
        TripDobl_Complex_VecVecs.Clear(wks);
        nbt := nbt + inc;
      end;
    end loop;
  end TripDobl_Benchmark;

  procedure QuadDobl_Benchmark
              ( file : in file_type; n,nbruns,inc : in integer32;
                A : in QuadDobl_Complex_VecMats.VecMat;
                b : in QuadDobl_Complex_VecVecs.VecVec;
                verbose : in boolean := false ) is

    ipvt : Standard_Integer_Vectors.Vector(1..n);
    info : integer32;
    wrk : constant QuadDobl_Complex_Vectors.Link_to_Vector
        := new QuadDobl_Complex_Vectors.Vector(1..n);
    multstart,multstop,seristart,seristop : Ada.Calendar.Time;
    serelp,mltelp,speedup,efficiency : duration;
    vm : QuadDobl_Complex_VecMats.VecMat(A'range);
    bw : QuadDobl_Complex_VecVecs.VecVec(b'range);
    nbt : integer32 := 2;

    use Ada.Calendar;

  begin
    put_line(file,"quad double precision");
    QuadDobl_Complex_VecMats.Copy(A,vm);
    QuadDobl_Complex_VecVecs.Copy(b,bw);
    seristart := Ada.Calendar.Clock;
    QuadDobl_Series_Matrix_Solvers.Solve_by_lufac(vm,bw,ipvt,info,wrk);
    seristop := Ada.Calendar.Clock;
    serelp := seristop - seristart;
    put(file,"  1 : "); duration_io.put(file,serelp,1,3); new_line(file);
    if verbose then
      put_line("-> Elapsed time without multitasking : ");
      Time_Stamps.Write_Elapsed_Time(standard_output,seristart,seristop);
    end if;
    for k in 1..nbruns loop
      declare
        wks : QuadDobl_Complex_VecVecs.VecVec(1..nbt)
            := Allocate_Work_Space(nbt,n);
      begin
        QuadDobl_Complex_VecMats.Copy(A,vm);
        QuadDobl_Complex_VecVecs.Copy(b,bw);
        multstart := Ada.Calendar.Clock;
        Multitasked_Solve_by_lufac(nbt,vm,bw,ipvt,info,wks,false);
        multstop := Ada.Calendar.Clock;
        mltelp := multstop - multstart;
        if verbose then
          put("-> Elapsed time with "); put(nbt,1); put_line(" tasks :");
          Time_Stamps.Write_Elapsed_Time(standard_output,multstart,multstop);
        end if;
	speedup := Compute_Speedup(serelp,mltelp,verbose);
        put(file,nbt,3);
        put(file," : "); duration_io.put(file,mltelp,1,3);
        put(file," : "); duration_io.put(file,speedup,1,3);
        efficiency := speedup/duration(nbt);
        efficiency := duration(100)*efficiency;
        put(file," : "); duration_io.put(file,efficiency,2,2);
        new_line(file); flush(file);
        QuadDobl_Complex_VecVecs.Clear(wks);
        nbt := nbt + inc;
      end;
    end loop;
  end QuadDobl_Benchmark;

  procedure Benchmark ( n,d : in integer32 ) is

    use QuadDobl_Complex_Series_Matrices; -- for the sA*sx operation

    sA : constant QuadDobl_Complex_Series_Matrices.Matrix(1..n,1..n)
       := QuadDobl_Random_Series_Matrices.Random_Series_Matrix(1,n,1,n,d);
    As : constant QuadDobl_Complex_Matrix_Series.Matrix 
       := QuadDobl_Complex_Matrix_Series.Create(sA); 
    qd_vm : constant QuadDobl_Complex_VecMats.VecMat(0..As.deg)
          := Series_Coefficient_Vectors.QuadDobl_Series_Coefficients(As);
    td_vm : constant TripDobl_Complex_VecMats.VecMat(0..As.deg)
          := QuadDobl_Complex_Matrices_cv.to_triple_double(qd_vm);
    dd_vm : constant DoblDobl_Complex_VecMats.VecMat(qd_vm'range)
          := QuadDobl_Complex_Matrices_cv.to_double_double(qd_vm);
    d_vm : constant Standard_Complex_VecMats.VecMat(qd_vm'range)
         := QuadDobl_Complex_Matrices_cv.to_double(qd_vm);
    sx : constant QuadDobl_Complex_Series_Vectors.Vector(1..n)
       := QuadDobl_Random_Series_Vectors.Random_Series_Vector(1,n,d);
    sb : constant QuadDobl_Complex_Series_Vectors.Vector(1..n) := sA*sx;
    bs : constant QuadDobl_Complex_Vector_Series.Vector(d)
       := QuadDobl_Complex_Vector_Series.Create(sb);
    qd_bscff : constant QuadDobl_Complex_VecVecs.VecVec(0..bs.deg)
             := Series_Coefficient_Vectors.QuadDobl_Series_Coefficients(bs);
    td_bscff : constant TripDobl_Complex_VecVecs.VecVec(0..bs.deg)
             := QuadDobl_Complex_Vectors_cv.to_triple_double(qd_bscff);
    dd_bscff : constant DoblDobl_Complex_VecVecs.VecVec(0..bs.deg)
             := QuadDobl_Complex_Vectors_cv.to_double_double(qd_bscff);
    d_bscff : constant Standard_Complex_VecVecs.VecVec(0..bs.deg)
            := QuadDobl_Complex_Vectors_cv.to_double(qd_bscff);
    nbruns,inc : integer32 := 0;
    file : file_type;

  begin
    new_line;
    put("Give the number of multitasked runs : "); get(nbruns);
    put("Give the increment on the tasks : "); get(inc);
    skip_line;
    new_line;
    put_line("Reading the name of the output file ...");
    Read_Name_and_Create_File(file);
    new_line;
    put_line("See the output file for results ...");
    new_line;
    put(file,"dimension : "); put(file,n,1);
    put(file,"  degree : "); put(file,d,1); new_line(file);
    Standard_Benchmark(file,n,nbruns,inc,d_vm,d_bscff);
    DoblDobl_Benchmark(file,n,nbruns,inc,dd_vm,dd_bscff);
    TripDobl_Benchmark(file,n,nbruns,inc,td_vm,td_bscff);
    QuadDobl_Benchmark(file,n,nbruns,inc,qd_vm,qd_bscff);
  end Benchmark;

  procedure Main is

    neq,nvr,deg : integer32 := 0;
    ans : character;

  begin
    new_line;
    put_line("Testing the linearization of systems of power series ...");
    put("  Give the number of equations : "); get(neq);
    put("  Give the number of variables : "); get(nvr);
    put("  Give the degree of the series : "); get(deg);
    new_line;
    put("Benchmarking for all precisions ? (y/n) "); Ask_Yes_or_No(ans);
    if ans = 'y' then
      Benchmark(nvr,deg);
    else
      new_line;
      put_line("MENU for the working precision :");
      put_line("  1. double precision");
      put_line("  2. double double precision");
      put_line("  3. triple double precision");
      put_line("  4. quad double precision");
      put("Type 1, 2, 3, or 4 to select the precision : ");
      Ask_Alternative(ans,"1234");
      new_line;
      case ans is
        when '1' => Standard_Test(neq,nvr,deg);
        when '2' => DoblDobl_Test(neq,nvr,deg);
        when '3' => TripDobl_Test(neq,nvr,deg);
        when '4' => QuadDobl_Test(neq,nvr,deg);
        when others => null;
      end case;
    end if;
  end Main;

end Test_mtSeries_Linearization;
