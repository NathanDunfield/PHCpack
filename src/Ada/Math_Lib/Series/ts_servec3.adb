with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Vectors;
with Standard_Random_Vectors;
with Standard_Complex_Series;
with Standard_Complex_Series_io;         use Standard_Complex_Series_io;
with DoblDobl_Complex_Series;
with DoblDobl_Complex_Series_io;         use DoblDobl_Complex_Series_io;
with QuadDobl_Complex_Series;
with QuadDobl_Complex_Series_io;         use QuadDobl_Complex_Series_io;
with Standard_Complex_Series_Vectors;
with Standard_Complex_Series_Vectors_io; use Standard_Complex_Series_Vectors_io;
with Standard_Complex_Series_VecVecs;
with DoblDobl_Complex_Series_Vectors;
with DoblDobl_Complex_Series_Vectors_io; use DoblDobl_Complex_Series_Vectors_io;
with DoblDobl_Complex_Series_VecVecs;
with QuadDobl_Complex_Series_Vectors;
with QuadDobl_Complex_Series_Vectors_io; use QuadDobl_Complex_Series_Vectors_io;
with QuadDobl_Complex_Series_VecVecs;
with Standard_Complex_Vector_Series;
with Standard_Complex_Vector_Series_io;  use Standard_Complex_Vector_Series_io;
with DoblDobl_Complex_Vector_Series;
with DoblDobl_Complex_Vector_Series_io;  use DoblDobl_Complex_Vector_Series_io;
with QuadDobl_Complex_Vector_Series;
with QuadDobl_Complex_Vector_Series_io;  use QuadDobl_Complex_Vector_Series_io;
with Standard_Series_Vector_Norms3;
with DoblDobl_Series_Vector_Norms3;
with QuadDobl_Series_Vector_Norms3;
with Standard_Random_Series_Vectors;
with DoblDobl_Random_Series_Vectors;
with QuadDobl_Random_Series_Vectors;

procedure ts_servec3 is

