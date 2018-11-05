with QuadDobl_Complex_Linear_Solvers;    use QuadDobl_Complex_Linear_Solvers;
with QuadDobl_Complex_QR_Least_Squares;  use QuadDobl_Complex_QR_Least_Squares;
with QuadDobl_Complex_Singular_Values;   use QuadDobl_Complex_Singular_Values;
with QuadDobl_Interpolating_Series3;
with QuadDobl_Echelon_Forms;             use QuadDobl_Echelon_Forms;

package body QuadDobl_Series_Matrix_Solvers is

  procedure Solve_Lead_by_lufac
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                a0lu : out QuadDobl_Complex_Matrices.Matrix;
                ipvt : out Standard_Integer_Vectors.Vector;
                info : out integer32;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    lead : constant QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(0);
    dim : constant integer32 := lead'last(1);
    x0 : QuadDobl_Complex_Vectors.Vector(1..dim) := b.cff(0).all;

  begin
    a0lu := lead.all;
    lufac(a0lu,dim,ipvt,info);
    if info = 0 then
      lusolve(a0lu,dim,ipvt,x0);
      x.cff(0) := new QuadDobl_Complex_Vectors.Vector'(x0);
    end if;
  end Solve_Lead_by_lufac;

  procedure Solve_Lead_by_lufco
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                a0lu : out QuadDobl_Complex_Matrices.Matrix;
                ipvt : out Standard_Integer_Vectors.Vector;
                rcond : out quad_double;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    lead : constant QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(0);
    dim : constant integer32 := lead'last(1);
    x0 : QuadDobl_Complex_Vectors.Vector(1..dim) := b.cff(0).all;
    one : constant quad_double := create(1.0);

  begin
    a0lu := lead.all;
    lufco(a0lu,dim,ipvt,rcond);
    if one + rcond /= one then
      lusolve(a0lu,dim,ipvt,x0);
      x.cff(0) := new QuadDobl_Complex_Vectors.Vector'(x0);
    end if;
  end Solve_Lead_by_lufco;

  procedure Solve_Lead_by_QRLS
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                a0qr : out QuadDobl_Complex_Matrices.Matrix;
                qraux : out QuadDobl_Complex_Vectors.Vector;
                ipvt : out Standard_Integer_Vectors.Vector;
                info : out integer32;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    lead : constant QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(0);
    nrows : constant integer32 := lead'last(1);
    ncols : constant integer32 := lead'last(2);
    b0 : constant QuadDobl_Complex_Vectors.Vector(1..nrows) := b.cff(0).all;
    x0 : QuadDobl_Complex_Vectors.Vector(1..ncols);
    rsd,dum,dum2,dum3 : QuadDobl_Complex_Vectors.Vector(1..nrows);
    wrk : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols);
    zero : constant quad_double := create(0.0);

  begin
    a0qr := lead.all;
    qraux := (qraux'range => Create(zero));
    ipvt := (ipvt'range => 0);
    QRD(a0qr,qraux,ipvt,false);
    wrk := a0qr;
    QRLS(wrk,nrows,ncols,qraux,b0,dum2,dum3,x0,rsd,dum,110,info);
    x.cff(0) := new QuadDobl_Complex_Vectors.Vector'(x0);
  end Solve_Lead_by_QRLS;

  procedure Solve_Lead_by_SVD
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                S : out QuadDobl_Complex_Vectors.Vector;
                U,V : out QuadDobl_Complex_Matrices.Matrix;
                info : out integer32; rcond : out quad_double;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    lead : constant QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(0);
    n : constant integer32 := lead'last(1);
    p : constant integer32 := lead'last(2);
    wrk : QuadDobl_Complex_Matrices.Matrix(1..n,1..p) := lead.all;
    e : QuadDobl_Complex_Vectors.Vector(1..p);
    job : constant integer32 := 11;
    b0 : constant QuadDobl_Complex_Vectors.Vector(1..n) := b.cff(0).all;
    x0 : QuadDobl_Complex_Vectors.Vector(1..p);

  begin
    SVD(wrk,n,p,S,e,U,V,job,info);
    rcond := Inverse_Condition_Number(S);
    x0 := Solve(U,V,S,b0);
    x.cff(0) := new QuadDobl_Complex_Vectors.Vector'(x0);
  end Solve_Lead_by_SVD;

  procedure Solve_Next_by_lusolve
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                a0lu : in QuadDobl_Complex_Matrices.Matrix;
                ipvt : in Standard_Integer_Vectors.Vector;
                idx : in integer32;
                x : in out QuadDobl_Complex_Vector_Series.Vector ) is

    use QuadDobl_Complex_Vectors;
    use QuadDobl_Complex_Matrices;

    Aidx : QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(idx);
    dim : constant integer32 := Aidx'last(1);
    wA : QuadDobl_Complex_Matrices.Matrix(1..dim,1..dim) := Aidx.all;
    wb : QuadDobl_Complex_Vectors.Vector(1..dim) := b.cff(idx).all;
    wx : QuadDobl_Complex_Vectors.Vector(1..dim) := x.cff(0).all;

  begin
    wb := wb - wA*wx;
    for k in 1..(idx-1) loop
      Aidx := A.cff(idx-k);
      wA := Aidx.all;
      wx := x.cff(k).all;
      wb := wb - wA*wx;
    end loop;
    lusolve(a0lu,dim,ipvt,wb);
    x.cff(idx) := new QuadDobl_Complex_Vectors.Vector'(wb);
  end Solve_Next_by_lusolve;

  procedure Solve_Next_by_QRLS
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                a0qr : in QuadDobl_Complex_Matrices.Matrix;
                qraux : in QuadDobl_Complex_Vectors.Vector;
                idx : in integer32; info : out integer32;
                x : in out QuadDobl_Complex_Vector_Series.Vector ) is

    use QuadDobl_Complex_Vectors;
    use QuadDobl_Complex_Matrices;

    Aidx : QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(idx);
    nrows : constant integer32 := Aidx'last(1);
    ncols : constant integer32 := Aidx'last(2);
    wA : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols) := Aidx.all;
    wb : QuadDobl_Complex_Vectors.Vector(1..nrows) := b.cff(idx).all;
    wx : QuadDobl_Complex_Vectors.Vector(1..ncols) := x.cff(0).all;
    rsd,dum,dum2,dum3 : QuadDobl_Complex_Vectors.Vector(1..nrows);
    wrk : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols) := a0qr;

  begin
    wb := wb - wA*wx;
    for k in 1..(idx-1) loop
      Aidx := A.cff(idx-k);
      wA := Aidx.all;
      wx := x.cff(k).all;
      wb := wb - wA*wx;
    end loop;
    QRLS(wrk,nrows,ncols,qraux,wb,dum2,dum3,wx,rsd,dum,110,info);
    x.cff(idx) := new QuadDobl_Complex_Vectors.Vector'(wx);
  end Solve_Next_by_QRLS;

  procedure Solve_Next_by_SVD
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                S : in QuadDobl_Complex_Vectors.Vector;
                U,V : in QuadDobl_Complex_Matrices.Matrix;
                idx : in integer32;
                x : in out QuadDobl_Complex_Vector_Series.Vector ) is

    use QuadDobl_Complex_Vectors;
    use QuadDobl_Complex_Matrices;

    Aidx : QuadDobl_Complex_Matrices.Link_to_Matrix := A.cff(idx);
    nrows : constant integer32 := Aidx'last(1);
    ncols : constant integer32 := Aidx'last(2);
    wA : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols) := Aidx.all;
    wb : QuadDobl_Complex_Vectors.Vector(1..nrows) := b.cff(idx).all;
    wx : QuadDobl_Complex_Vectors.Vector(1..ncols) := x.cff(0).all;

  begin
    wb := wb - wA*wx;
    for k in 1..(idx-1) loop
      Aidx := A.cff(idx-k);
      wA := Aidx.all;
      wx := x.cff(k).all;
      wb := wb - wA*wx;
    end loop;
    wx := Solve(U,V,S,wb);
    x.cff(idx) := new QuadDobl_Complex_Vectors.Vector'(wx);
  end Solve_Next_by_SVD;

  procedure Solve_by_lufac
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                info : out integer32;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    dim : constant integer32 := A.cff(0)'last;
    lwrk : QuadDobl_Complex_Matrices.Matrix(1..dim,1..dim);
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
   
  begin
    Solve_Lead_by_lufac(A,b,lwrk,ipvt,info,x);
    if info = 0 then
      for k in 1..b.deg loop
        Solve_Next_by_lusolve(A,b,lwrk,ipvt,k,x);
      end loop;
    end if;
  end Solve_by_lufac;

  procedure Solve_by_lufco
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                rcond : out quad_double;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    dim : constant integer32 := A.cff(0)'last;
    lwrk : QuadDobl_Complex_Matrices.Matrix(1..dim,1..dim);
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    one : constant quad_double := Create(1.0);
   
  begin
    Solve_Lead_by_lufco(A,b,lwrk,ipvt,rcond,x);
    if one + rcond /= one then
      for k in 1..b.deg loop
        Solve_Next_by_lusolve(A,b,lwrk,ipvt,k,x);
      end loop;
    end if;
  end Solve_by_lufco;

  procedure Solve_by_QRLS
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                info : out integer32;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    nrows : constant integer32 := A.cff(0)'last(1);
    ncols : constant integer32 := A.cff(0)'last(2);
    lwrk : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols);
    qraux : QuadDobl_Complex_Vectors.Vector(1..ncols);
    ipvt : Standard_Integer_Vectors.Vector(1..ncols);

  begin
    Solve_Lead_by_QRLS(A,b,lwrk,qraux,ipvt,info,x);
    if info = 0 then
      for k in 1..b.deg loop
        Solve_Next_by_QRLS(A,b,lwrk,qraux,k,info,x);
      end loop;
    end if;
  end Solve_by_QRLS;

  procedure Solve_by_SVD
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                info : out integer32; rcond : out quad_double;
                x : out QuadDobl_Complex_Vector_Series.Vector ) is

    nrows : constant integer32 := A.cff(0)'last(1);
    ncols : constant integer32 := A.cff(0)'last(2);
    mm : constant integer32
       := QuadDobl_Complex_Singular_Values.Min0(nrows+1,ncols);
    S : QuadDobl_Complex_Vectors.Vector(1..mm);
    U : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..nrows);
    V : QuadDobl_Complex_Matrices.Matrix(1..ncols,1..ncols);
    one : constant quad_double := create(1.0);

  begin
    Solve_Lead_by_SVD(A,b,S,U,V,info,rcond,x);
    if one + rcond /= one then
      for k in 1..b.deg loop
        Solve_Next_by_SVD(A,b,S,U,V,k,x);
      end loop;
    end if;
  end Solve_by_SVD;

  procedure Echelon_Solve
              ( A : in QuadDobl_Complex_Matrix_Series.Matrix;
                b : in QuadDobl_Complex_Vector_Series.Vector;
                det : out Complex_Number;
                xp : out QuadDobl_Complex_Vector_Series.Vector;
                xn : out QuadDobl_Complex_Vector_Series.Vector ) is

    deg : constant integer32 := A.deg;
    nbr : constant integer32 := A.cff(0)'last(1);
    nbc : constant integer32 := A.cff(0)'last(2);
    nrows : constant integer32 := nbr*(2*deg+1);
    ncols : constant integer32 := nbc*(2*deg+1);
    hlm : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols)
        := QuadDobl_Interpolating_Series3.Hermite_Laurent_Matrix(A.cff(0..deg));
    x : QuadDobl_Complex_Vectors.Vector(1..ncols);
    rhs : QuadDobl_Complex_Vectors.Vector(1..nrows)
        := QuadDobl_Interpolating_Series3.Hermite_Laurent_Vector(b.cff(0..deg));
    U : QuadDobl_Complex_Matrices.Matrix(1..nrows,1..ncols);
    row_ipvt : Standard_Integer_Vectors.Vector(1..nrows);
    col_ipvt,pivots : Standard_Integer_Vectors.Vector(1..ncols);
    wx : QuadDobl_Complex_Vectors.Vector(1..nbc);
    startidx : constant integer32 := nbc*deg; -- space for Laurent portion
    one : constant quad_double := create(1.0);
    absdet : quad_double;

  begin
    Lower_Triangular_Echelon_Form(nbc,hlm,U,row_ipvt,col_ipvt,pivots,false);
    Solve_with_Echelon_Form(hlm,rhs,x);
    Multiply_and_Permute(x,U,pivots);
    det := Determinant(hlm);
    absdet := AbsVal(det);
   -- xp.deg := deg;
    for i in 0..deg loop
      for j in 1..nbc loop
        wx(j) := x(startidx+i*nbc+j);
      end loop;
      xp.cff(i) := new QuadDobl_Complex_Vectors.Vector'(wx);
    end loop;
   -- if absdet + 1.0 /= 1.0 then
   --   xn.deg := -1; -- no Laurent portion
   -- else
    if absdet + one = one then
      for i in 1..deg loop
        for j in 1..nbc loop
          wx(j) := x(startidx-i*nbc+j);
        end loop;
        xn.cff(i) := new QuadDobl_Complex_Vectors.Vector'(wx);
      end loop;
    end if;
  end Echelon_Solve;

end QuadDobl_Series_Matrix_Solvers;
