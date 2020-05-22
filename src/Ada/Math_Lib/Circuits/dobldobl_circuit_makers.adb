with text_io;                             use text_io;
with Standard_Natural_Numbers;            use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;         use Standard_Integer_Numbers_io;
with Double_Double_Numbers;               use Double_Double_Numbers;
with DoblDobl_Complex_Numbers_io;         use DoblDobl_Complex_Numbers_io;
with Standard_Random_Numbers;
with DoblDobl_Random_Numbers;
with Standard_Natural_Vectors;
with Standard_Integer_Vectors_io;         use Standard_Integer_Vectors_io;
with Standard_Random_Vectors;
with DoblDobl_Random_Vectors;
with QuadDobl_Complex_Numbers_cv;
with QuadDobl_Complex_Vectors_cv;
with DoblDobl_Complex_Poly_Functions;
with Exponent_Indices;

package body DoblDobl_Circuit_Makers is

  function Random_Indices
             ( dim : integer32 )
             return Standard_Integer_Vectors.Vector is

    res : Standard_Integer_Vectors.Vector(1..dim);
    cnt : integer32 := 0;
    rnd : integer32;

  begin
    loop
      for k in 1..dim loop
        rnd := Standard_Random_Numbers.Random(0,1);
        if rnd = 1 then
          cnt := cnt + 1;
          res(cnt) := k;
        end if;
      end loop;
      exit when (cnt > 1); -- at least two indices
      cnt := 0;            -- reset the counter
    end loop;
    return res(1..cnt);
  end Random_Indices;

  function Random_Indices
             ( dim,size : integer32 )
             return Standard_Integer_Vectors.Vector is

    res : Standard_Integer_Vectors.Vector(1..size) := (1..size => 0);
    rnd,minval,minidx : integer32;
    redo : boolean; -- check for duplicate indices

  begin
    for k in 1..size loop
      redo := true;
      while redo loop
        rnd := Standard_Random_Numbers.Random(1,dim);
        redo := false;
        for i in 1..k-1 loop
          if res(i) = rnd
           then redo := true; exit;
          end if;
        end loop;
      end loop;
      res(k) := rnd;
    end loop;
   -- sort the indices
    for k in 1..size-1 loop
      minval := res(k); minidx := k;
      for i in k+1..size loop
        if minval > res(i)
         then minidx := i; minval := res(i);
        end if;
      end loop;
      if minidx /= k
       then res(minidx) := res(k); res(k) := minval;
      end if;
    end loop;
    return res;
  end Random_Indices;

  function Random_Complex_Circuit
             ( nbr,dim : integer32 )
             return DoblDobl_Complex_Circuits.Circuit is

    res : DoblDobl_Complex_Circuits.Circuit(nbr)
        := DoblDobl_Complex_Circuits.Allocate(nbr,dim);

  begin
    for k in 1..nbr loop
      res.xps(k) := new Standard_Integer_Vectors.Vector'(Random_Indices(dim));
    end loop;
    res.cff := DoblDobl_Random_Vectors.Random_Vector(1,nbr);
    res.cst := DoblDobl_Random_Numbers.Random1;
    return res;
  end Random_Complex_Circuit;

  function Random_Complex_Circuit
             ( nbr,dim,pwr : integer32 )
             return DoblDobl_Complex_Circuits.Circuit is

    res : DoblDobl_Complex_Circuits.Circuit(nbr)
        := DoblDobl_Complex_Circuits.Allocate(nbr,dim);
    xpk : Standard_Integer_Vectors.Vector(1..dim);

  begin
    for k in 1..nbr loop
      xpk := Standard_Random_Vectors.Random_Vector(1,dim,0,pwr);
      res.xps(k) := new Standard_Integer_Vectors.Vector'(xpk);
      res.idx(k) := Exponent_Indices.Exponent_Index(res.xps(k));
      res.fac(k) := Exponent_Indices.Factor_Index(res.xps(k));
    end loop;
    res.cff := DoblDobl_Random_Vectors.Random_Vector(1,nbr);
    res.cst := DoblDobl_Random_Numbers.Random1;
    return res;
  end Random_Complex_Circuit;

  function Random_Complex_Circuit
             ( nbr,dim,pwr : integer32 )
             return DoblDobl_Complex_Circuits.Link_to_Circuit is

    crc : constant DoblDobl_Complex_Circuits.Circuit(nbr)
        := Random_Complex_Circuit(nbr,dim,pwr);
    res : constant DoblDobl_Complex_Circuits.Link_to_Circuit
        := new DoblDobl_Complex_Circuits.Circuit'(crc);

  begin
    return res;
  end Random_Complex_Circuit;

  function Random_Complex_Circuits
             ( neq,nbr,dim,pwr : integer32 )
             return DoblDobl_Complex_Circuits.Circuits is

    res : DoblDobl_Complex_Circuits.Circuits(1..neq);

  begin
    for k in 1..neq loop
      res(k) := Random_Complex_Circuit(nbr,dim,pwr);
    end loop;
    return res;
  end Random_Complex_Circuits;

  function Random_Complex_System
             ( neq,nbr,dim,pwr : integer32 )
             return DoblDobl_Complex_Circuits.System is

    crc : constant DoblDobl_Complex_Circuits.Circuits(1..neq)
        := Random_Complex_Circuits(neq,nbr,dim,pwr);
    res : constant DoblDobl_Complex_Circuits.System(neq,dim)
        := DoblDobl_Complex_Circuits.Create(crc,dim);

  begin
    return res;
  end Random_Complex_System;

  function Random_Complex_System
             ( neq,nbr,dim,pwr : integer32 )
             return DoblDobl_Complex_Circuits.Link_to_System is

    sys : constant DoblDobl_Complex_Circuits.System(neq,dim)
        := Random_Complex_System(neq,nbr,dim,pwr);
    res : constant DoblDobl_Complex_Circuits.Link_to_System
        := new DoblDobl_Complex_Circuits.System'(sys);

  begin
    return res;
  end Random_Complex_System;

  function to_double_double
             ( c : QuadDobl_Complex_Circuits.Circuit )
             return DoblDobl_Complex_Circuits.Circuit is

    res : DoblDobl_Complex_Circuits.Circuit(c.nbr)
        := DoblDobl_Complex_Circuits.Allocate(c.nbr,c.dim);

    use QuadDobl_Complex_Numbers_cv;
    use QuadDobl_Complex_Vectors_cv;

  begin
    res.xps := c.xps;
    res.idx := c.idx;
    res.fac := c.fac;
    res.cff := QuadDobl_Complex_to_DoblDobl(c.cff);
    res.cst := QuadDobl_Complex_to_DoblDobl(c.cst);
    return res;
  end to_double_double;

  function to_double_double
             ( c : QuadDobl_Complex_Circuits.Link_to_Circuit )
             return DoblDobl_Complex_Circuits.Link_to_Circuit is

    res : DoblDobl_Complex_Circuits.Link_to_Circuit;
    crc : DoblDobl_Complex_Circuits.Circuit(c.nbr);

    use QuadDobl_Complex_Circuits;

  begin
    if c /= null then
      crc := to_double_double(c.all);
      res := new DoblDobl_Complex_Circuits.Circuit'(crc);
    end if;
    return res;
  end to_double_double;

  function to_double_double
             ( c : QuadDobl_Complex_Circuits.Circuits )
             return DoblDobl_Complex_Circuits.Circuits is

    res : DoblDobl_Complex_Circuits.Circuits(c'range);

  begin
    for k in c'range loop
      res(k) := to_double_double(c(k));
    end loop;
    return res;
  end to_double_double;

  function to_double_double
             ( s : QuadDobl_Complex_Circuits.System )
             return DoblDobl_Complex_Circuits.System is

    crc : constant DoblDobl_Complex_Circuits.Circuits(1..s.neq)
        := to_double_double(s.crc);
    res : constant DoblDobl_Complex_Circuits.System(s.neq,s.dim)
        := DoblDobl_Complex_Circuits.Create(crc,s.dim);

  begin
    return res;
  end to_double_double;

  function to_double_double
             ( s : QuadDobl_Complex_Circuits.Link_to_System )
             return DoblDobl_Complex_Circuits.Link_to_System is

    sys : DoblDobl_Complex_Circuits.System(s.neq,s.dim);
    res : DoblDobl_Complex_Circuits.Link_to_System;

    use QuadDobl_Complex_Circuits;

  begin
    if s /= null then
      sys := to_double_double(s.all);
      res := new DoblDobl_Complex_Circuits.System'(sys);
    end if;
    return res;
  end to_double_double;

  function Make_Polynomial
             ( c : DoblDobl_Complex_Circuits.Circuit;
               index : boolean := false )
             return DoblDobl_Complex_Polynomials.Poly is

    use DoblDobl_Complex_Polynomials;

    res : Poly;
    t : Term;
    lnk : Standard_Integer_Vectors.Link_to_Vector;

  begin
    t.dg := new Standard_Natural_Vectors.Vector'(1..c.dim => 0);
    t.cf := c.cst;
    res := Create(t);
    for k in 1..c.nbr loop
      t.cf := c.cff(k);
      lnk := c.xps(k);
      if index then
        t.dg.all := (1..c.dim => 0);
        for i in lnk'range loop
          t.dg(lnk(i)) := 1;
        end loop;
      else
        for i in 1..c.dim loop
          t.dg(i) := natural32(lnk(i));
        end loop;
      end if;
      Add(res,t);
    end loop;
    Clear(t);
    return res;
  end Make_Polynomial;

  function Gradient ( p : DoblDobl_Complex_Polynomials.Poly;
                      x : DoblDobl_Complex_Vectors.Vector )
                    return DoblDobl_Complex_Vectors.Vector is

    res : DoblDobl_Complex_Vectors.Vector(x'range);
    dp : DoblDobl_Complex_Polynomials.Poly;

  begin
    for k in x'range loop
      dp := DoblDobl_Complex_Polynomials.Diff(p,k);
      res(k) := DoblDobl_Complex_Poly_Functions.Eval(dp,x);
      DoblDobl_Complex_Polynomials.Clear(dp);
    end loop;
    return res;
  end Gradient;

  function Hessian ( p : DoblDobl_Complex_Polynomials.Poly;
                     x : DoblDobl_Complex_Vectors.Vector )
                   return DoblDobl_Complex_Matrices.Matrix is

    res : DoblDobl_Complex_Matrices.Matrix(x'range,x'range);

    use DoblDobl_Complex_Polynomials;
    use DoblDobl_Complex_Poly_Functions;

    dp,dp2 : Poly;

  begin
    for i in res'range(1) loop
      dp := Diff(p,i);
      for j in res'range(2) loop
        dp2 := Diff(dp,j);
        res(i,j) := Eval(dp2,x);
        Clear(dp2);
      end loop;
      Clear(dp);
    end loop;
    return res;
  end Hessian;

  function Constant_Coefficient
             ( p : DoblDobl_Complex_Polynomials.Poly )
             return DoblDobl_Complex_Numbers.Complex_Number is

    use DoblDobl_Complex_Polynomials;

    dim : constant integer32 := integer32(Number_of_Unknowns(p));
    deg : Degrees := new Standard_Natural_Vectors.Vector'(1..dim => 0);
    res : constant DoblDobl_Complex_Numbers.Complex_Number := Coeff(p,deg);

  begin
    Clear(deg);
    return res;
  end Constant_Coefficient;

  function Is_NonZero ( c : DoblDobl_Complex_Numbers.Complex_Number )
                   return integer32 is

    zero : constant double_double := create(0.0);

  begin
    if DoblDobl_Complex_Numbers.REAL_PART(c) /= zero then
      return 1;
    elsif DoblDobl_Complex_Numbers.IMAG_PART(c) /= zero then
      return 1;
    else
      return 0;
    end if;
  end Is_NonZero;

  function Make_Complex_Circuit
             ( p : DoblDobl_Complex_Polynomials.Poly )
             return DoblDobl_Complex_Circuits.Circuit is

    use DoblDobl_Complex_Polynomials;

    nbr : constant integer32 := integer32(Number_of_Terms(p));
    dim : constant integer32 := integer32(Number_of_Unknowns(p));
    cst : constant DoblDobl_Complex_Numbers.Complex_Number
        := Constant_Coefficient(p);
    isz : constant integer32 := Is_NonZero(cst);
    res : DoblDobl_Complex_Circuits.Circuit(nbr-isz)
        := DoblDobl_Complex_Circuits.Allocate(nbr-isz,dim);
    cnt : integer32 := 0;

    function Is_Zero ( d : in Degrees ) return boolean is
    
    -- DESCRIPTION :
    --   Returns true if all entries of d are zero.

    begin
      for k in d'range loop
        if d(k) /= 0
         then return false;
        end if;
      end loop;
      return true;
    end Is_Zero;

    procedure Visit_Term ( t : in Term; c : out boolean ) is

      xp : Standard_Integer_Vectors.Vector(t.dg'range);

    begin
      if not Is_Zero(t.dg) then
        cnt := cnt + 1;
        res.cff(cnt) := t.cf;
        for i in xp'range loop
          xp(i) := integer32(t.dg(i));
        end loop;
        res.xps(cnt) := new Standard_Integer_Vectors.Vector'(xp);
        res.idx(cnt) := Exponent_Indices.Exponent_Index(res.xps(cnt));
        res.fac(cnt) := Exponent_Indices.Factor_Index(res.xps(cnt));
      end if;
      c := true;
    end Visit_Term;
    procedure Visit_Terms is new Visiting_Iterator(Visit_Term);

  begin
    res.dim := dim;
    res.cst := cst;
    Visit_Terms(p);
    return res;
  end Make_Complex_Circuit;

  function Make_Complex_System
             ( p : in DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
               verbose : in boolean := true )
             return DoblDobl_Complex_Circuits.Link_to_System is

    use DoblDobl_Complex_Circuits;

    res : Link_to_System;
    c : Circuits(p'range);
    d : integer32;

  begin
    for k in c'range loop
      c(k) := new Circuit'(Make_Complex_Circuit(p(k)));
      if verbose then
        for i in 1..c(k).nbr loop
          put(c(k).cff(i)); put(c(k).xps(i)); new_line;
        end loop;
        put(c(k).cst); new_line;
      end if;
    end loop;
    d := c(c'first).dim;
    res := new System'(Create(c,d));
    return res;
  end Make_Complex_System;

  procedure Write_Matrix ( A : in DoblDobl_Complex_Matrices.Matrix ) is
  begin
    for i in A'range(1) loop
      for j in A'range(2) loop
        put("A["); put(i,1); put(","); put(j,1); put("] : ");
        put(A(i,j)); new_line;
      end loop;
    end loop;
  end Write_Matrix;

end DoblDobl_Circuit_Makers;
