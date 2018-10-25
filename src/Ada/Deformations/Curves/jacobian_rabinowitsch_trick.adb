with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Double_Double_Numbers;             use Double_Double_Numbers;
with Quad_Double_Numbers;               use Quad_Double_Numbers;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;
with Standard_Natural_Vectors;
with Standard_Complex_Vectors;
with DoblDobl_Complex_Vectors;
with QuadDobl_Complex_Vectors;
with Standard_Random_Vectors;
with DoblDobl_Random_Vectors;
with QuadDobl_Random_Vectors;
with Standard_Embed_Polynomials;
with DoblDobl_Embed_Polynomials;
with QuadDobl_Embed_Polynomials;
with Standard_Deflate_Singularities;
with DoblDobl_Deflate_Singularities;
with QuadDobl_Deflate_Singularities;

package body Jacobian_Rabinowitsch_Trick is

  function Identity_Matrix
              ( n : integer32 ) return Standard_Complex_Matrices.Matrix is

    res : Standard_Complex_Matrices.Matrix(1..n,1..n);

  begin
    for i in 1..n loop
      for j in 1..n loop
        if i = j
         then res(i,j) := Standard_Complex_Numbers.Create(1.0);
         else res(i,j) := Standard_Complex_Numbers.Create(0.0);
        end if;
      end loop;
    end loop;
    return res;
  end Identity_Matrix;

  function Identity_Matrix
              ( n : integer32 ) return DoblDobl_Complex_Matrices.Matrix is

    res : DoblDobl_Complex_Matrices.Matrix(1..n,1..n);
    one : constant double_double := create(1.0);
    zero : constant double_double := create(0.0);

  begin
    for i in 1..n loop
      for j in 1..n loop
        if i = j
         then res(i,j) := DoblDobl_Complex_Numbers.Create(one);
         else res(i,j) := DoblDobl_Complex_Numbers.Create(zero);
        end if;
      end loop;
    end loop;
    return res;
  end Identity_Matrix;

  function Identity_Matrix
              ( n : integer32 ) return QuadDobl_Complex_Matrices.Matrix is

    res : QuadDobl_Complex_Matrices.Matrix(1..n,1..n);
    one : constant quad_double := create(1.0);
    zero : constant quad_double := create(0.0);

  begin
    for i in 1..n loop
      for j in 1..n loop
        if i = j
         then res(i,j) := QuadDobl_Complex_Numbers.Create(one);
         else res(i,j) := QuadDobl_Complex_Numbers.Create(zero);
        end if;
      end loop;
    end loop;
    return res;
  end Identity_Matrix;

  procedure Add_Last_Multiplier
              ( p : in out Standard_Complex_Polynomials.Poly;
                d : in integer32 ) is

    t : Standard_Complex_Polynomials.Term;

  begin
    t.cf := Standard_Complex_Numbers.Create(1.0);
    t.dg := new Standard_Natural_Vectors.Vector'(1..d => 0);
    t.dg(d) := 1;
    Standard_Complex_Polynomials.Mul(p,t);
    t.dg(d) := 0;
    Standard_Complex_Polynomials.Sub(p,t);
    Standard_Complex_Polynomials.Clear(t);
  end Add_Last_Multiplier;

  procedure Add_Last_Multiplier
              ( p : in out DoblDobl_Complex_Polynomials.Poly;
                d : in integer32 ) is

    t : DoblDobl_Complex_Polynomials.Term;
    one : constant double_double := create(1.0);

  begin
    t.cf := DoblDobl_Complex_Numbers.Create(one);
    t.dg := new Standard_Natural_Vectors.Vector'(1..d => 0);
    t.dg(d) := 1;
    DoblDobl_Complex_Polynomials.Mul(p,t);
    t.dg(d) := 0;
    DoblDobl_Complex_Polynomials.Sub(p,t);
    DoblDobl_Complex_Polynomials.Clear(t);
  end Add_Last_Multiplier;

  procedure Add_Last_Multiplier
              ( p : in out QuadDobl_Complex_Polynomials.Poly;
                d : in integer32 ) is

    t : QuadDobl_Complex_Polynomials.Term;
    one : constant quad_double := create(1.0);

  begin
    t.cf := QuadDobl_Complex_Numbers.Create(one);
    t.dg := new Standard_Natural_Vectors.Vector'(1..d => 0);
    t.dg(d) := 1;
    QuadDobl_Complex_Polynomials.Mul(p,t);
    t.dg(d) := 0;
    QuadDobl_Complex_Polynomials.Sub(p,t);
    QuadDobl_Complex_Polynomials.Clear(t);
  end Add_Last_Multiplier;

  function Jacobian_Rabinowitsch
              ( p : Standard_Complex_Poly_Systems.Poly_Sys )
              return Standard_Complex_Poly_Systems.Poly_Sys is

    nvar : constant natural32
         := Standard_Complex_Polynomials.Number_of_Unknowns(p(p'first));
    dim : constant integer32 := integer32(nvar);
    idm : constant Standard_Complex_Matrices.Matrix(1..dim,1..dim)
        := Identity_Matrix(dim);
    cff : constant Standard_Complex_Vectors.Vector(1..dim)
        := Standard_Random_Vectors.Random_Vector(1,dim);
    defres : Standard_Complex_Poly_Systems.Poly_Sys
           := Standard_Deflate_Singularities.Deflate(p,nvar,idm,cff);
    res : Standard_Complex_Poly_Systems.Poly_Sys(defres'range);
    resdim : constant integer32 := 2*dim+1;

  begin
    res := Standard_Embed_Polynomials.Add_Variables(defres,1);
    Add_Last_Multiplier(res(res'last),resdim);
    return res;
  end Jacobian_Rabinowitsch;

  function Jacobian_Rabinowitsch
              ( p : DoblDobl_Complex_Poly_Systems.Poly_Sys )
              return DoblDobl_Complex_Poly_Systems.Poly_Sys is

    nvar : constant natural32
         := DoblDobl_Complex_Polynomials.Number_of_Unknowns(p(p'first));
    dim : constant integer32 := integer32(nvar);
    idm : constant DoblDobl_Complex_Matrices.Matrix(1..dim,1..dim)
        := Identity_Matrix(dim);
    cff : constant DoblDobl_Complex_Vectors.Vector(1..dim)
        := DoblDobl_Random_Vectors.Random_Vector(1,dim);
    defres : DoblDobl_Complex_Poly_Systems.Poly_Sys
           := DoblDobl_Deflate_Singularities.Deflate(p,nvar,idm,cff);
    res : DoblDobl_Complex_Poly_Systems.Poly_Sys(defres'range);
    resdim : constant integer32 := 2*dim+1;

  begin
    res := DoblDobl_Embed_Polynomials.Add_Variables(defres,1);
    Add_Last_Multiplier(res(res'last),resdim);
    return res;
  end Jacobian_Rabinowitsch;

  function Jacobian_Rabinowitsch
              ( p : QuadDobl_Complex_Poly_Systems.Poly_Sys )
              return QuadDobl_Complex_Poly_Systems.Poly_Sys is

    nvar : constant natural32
         := QuadDobl_Complex_Polynomials.Number_of_Unknowns(p(p'first));
    dim : constant integer32 := integer32(nvar);
    idm : constant QuadDobl_Complex_Matrices.Matrix(1..dim,1..dim)
        := Identity_Matrix(dim);
    cff : constant QuadDobl_Complex_Vectors.Vector(1..dim)
        := QuadDobl_Random_Vectors.Random_Vector(1,dim);
    defres : QuadDobl_Complex_Poly_Systems.Poly_Sys
           := QuadDobl_Deflate_Singularities.Deflate(p,nvar,idm,cff);
    res : QuadDobl_Complex_Poly_Systems.Poly_Sys(defres'range);
    resdim : constant integer32 := 2*dim+1;

  begin
    res := QuadDobl_Embed_Polynomials.Add_Variables(defres,1);
    Add_Last_Multiplier(res(res'last),resdim);
    return res;
  end Jacobian_Rabinowitsch;

end Jacobian_Rabinowitsch_Trick;