-- DESCRIPTION :
--   Test on vectors of truncated power series.

  procedure Write ( v : in Standard_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Writes the components of the vector to standard output.
 
  begin
    for i in v'range loop
      put("Component "); put(i,1); put_line(" :");
      put(v(i));
    end loop;
  end Write;

  procedure Write ( v : in DoblDobl_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Writes the components of the vector to standard output.
 
  begin
    for i in v'range loop
      put("Component "); put(i,1); put_line(" :");
      put(v(i));
    end loop;
  end Write;

  procedure Write ( v : in QuadDobl_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Writes the components of the vector to standard output.
 
  begin
    for i in v'range loop
      put("Component "); put(i,1); put_line(" :");
      put(v(i));
    end loop;
  end Write;

  procedure Standard_Test_Norm 
              ( v : in Standard_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Test on normalization of the vector v.

    use Standard_Complex_Series;
    use Standard_Complex_Series_Vectors;
    use Standard_Series_Vector_Norms3;

    sn : constant Series := Norm(v);
    snv : Series(sn.deg);
    nv : Vector(v'range);

  begin
    new_line;
    put_line("The norm of v : "); put(sn);
    nv := Normalize(v);
    put_line("The normalized vector : "); Write(nv);
    snv := Square_of_Norm(nv);
    put_line("Square of norm of normalized vector :"); put(snv);
  end Standard_Test_Norm;

  procedure DoblDobl_Test_Norm 
              ( v : in DoblDobl_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Test on normalization of the vector v.

    use DoblDobl_Complex_Series;
    use DoblDobl_Complex_Series_Vectors;
    use DoblDobl_Series_Vector_Norms3;

    sn : constant Series := Norm(v);
    snv : Series(sn.deg);
    nv : Vector(v'range);

  begin
    new_line;
    put_line("The norm of v : "); put(sn);
    nv := Normalize(v);
    put_line("The normalized vector : "); Write(nv);
    snv := Square_of_Norm(nv);
    put_line("Square of norm of normalized vector :"); put(snv);
  end DoblDobl_Test_Norm;

  procedure QuadDobl_Test_Norm 
              ( v : in QuadDobl_Complex_Series_Vectors.Vector ) is

  -- DESCRIPTION :
  --   Test on normalization of the vector v.

    use QuadDobl_Complex_Series;
    use QuadDobl_Complex_Series_Vectors;
    use QuadDobl_Series_Vector_Norms3;

    sn : constant Series := Norm(v);
    snv : Series(sn.deg);
    nv : Vector(v'range);

  begin
    new_line;
    put_line("The norm of v : "); put(sn);
    nv := Normalize(v);
    put_line("The normalized vector : "); Write(nv);
    snv := Square_of_Norm(nv);
    put_line("Square of norm of normalized vector :"); put(snv);
  end QuadDobl_Test_Norm;

  procedure Standard_Test ( dim,degree : in integer32 ) is

  -- DESCRIPTION :
  --   Generates a random vector of range 1..dim,
  --   with series of the given degree, in standard double precision.
  --   Tests the computation of the norm and the normalization.

    sv : Standard_Complex_Series_Vectors.Vector(1..dim)
       := Standard_Random_Series_Vectors.Random_Series_Vector(1,dim,degree);
    vs : Standard_Complex_Vector_Series.Vector(degree)
       := Standard_Complex_Vector_Series.Create(sv);

  begin
    Write(sv);
    put_line("The coefficients of the vector series :"); put(vs);
    Standard_Test_Norm(sv);
  end Standard_Test;

  procedure DoblDobl_Test ( dim,degree : in integer32 ) is

  -- DESCRIPTION :
  --   Generates a random vector of range 1..dim,
  --   with series of the given degree, in double double precision.
  --   Tests the computation of the norm and the normalization.

    sv : DoblDobl_Complex_Series_Vectors.Vector(1..dim)
       := DoblDobl_Random_Series_Vectors.Random_Series_Vector(1,dim,degree);
    vs : DoblDobl_Complex_Vector_Series.Vector(degree)
       := DoblDobl_Complex_Vector_Series.Create(sv);

  begin
    Write(sv);
    put_line("The coefficients of the vector series :"); put(vs);
    DoblDobl_Test_Norm(sv);
  end DoblDobl_Test;

  procedure QuadDobl_Test ( dim,degree : in integer32 ) is

  -- DESCRIPTION :
  --   Generates a random vector of range 1..dim,
  --   with series of the given degree, in double double precision.
  --   Tests the computation of the norm and the normalization.

    sv : QuadDobl_Complex_Series_Vectors.Vector(1..dim)
       := QuadDobl_Random_Series_Vectors.Random_Series_Vector(1,dim,degree);
    vs : QuadDobl_Complex_Vector_Series.Vector(degree)
       := QuadDobl_Complex_Vector_Series.Create(sv);

  begin
    Write(sv);
    put_line("The coefficients of the vector series :"); put(vs);
    QuadDobl_Test_Norm(sv);
  end QuadDobl_Test;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts the user for a dimension, and degree
  --   and then generates a random vector.

    dim,degree : integer32 := 0;
    ans : character;

  begin
    new_line;
    put("Give the dimension : "); get(dim);
    put("Give the degree : "); get(degree);
    new_line;
    put_line("MENU to select the working precision :");
    put_line("  0. standard double precision;");
    put_line("  1. double double precision; or");
    put_line("  2. quad double precision.");
    put("Type 0, 1, or 2 to select the precision : ");
    Ask_Alternative(ans,"012");
    new_line;
    case ans is
      when '0' => Standard_Test(dim,degree);
      when '1' => DoblDobl_Test(dim,degree);
      when '2' => QuadDobl_Test(dim,degree);
      when others => null;
    end case;
  end Main;

begin
  Main;
end ts_servec3;
