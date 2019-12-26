with unchecked_deallocation;

package body Generic_Speelpenning_Convolutions is

  function Create ( x : VecVecs.VecVec;
                    d : Standard_Integer_Vectors.Vector )
                  return Link_to_VecVecVec is

    res : Link_to_VecVecVec;
    pwt : VecVecVec(x'range);

  begin
    for i in x'range loop
      if d(i) > 2 then
        declare
          xpw : constant VecVecs.VecVec(1..d(i)-2)
              := Allocate_Coefficients(d(i)-2,x(i)'last);
        begin
          Multiply(x(i),x(i),xpw(1));
          for k in 2..(d(i)-2) loop
            Multiply(xpw(k-1),x(i),xpw(k));
          end loop;
          pwt(i) := new VecVecs.VecVec'(xpw);
        end;
      end if;
    end loop;
    res := new VecVecVec'(pwt);
    return res;
  end Create;

  procedure Clear ( pwt : in out Link_to_VecVecVec ) is

    procedure free is new unchecked_deallocation(VecVecVec,Link_to_VecVecVec);

  begin
    if pwt /= null then
      for k in pwt'range loop
        VecVecs.Deep_Clear(pwt(k));
      end loop;
      free(pwt);
    end if;
  end Clear;

  procedure Clear ( c : in out Convolution_Circuit ) is
  begin
    Standard_Integer_VecVecs.Clear(c.xps);
    Standard_Integer_VecVecs.Clear(c.idx);
    Standard_Integer_VecVecs.Clear(c.fac);
    VecVecs.Clear(c.cff);
    Vectors.Clear(c.cst);
    VecVecs.Clear(c.forward);
    VecVecs.Clear(c.backward);
    VecVecs.Clear(c.cross);
    Vectors.Clear(c.wrk);
    Vectors.Clear(c.acc);
  end Clear;

  procedure Clear ( c : in out Link_to_Convolution_Circuit ) is

    procedure free is
      new unchecked_deallocation(Convolution_Circuit,
                                 Link_to_Convolution_Circuit);

  begin
    if c /= null then
      Clear(c.all);
      free(c);
    end if;
  end Clear;

  procedure Clear ( c : in out Convolution_Circuits ) is
  begin
    for k in c'range loop
      Clear(c(k));
    end loop;
  end Clear;

  procedure Clear ( c : in out Link_to_Convolution_Circuits ) is

    procedure free is
      new unchecked_deallocation(Convolution_Circuits,
                                 Link_to_Convolution_Circuits);

  begin
    if c /= null then
      Clear(c.all);
      free(c);
    end if;
  end Clear;

-- ALLOCATORS :

  function Allocate_Coefficients
             ( deg : integer32 ) return Vectors.Link_to_Vector is

    cff : constant Vectors.Vector(0..deg) := (0..deg => Ring.zero);
    res : constant Vectors.Link_to_Vector := new Vectors.Vector'(cff);

  begin
    return res;
  end Allocate_Coefficients;

  function Allocate_Coefficients
             ( dim,deg : integer32 ) return VecVecs.VecVec is

    res : VecVecs.VecVec(1..dim);

  begin
    for k in 1..dim loop
      res(k) := Allocate_Coefficients(deg);
    end loop;
    return res;
  end Allocate_Coefficients;

  function Allocate_Coefficients
             ( nbq,nvr,deg : integer32 ) return VecMats.VecMat is

    res : VecMats.VecMat(0..deg);

  begin
    for k in res'range loop
      declare
        mat : Matrices.Matrix(1..nbq,1..nvr);
      begin
        for i in 1..nbq loop
          for j in 1..nvr loop
            mat(i,j) := Ring.zero;
          end loop;
        end loop;
        res(k) := new Matrices.Matrix'(mat);
      end;
    end loop;
    return res;
  end Allocate_Coefficients;

-- AUXILIARY COMPUTATIONAL PROCEDURES :

  procedure Update ( values : in Vectors.Link_to_Vector;
                     inc : in Vectors.Link_to_Vector ) is

    use Ring;

  begin
    for i in values'range loop
      values(i) := values(i) + inc(i);
    end loop;
  end Update;

  procedure Multiply ( first,second,product : in Vectors.Link_to_Vector ) is

    deg : constant integer32 := first'last;

    use Ring;

  begin
    product(0) := first(0)*second(0);
    for k in 1..deg loop
      product(k) := first(0)*second(k);
      for i in 1..k loop
        product(k) := product(k) + first(i)*second(k-i);
      end loop;
    end loop;
  end Multiply;

-- REVERSE MODE OF ALGORITHMIC DIFFERENTIATION :

  procedure Speel ( x : in VecVecs.VecVec;
                    forward,backward,cross : in VecVecs.VecVec ) is
  begin
    Multiply(x(1),x(2),forward(1));
    for k in 3..x'last loop
      Multiply(forward(k-2),x(k),forward(k-1));
    end loop;
    if x'last > 2 then
      Multiply(x(x'last),x(x'last-1),backward(1));
      for k in 2..x'last-2 loop
        Multiply(backward(k-1),x(x'last-k),backward(k));
      end loop;
      if x'last = 3 then
        Multiply(x(1),x(3),cross(1));
      else
        Multiply(x(1),backward(x'last-3),cross(1));
        for k in 2..x'last-3 loop
          Multiply(forward(k-1),backward(x'last-2-k),cross(k));
        end loop;
        Multiply(forward(x'last-3),x(x'last),cross(x'last-2));
      end if;
    end if;
  end Speel;

  procedure Speel ( x : in VecVecs.VecVec;
                    idx : in Standard_Integer_Vectors.Vector;
                    forward,backward,cross : in VecVecs.VecVec ) is
  begin
    Multiply(x(idx(1)),x(idx(2)),forward(1));
    for k in 3..idx'last loop
      Multiply(forward(k-2),x(idx(k)),forward(k-1));
    end loop;
    if idx'last > 2 then
      Multiply(x(idx(idx'last)),x(idx(idx'last-1)),backward(1));
      for k in 2..idx'last-2 loop
        Multiply(backward(k-1),x(idx(idx'last-k)),backward(k));
      end loop;
      if idx'last = 3 then
        Multiply(x(idx(1)),x(idx(3)),cross(1));
      else
        Multiply(x(idx(1)),backward(idx'last-3),cross(1));
        for k in 2..idx'last-3 loop
          Multiply(forward(k-1),backward(idx'last-2-k),cross(k));
        end loop;
        Multiply(forward(idx'last-3),x(idx(idx'last)),cross(idx'last-2));
      end if;
    end if;
  end Speel;

  procedure Speel ( idx : in Standard_Integer_VecVecs.VecVec;
                    x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec ) is

    use Standard_Integer_Vectors;
    use Ring;

    idk : Standard_Integer_Vectors.Link_to_Vector;
    yptr : constant Vectors.Link_to_Vector := yd(yd'last);

  begin
    for k in idx'range loop
      idk := idx(k);
      if idk /= null then
        if idk'last = 1 then
          Update(yptr,x(idk(1)));
          yd(idk(1))(0) := yd(idk(1))(0) + Ring.one;
        else
          Speel(x,idk.all,forward,backward,cross);
          Update(yptr,forward(idk'last-1));
          if idk'last = 2 then
            Update(yd(idk(2)),x(idk(1)));
            Update(yd(idk(1)),x(idk(2)));
          else -- idk'last > 2 
            Update(yd(idk(1)),backward(idk'last-2));
            for j in idk'first+1..idk'last-1 loop
              Update(yd(idk(j)),cross(j-1));
            end loop;
            Update(yd(idk(idk'last)),forward(idk'last-2));
          end if;
        end if;
      end if;
    end loop;
  end Speel;

  procedure Speel ( idx : in Standard_Integer_VecVecs.VecVec;
                    cff : in VecVecs.VecVec; x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec;
                    wrk : in Vectors.Link_to_Vector ) is

    use Standard_Integer_Vectors;

    idk : Standard_Integer_Vectors.Link_to_Vector;
    yptr : constant Vectors.Link_to_Vector := yd(yd'last);
    pcff : Vectors.Link_to_Vector;

  begin
    for k in idx'range loop
      idk := idx(k);
      if idk /= null then
        pcff := cff(k);
        if idk'last = 1 then
          Multiply(pcff,x(idk(1)),wrk);
          Update(yptr,wrk);
          Update(yd(idk(1)),pcff);
        else
          Speel(x,idk.all,forward,backward,cross);
          Multiply(pcff,forward(idk'last-1),wrk);
          Update(yptr,wrk);
          if idk'last = 2 then
            Multiply(pcff,x(idk(1)),wrk);
            Update(yd(idk(2)),wrk);
            Multiply(pcff,x(idk(2)),wrk);
            Update(yd(idk(1)),wrk);
          else -- idk'last > 2 
            Multiply(pcff,backward(idk'last-2),wrk);
            Update(yd(idk(1)),wrk);
            for j in idk'first+1..idk'last-1 loop
              Multiply(pcff,cross(j-1),wrk);
              Update(yd(idk(j)),wrk);
            end loop;
            Multiply(pcff,forward(idk'last-2),wrk);
            Update(yd(idk(idk'last)),wrk);
          end if;
        end if;
      end if;
    end loop;
  end Speel;

  procedure Multiply_Factor
              ( xpk,facidx : in Standard_Integer_Vectors.Link_to_Vector;
                x : in VecVecs.VecVec;
                cff,wrk,acc : in Vectors.Link_to_Vector;
                pwt : in Link_to_VecVecVec ) is

    pwx : VecVecs.Link_to_VecVec;
    lpw : Vectors.Link_to_Vector;
    powidx : integer32;

  begin
    pwx := pwt(facidx(facidx'first));
    powidx := xpk(facidx(facidx'first));   -- power in power table
    if powidx = 2 then
      Multiply(cff,x(facidx(facidx'first)),acc);
    else
      lpw := pwx(powidx-2);  -- coefficients of higher powers
      Multiply(cff,lpw,acc);
    end if;
    for k in facidx'first+1..facidx'last loop
      for i in wrk'range loop
        wrk(i) := acc(i);
      end loop;
      pwx := pwt(facidx(k));
      powidx := xpk(facidx(k));   -- power in power table
      if powidx = 2 then
        Multiply(wrk,x(facidx(k)),acc);
      else
        lpw := pwx(powidx-2);  -- coefficients of higher powers
        Multiply(wrk,lpw,acc);
      end if;
    end loop;
  end Multiply_Factor;

  procedure Multiply_Power
              ( multiplier : in integer32;
                cff : in Vectors.Link_to_Vector ) is

    factor : constant Ring.number := Ring.create(integer(multiplier));

  begin
    for i in cff'range loop
      Ring.Mul(cff(i),factor);
    end loop;
  end Multiply_Power;

  procedure Speel ( xps,idx,fac : in Standard_Integer_VecVecs.VecVec;
                    cff : in VecVecs.VecVec; x : in VecVecs.VecVec;
                    forward,backward,cross,yd : in VecVecs.VecVec;
                    wrk,acc : in Vectors.Link_to_Vector;
                    pwt : in Link_to_VecVecVec ) is

    use Standard_Integer_Vectors;

    idk,xpk,fck : Standard_Integer_Vectors.Link_to_Vector;
    yptr : constant Vectors.Link_to_Vector := yd(yd'last);
    pcff : Vectors.Link_to_Vector;

  begin
    for k in idx'range loop
      idk := idx(k);           -- the k-th exponent index 
      if idk /= null then
        xpk := xps(k);         -- the k-th exponent vector
        fck := fac(k);         -- the k-th factor index
        pcff := cff(k);
        if idk'last = 1 then
          if fck = null then
            Multiply(pcff,x(idk(1)),wrk);
            Update(yptr,wrk);
            Update(yd(idk(1)),pcff);
          else
            Multiply_Factor(xpk,fck,x,pcff,wrk,acc,pwt);
            Multiply(acc,x(idk(1)),wrk);
            Update(yptr,wrk);
            Multiply_Power(xpk(idk(1)),acc);
            Update(yd(idk(1)),acc);
          end if;
        else
          Speel(x,idk.all,forward,backward,cross);
          if fck = null then
            Multiply(pcff,forward(idk'last-1),wrk);
          else
            Multiply_Factor(xpk,fck,x,pcff,wrk,acc,pwt);
            Multiply(acc,forward(idk'last-1),wrk);
          end if;
          Update(yptr,wrk);
          if idk'last = 2 then
            if fck = null then
              Multiply(pcff,x(idk(1)),wrk);
              Update(yd(idk(2)),wrk);
              Multiply(pcff,x(idk(2)),wrk);
              Update(yd(idk(1)),wrk);
            else -- use the common factor in acc
              Multiply(acc,x(idk(1)),wrk);
              if xpk(idk(2)) > 1
               then Multiply_Power(xpk(idk(2)),wrk);
              end if;
              Update(yd(idk(2)),wrk);
              Multiply(acc,x(idk(2)),wrk);
              if xpk(idk(1)) > 1
               then Multiply_Power(xpk(idk(1)),wrk);
              end if;
              Update(yd(idk(1)),wrk);
            end if;
          else -- idk'last > 2 
            if fck = null then
              Multiply(pcff,backward(idk'last-2),wrk);
              Update(yd(idk(1)),wrk);
              for j in idk'first+1..idk'last-1 loop
                Multiply(pcff,cross(j-1),wrk);
                Update(yd(idk(j)),wrk);
              end loop;
              Multiply(pcff,forward(idk'last-2),wrk);
              Update(yd(idk(idk'last)),wrk);
            else
              Multiply(acc,backward(idk'last-2),wrk);
              Multiply_Power(xpk(idk(1)),wrk);
              Update(yd(idk(1)),wrk);
              for j in idk'first+1..idk'last-1 loop
                Multiply(acc,cross(j-1),wrk);
                Multiply_Power(xpk(idk(j)),wrk);
                Update(yd(idk(j)),wrk);
              end loop;
              Multiply(acc,forward(idk'last-2),wrk);
              Multiply_Power(xpk(idk(idk'last)),wrk);
              Update(yd(idk(idk'last)),wrk);
            end if;
          end if;
        end if;
      end if;
    end loop;
  end Speel;

  procedure EvalDiff ( c : in Convolution_Circuit;
                       x : in VecVecs.VecVec;
                       pwt : in Link_to_VecVecVec;
                       yd : in VecVecs.VecVec ) is
  begin
    Speel(c.xps,c.idx,c.fac,c.cff,x,c.forward,c.backward,c.cross,yd,
          c.wrk,c.acc,pwt);
    Update(yd(yd'last),c.cst);
  end EvalDiff;

  procedure EvalDiff ( c : in Convolution_Circuits;
                       x : in VecVecs.VecVec;
                       pwt : in Link_to_VecVecVec;
                       yd : in VecVecs.VecVec;
                       vy : in VecVecs.VecVec;
                       vm : in VecMats.VecMat ) is

    vleft,vright : Vectors.Link_to_Vector;
    mleft : Matrices.Link_to_Matrix;

  begin
    for i in c'range loop
      EvalDiff(c(i).all,x,pwt,yd);
      vleft := vy(i);
      vright := yd(x'last+1);
      for j in vleft'range loop
        vleft(j) := vright(j);
      end loop;
      for j in 1..x'last loop
        vright := yd(j);
        for k in vm'range loop     -- k-th coefficient in matrix vm(k)
          mleft := vm(k);          -- the row i in vm(k) is the equation
          mleft(i,j) := vright(k); -- the column j in vm(k) is the variable
        end loop;
      end loop;
    end loop;
  end EvalDiff;

end Generic_Speelpenning_Convolutions;