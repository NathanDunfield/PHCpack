with text_io;                           use text_io;
with Interfaces.C;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Complex_Numbers_io;       use Standard_Complex_Numbers_io;
with Standard_Natural_Vectors;
with Standard_Integer_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_Polynomials;
with Standard_Complex_Poly_Systems;
with Standard_Complex_Poly_Systems_io;  use Standard_Complex_Poly_Systems_io;
with Assignments_in_Ada_and_C;          use Assignments_in_Ada_and_C;
with Standard_PolySys_Container;

function use_tabform ( job : integer32;
                       a : C_intarrs.Pointer;
                       b : C_intarrs.Pointer;
                       c : C_dblarrs.Pointer ) return integer32 is

  procedure Extract_Dimensions ( neq,nvr : out integer32 ) is

  -- DESCRIPTION :
  --   Extracts the dimensions out of the three numbers of a.

  -- ON RETURN :
  --   neq       the number of equations is in a[0];
  --   nvr       the number of variables is in a[1].

    v : constant C_Integer_Array
      := C_intarrs.Value(a,Interfaces.C.ptrdiff_t(2));

    use Interfaces.C;

  begin
    neq := integer32(v(v'first));
    nvr := integer32(v(v'first+1));
  end Extract_Dimensions;

  procedure Write_Tableau
              ( neq,nvr : in integer32;
                nbterms : in Standard_Integer_Vectors.Vector;
                coefficients : in Standard_Complex_Vectors.Vector;
                exponents : in Standard_Integer_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Writes the tableau form of a polynomial system.

  -- ON ENTRY :
  --   neq      the number of equations;
  --   nvr      the number of variables;
  --   nbterms  nbterms(k) is the number of terms in the k-th polynomial;
  --   exponents are the exponents of the monomials;
  --   coefficients are the coefficients of the terms.

    cffidx : integer32 := coefficients'first-1;
    expidx : integer32 := exponents'first-1;

  begin
    put(neq,1);
    if neq /= nvr
     then put("  "); put(nvr,1);
    end if;
    new_line;
    for i in nbterms'range loop
      put(nbterms(i),1); new_line;
      for j in 1..nbterms(i) loop
        cffidx := cffidx + 1;
        put(coefficients(cffidx));
        for k in 1..nvr loop
          expidx := expidx + 1;
          put(" "); put(exponents(expidx),1);
        end loop;
        new_line;
      end loop;
    end loop;
  end Write_Tableau;

  function Make_System
             ( neq,nvr : integer32;
               nbterms : Standard_Integer_Vectors.Vector;
               coefficients : Standard_Complex_Vectors.Vector;
               exponents : Standard_Integer_Vectors.Vector;
               verbose : boolean := false )
             return Standard_Complex_Poly_Systems.Poly_Sys is

  -- DESCRIPTION :
  --   Returns the polynomial system that corresponds
  --   to the give tableau form.

  -- ON ENTRY :
  --   neq      the number of equations;
  --   nvr      the number of variables;
  --   nbterms  nbterms(k) is the number of terms in the k-th polynomial;
  --   exponents are the exponents of the monomials;
  --   coefficients are the coefficients of the terms.

    res : Standard_Complex_Poly_Systems.Poly_Sys(1..neq);
    trm : Standard_Complex_Polynomials.Term;
    cffidx : integer32 := coefficients'first-1;
    expidx : integer32 := exponents'first-1;

  begin
    if verbose then
      put("-> the number of equations : "); put(neq,1); new_line;
      put("-> the number of variables : "); put(nvr,1); new_line;
    end if;
    trm.dg := new Standard_Natural_Vectors.Vector(1..nvr);
    for i in nbterms'range loop
      res(i) := Standard_Complex_Polynomials.Null_Poly;
      if verbose then
        put("-> the number of terms of polynomial ");
        put(i,1); put(" : "); put(nbterms(i),1); new_line;
      end if;
      for j in 1..nbterms(i) loop
        cffidx := cffidx + 1;
        trm.cf := coefficients(cffidx);
        if verbose
         then put(coefficients(cffidx));
        end if;
        for k in 1..nvr loop
          expidx := expidx + 1;
          trm.dg(k) := natural32(exponents(expidx));
          if verbose
           then put(" "); put(exponents(expidx),1);
          end if;
        end loop;
        Standard_Complex_Polynomials.Add(res(i),trm);
        if verbose
         then new_line;
        end if;
      end loop;
    end loop;
    return res;
  end Make_System;

  procedure Extract_Tableau
              ( neq,nvr,nbt : in integer32;
                nbterms : in Standard_Integer_Vectors.Vector;
                verbose : in boolean := false ) is

  -- DESCRIPTION :
  --   Extracts the coefficients and exponents from b and c.

    nbrexp : constant integer32 := nvr*nbt;
    nbrcff : constant integer32 := 2*nbt;
    expdata : Standard_Integer_Vectors.Vector(1..nbrexp);
    cffdata : Standard_Complex_Vectors.Vector(1..nbrcff);
    p : Standard_Complex_Poly_Systems.Poly_Sys(1..neq);

  begin
    Assign(natural32(nbrexp),b,expdata);
    Assign(natural32(nbrcff),c,cffdata);
    if verbose
     then Write_Tableau(neq,nvr,nbterms,cffdata,expdata);
    end if;
    p := Make_System(neq,nvr,nbterms,cffdata,expdata,verbose);
    if verbose then
      put_line("The polynomial system made from the tableau form :");
      put(p);
    end if;
    Standard_PolySys_Container.Initialize(p);
  end Extract_Tableau;

  function Job0 return integer32 is -- store tableau form

    neq,nvr,nbt : integer32;
    verbose : boolean;

  begin
    Extract_Dimensions(neq,nvr);
    declare
      dim : constant integer32 := 3+neq+1;
      dimdata : Standard_Integer_Vectors.Vector(1..dim);
      nbterms : Standard_Integer_Vectors.Vector(1..neq);
    begin
      Assign(natural32(dim),a,dimdata);
      verbose := (dimdata(dim) > 0);
      if verbose then
        put("-> the number of equations : "); put(neq,1); new_line;
        put("-> the number of variables : "); put(nvr,1); new_line;
      end if;
      for i in 1..neq loop
        nbterms(i) := dimdata(i+3);
      end loop;      
      nbt := Standard_Integer_Vectors.Sum(nbterms);
      if verbose then
        put("-> total number of terms : "); put(nbt,1); new_line;
        for i in 1..neq loop
          put("-> number of terms in polynomial ");
          put(i,1); put(" : "); put(nbterms(i),1); new_line;
        end loop;
      end if;
      Extract_Tableau(neq,nvr,nbt,nbterms,verbose);
    end;
    return 0;
  end Job0;

  function Handle_Jobs return integer32 is
  begin
    case job is
      when 0 => return Job0;
      when others => put_line("invalid operation"); return 1;
    end case;
  end Handle_Jobs;

begin
  return Handle_Jobs;
end use_tabform;
