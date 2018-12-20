with Standard_Integer_Numbers;          use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with QuadDobl_Complex_Numbers_io;       use QuadDobl_Complex_Numbers_io;
with Standard_Natural_Vectors;
with Standard_Natural_Vectors_io;       use Standard_Natural_Vectors_io;
with QuadDobl_Complex_Monomials;        use QuadDobl_Complex_Monomials;
with QuadDobl_Complex_Monomials_io;     use QuadDobl_Complex_Monomials_io;

package body QuadDobl_Monomial_Vectors_io is

  procedure put ( v : in Monomial_Vector ) is
  begin
    put(standard_output,v);
  end put;

  procedure put ( file : in file_type; v : in Monomial_Vector ) is

    e : Standard_Natural_Vectors.Vector(1..integer32(v(v'first).dim));

  begin
    put(file,"degree : "); put(file,Degree(v),1); new_line(file);
    Largest_Exponents(v,e);
    put(file,"largest exponents : "); put(file,e); new_line(file);
    for i in v'range loop
      if v(i) /= null then
        put(file,"-> monomial "); put(file,i,1); put_line(file," :");
        put(file,v(i).all);
      end if;
    end loop;
  end put;

  procedure put ( v : in Link_to_Monomial_Vector ) is
  begin
    put(standard_output,v);
  end put;

  procedure put ( file : in file_type; v : in Link_to_Monomial_Vector ) is
  begin
    if v /= null
     then put(file,v.all);
    end if;
  end put;

  procedure put ( p : in Polynomial ) is
  begin
    put(standard_output,p);
  end put;

  procedure put ( file : in file_type; p : in Polynomial ) is

    e : Standard_Natural_Vectors.Vector(1..p.dim);

  begin
    put(file,"degree : "); put(file,Degree(p),1); new_line(file);
    Largest_Exponents(p,e);
    put(file,"largest exponents : "); put(file,e); new_line(file);
    put_line(file,"-> monomial 0 : ");
    put(file,"coefficient : ");
    put(file,p.cff0); new_line(file);
    put(file,p.mons);
  end put;

  procedure put ( p : in Link_to_Polynomial ) is
  begin
    put(standard_output,p);
  end put;

  procedure put ( file : in file_type; p : in Link_to_Polynomial ) is
  begin
    if p /= null
     then put(file,p.all);
    end if;
  end put;

end QuadDobl_Monomial_Vectors_io;
