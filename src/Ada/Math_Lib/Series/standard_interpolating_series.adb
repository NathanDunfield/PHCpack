with text_io;                             use text_io;
with Standard_Integer_Numbers_io;         use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;           use Standard_Floating_Numbers;
with Standard_Random_Numbers;
with Standard_Random_Vectors;
with Standard_Integer_Vectors;
with Standard_Floating_Vectors_io;        use Standard_Floating_Vectors_io;
with Standard_Complex_Vectors_io;         use Standard_Complex_Vectors_io;
with Standard_Complex_VecVecs_io;         use Standard_Complex_VecVecs_io;
with Standard_Complex_Matrices_io;        use Standard_Complex_Matrices_io;
with Standard_Complex_Vector_Norms;
with Standard_Complex_Linear_Solvers;
with Standard_Complex_Singular_Values;

package body Standard_Interpolating_Series is

  function Eval ( v : Standard_Dense_Vector_Series.Vector;
                  t : Complex_Number )
                return Standard_Complex_Vectors.Vector is

    vec : Standard_Complex_Vectors.Link_to_Vector := v.cff(0);
    res : Standard_Complex_Vectors.Vector(vec'range) := vec.all;
    pwt : Complex_Number := Create(1.0);
 
    use Standard_Complex_Vectors;

  begin
    for k in 1..v.deg loop
      pwt := pwt*t;
      res := res + pwt*v.cff(k).all;
    end loop;
    return res;
  end Eval;

  function Eval ( m : Standard_Dense_Matrix_Series.Matrix;
                  t : Complex_Number )
                return Standard_Complex_Matrices.Matrix is

    mat : Standard_Complex_Matrices.Link_to_Matrix := m.cff(0);
    res : Standard_Complex_Matrices.Matrix(mat'range(1),mat'range(2))
        := mat.all;
    pwt : Complex_Number := Create(1.0);

  begin
    for k in 1..m.deg loop
      pwt := pwt*t;
      mat := m.cff(k);
      for i in mat'range(1) loop
        for j in mat'range(2) loop
          res(i,j) := res(i,j) + pwt*mat(i,j);
        end loop;
      end loop;
    end loop;
    return res;
  end Eval;

  function Full_Rank
             ( m : Standard_Dense_Matrix_Series.Matrix;
               d : integer32; verbose : boolean := true ) return boolean is

    t : constant Complex_Number := Standard_Random_Numbers.Random1;
    mat : Standard_Complex_Matrices.Link_to_Matrix := m.cff(0);
    val : Standard_Complex_Matrices.Matrix(mat'range(1),mat'range(2))
        := mat.all;
    pwt : Complex_Number := Create(1.0);
    n : constant integer32 := val'last(1);
    p : constant integer32 := val'last(2);
    mm : constant integer32 := Standard_Complex_Singular_Values.Min0(n+1,p);
    s : Standard_Complex_Vectors.Vector(1..mm);
    e : Standard_Complex_Vectors.Vector(1..p);
    u : Standard_Complex_Matrices.Matrix(1..n,1..n);
    v : Standard_Complex_Matrices.Matrix(1..p,1..p);
    job : constant integer32 := 11;
    rnk,info : integer32;
    tol : constant double_float := 1.0E-8;

  begin
    for k in 1..d loop
      pwt := pwt*t;
      mat := m.cff(k);
      for i in mat'range(1) loop
        for j in mat'range(2) loop
          val(i,j) := val(i,j) + pwt*mat(i,j);
        end loop;
      end loop;
    end loop;
    Standard_Complex_Singular_Values.SVD(val,n,p,s,e,u,v,job,info);
    rnk := Standard_Complex_Singular_Values.Rank(s,tol);
    if verbose then
      put_line("The singular values : "); put_line(s);
      put("The numerical rank : "); put(rnk,1); new_line;
    end if;
    return (rnk = n);
  end Full_Rank;

  function Full_Rank
             ( m : Standard_Dense_Matrix_Series.Matrix;
               verbose : boolean := true ) return integer32 is
  begin
    for d in 0..m.deg loop
      if Full_Rank(m,d)
       then return d;
      end if;
    end loop;
    return -1;
  end Full_Rank;

  function Sample ( v : Standard_Dense_Vector_Series.Vector;
                    t : Standard_Complex_Vectors.Vector )
                  return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(t'range);
    lv : Standard_Complex_Vectors.Link_to_Vector := v.cff(0);

  begin
    for i in t'range loop
      declare
        e : constant Standard_Complex_Vectors.Vector(lv'range)
          := Eval(v,t(i));
      begin
        res(i) := new Standard_Complex_Vectors.Vector'(e);
      end;
    end loop;
    return res;
  end Sample;

  function Sample ( m : Standard_Dense_Matrix_Series.Matrix;
                    t : Standard_Complex_Vectors.Vector )
                  return Standard_Complex_VecMats.VecMat is

    res : Standard_Complex_VecMats.VecMat(t'range);
    lm : Standard_Complex_Matrices.Link_to_Matrix := m.cff(0);

  begin
    for i in t'range loop
      declare
        e : constant Standard_Complex_Matrices.Matrix(lm'range(1),lm'range(2))
          := Eval(m,t(i));
      begin
        res(i) := new Standard_Complex_Matrices.Matrix'(e);
      end;
    end loop;
    return res;
  end Sample;

  function Solve_Linear_Systems
             ( m : Standard_Complex_VecMats.VecMat;
               v : Standard_Complex_VecVecs.VecVec )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(m'range);
    dim : constant integer32 := v(0)'last;
    info : integer32;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    sol : Standard_Complex_Vectors.Vector(1..dim);
    wrk : Standard_Complex_Matrices.Matrix(1..dim,1..dim);

  begin
    for i in v'range loop
      sol := v(i).all;
      wrk := m(i).all;
      Standard_Complex_Linear_Solvers.lufac(wrk,dim,ipvt,info);
      Standard_Complex_Linear_Solvers.lusolve(wrk,dim,ipvt,sol);
      res(i) := new Standard_Complex_Vectors.Vector'(sol);
    end loop;
    return res;
  end Solve_Linear_Systems;

  function Residuals
             ( m : Standard_Complex_VecMats.VecMat;
               v,x : Standard_Complex_VecVecs.VecVec )
             return Standard_Floating_Vectors.Vector is

    res : Standard_Floating_Vectors.Vector(v'range);
    dim : constant integer32 := v(0)'last;
    lm : Standard_Complex_Matrices.Link_to_Matrix;
    lv,lx : Standard_Complex_Vectors.Link_to_Vector;
    wrk : Standard_Complex_Vectors.Vector(1..dim);

    use Standard_Complex_Vectors;
    use Standard_Complex_Matrices;

  begin
    for i in res'range loop
      lm := m(i);
      lv := v(i);
      lx := x(i);
      wrk := lv.all - lm.all*lx.all;
      res(i) := Standard_Complex_Vector_Norms.Max_Norm(wrk);
    end loop;
    return res;
  end Residuals;

  function Transpose ( x : Standard_Complex_VecVecs.VecVec )
                     return Standard_Complex_VecVecs.VecVec is

    deg : constant integer32 := x'last;
    dim : constant integer32 := x(0)'last;
    res : Standard_Complex_VecVecs.VecVec(1..dim);

  begin
    for i in res'range loop
      res(i) := new Standard_Complex_Vectors.Vector(1..deg+1);
    end loop;
    for i in x'range loop
      for j in x(i)'range loop
        res(j)(i+1) := x(i)(j);
      end loop;
    end loop;
    return res;
  end Transpose;

  function Vandermonde_Matrix
             ( t : Standard_Complex_Vectors.Vector )
             return Standard_Complex_Matrices.Matrix is

    dim : constant integer32 := t'last - t'first + 1;
    res : Standard_Complex_Matrices.Matrix(1..dim,1..dim);
    idx : integer32 := 0;

  begin
    for i in t'range loop
      idx := idx + 1;
      res(idx,1) := Create(1.0);
      for j in 2..dim loop
        res(idx,j) := res(idx,j-1)*t(i);
      end loop;
    end loop;
    return res;
  end Vandermonde_Matrix;

  function Solve_Interpolation_Systems
             ( v : Standard_Complex_Matrices.Matrix;
               f : Standard_Complex_VecVecs.VecVec )
             return Standard_Complex_VecVecs.VecVec is

    res : Standard_Complex_VecVecs.VecVec(f'range);
    dim : constant integer32 := v'last(1);
    wrk : Standard_Complex_Matrices.Matrix(v'range(1),v'range(2)) := v;
    sol : Standard_Complex_Vectors.Vector(1..dim);
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    info : integer32;

  begin
    Standard_Complex_Linear_Solvers.lufac(wrk,dim,ipvt,info);
    for i in f'range loop
      sol := f(i).all;
      Standard_Complex_Linear_Solvers.lusolve(wrk,dim,ipvt,sol);
      res(i) := new Standard_Complex_Vectors.Vector'(sol);
    end loop;
    return res;
  end Solve_Interpolation_Systems;

  function Construct ( x : Standard_Complex_VecVecs.VecVec )
                     return Standard_Dense_Vector_Series.Vector is

    res : Standard_Dense_Vector_Series.Vector;
    dim : constant integer32 := x'last;
    lx0 : constant Standard_Complex_Vectors.Link_to_Vector := x(x'first); 
    deg : constant integer32 := lx0'last - lx0'first;

  begin
    res.deg := deg;
    for i in 0..res.deg loop
      res.cff(i) := new Standard_Complex_Vectors.Vector(1..dim);
    end loop;
    for i in x'range loop
      for j in x(i)'range loop
        res.cff(j-1)(i) := x(i)(j);
      end loop;
    end loop;
    return res;
  end Construct;

  function Interpolate
             ( mat : Standard_Dense_Matrix_Series.Matrix;
               rhs : Standard_Dense_Vector_Series.Vector;
               verbose : boolean := true )
             return Standard_Dense_Vector_Series.Vector is

    res : Standard_Dense_Vector_Series.Vector;
    dim : constant integer32 := rhs.cff(0)'last;
    t : constant Standard_Complex_Vectors.Vector(0..mat.deg)
      := Standard_Random_Vectors.Random_Vector(0,mat.deg);
    m : Standard_Complex_VecMats.VecMat(t'range) := Sample(mat,t);
    v : Standard_Complex_VecVecs.VecVec(t'range) := Sample(rhs,t);
    x : Standard_Complex_VecVecs.VecVec(t'range);
    r : Standard_Floating_Vectors.Vector(t'range);
    xt : Standard_Complex_VecVecs.VecVec(1..dim);
    vdm : Standard_Complex_Matrices.Matrix(1..mat.deg+1,1..mat.deg+1);
    cff : Standard_Complex_VecVecs.VecVec(1..dim);

  begin
    if verbose then
      put_line("The sample points :");
      put_line(t);
    end if;
    x := Solve_Linear_Systems(m,v);
    r := Residuals(m,v,x);
    if verbose then
      put_line("The solutions to the interpolated linear systems :");
      put_line(x);
      put_line("The residuals of the solved sampled linear systems :");
      put_line(r);
    end if;
    xt := Transpose(x);
    if verbose then
      put_line("The transposed solution vectors :");
      put_line(xt);
    end if;
    vdm := Vandermonde_Matrix(t);
    cff := Solve_Interpolation_Systems(vdm,xt);
    if verbose then
      put_line("The coefficients computed via interpolation :");
      put_line(cff);
    end if;
    res := Construct(cff);
    return res;
  end Interpolate;

  function factorial ( k : integer32 ) return Complex_Number is

    fac : integer32 := 1;
    res : Complex_Number;

  begin
    for i in 2..k loop
      fac := i*fac;
    end loop;
    res := Create(double_float(fac));
    return res;
  end factorial;

  function Diff ( m : Standard_Complex_VecMats.VecMat;
                  t : Complex_Number; pow,ord : integer32 )
                return Standard_Complex_Matrices.Matrix is

    lm0 : Standard_Complex_Matrices.Link_to_Matrix := m(0);
    dim : constant integer32 := lm0'last(1);
    res : Standard_Complex_Matrices.Matrix(1..dim,1..dim);
    npw : constant natural := natural(pow);
    idx : integer32;
    pwt,fac : Complex_Number;

    use Standard_Complex_Matrices;

  begin
    if ord = 0 then      -- evaluate
      res := m(0).all;
      if pow = 0 then
        pwt := Create(1.0);
      else
        pwt := t**npw;
        res := pwt*res;
      end if;
      for i in 1..m'last loop
        pwt := pwt*t;
        res := res + pwt*m(i).all;
      end loop;
    elsif pow = 0 then   -- differentiate, start at index ord
      res := factorial(ord)*m(ord).all;
      pwt := Create(1.0);
      for j in ord+1..m'last loop
        pwt := pwt*t;
        fac := factorial(ord)/factorial(j-ord)*pwt;
        res := res + fac*m(j).all;
      end loop;
    else  -- differentiate with multiplication of power of t
      idx := ord-pow;
      if idx < 0
       then idx := 0;
      end if;
      res := m(idx).all;
      if pow <= ord then
        pwt := Create(1.0);
        res := m(idx).all;
      else
        pwt := t**natural(pow-ord);
        res := pwt*m(idx).all;
      end if;
      for i in idx+1..m'last loop
        pwt := pwt*t;
        res := res + pwt*m(i).all;
      end loop;
    end if;
    return res;
  end Diff;

  function Hermite_Matrix
             ( m : Standard_Complex_VecMats.VecMat;
               t : Complex_Number )
             return Standard_Complex_Matrices.Matrix is

    lmt : constant Standard_Complex_Matrices.Link_to_Matrix := m(0);
    adim : constant integer32 := lmt'last(1);
    rdim : constant integer32 := adim*(m'last+1);
    res : Standard_Complex_Matrices.Matrix(1..rdim,1..rdim);
    wrk : Standard_Complex_Matrices.Matrix(1..adim,1..adim);

  begin
    for col in m'range loop      -- columns are the powers of t
      for row in m'range loop    -- rows are the differentiation orders
        wrk := Diff(m,t,col,row);
        for i in wrk'range(1) loop
          for j in wrk'range(2) loop
            res(row*adim+i,col*adim+j) := wrk(i,j);
          end loop;
        end loop;
      end loop;
    end loop;
    return res;
  end Hermite_Matrix;

  function Hermite_Vector
             ( v : Standard_Complex_VecVecs.VecVec;
               t : Complex_Number )
             return Standard_Complex_Vectors.Vector is

    lv0 : constant Standard_Complex_Vectors.Link_to_Vector := v(0);
    adim : constant integer32 := lv0'last; 
    rdim : constant integer32 := adim*(v'last+1);
    res : Standard_Complex_Vectors.Vector(1..rdim);
    wrk : Standard_Complex_Vectors.Vector(lv0'range);
    pwt : Complex_Number := Create(1.0);
    fac : Complex_Number;

    use Standard_Complex_Vectors;

  begin
    wrk := v(0).all;
    for i in 1..v'last loop         -- evaluate at t
      pwt := pwt*t;
      wrk := wrk + pwt*v(i).all;
    end loop;
    for i in 1..adim loop
      res(i) := wrk(i);
    end loop;
    for i in 1..v'last loop         -- the i-th derivative
      wrk := factorial(i)*v(i).all;
      pwt := Create(1.0);
      for j in i+1..v'last loop
        pwt := pwt*t;
        fac := factorial(i)/factorial(j-i)*pwt;
        wrk := wrk + fac*v(j).all;
      end loop;
      for j in 1..adim loop
        res(i*adim+j) := wrk(j);
      end loop;
    end loop;
    return res;
  end Hermite_Vector;

  function Hermite_Interpolate
             ( mat : Standard_Dense_Matrix_Series.Matrix;
               rhs : Standard_Dense_Vector_Series.Vector;
               t : Complex_Number; verbose : boolean := true )
             return Standard_Dense_Vector_Series.Vector is

    res : Standard_Dense_Vector_Series.Vector;
    deg : constant integer32 := mat.deg;
    dim : constant integer32 := mat.cff(0)'last(1);
    bigdim : constant integer32 := (deg+1)*dim;
    A : Standard_Complex_Matrices.Matrix(1..bigdim,1..bigdim)
      := Hermite_Matrix(mat.cff,t);
    b : Standard_Complex_Vectors.Vector(1..bigdim)
      := Hermite_Vector(rhs.cff,t);
    info : integer32;
    ipvt : Standard_Integer_Vectors.Vector(1..bigdim);
    wrk : Standard_Complex_Vectors.Vector(1..dim);

  begin
    if verbose then
      put_line("The coefficient matrix :"); put(A);
      put_line("The right hand side vector :"); put_line(b);
    end if;
    Standard_Complex_Linear_Solvers.lufac(A,bigdim,ipvt,info);
    Standard_Complex_Linear_Solvers.lusolve(A,bigdim,ipvt,b);
    if verbose then
      put_line("The solution vector :"); put_line(b);
    end if;
    res.deg := deg;
    for k in 0..deg loop
      for i in 1..dim loop
        wrk(i) := b(k*deg+i);
      end loop;
      res.cff(k) := new Standard_Complex_Vectors.Vector'(wrk);
    end loop;
    return res;
  end Hermite_Interpolate;

end Standard_Interpolating_Series;
