with QuadDobl_Complex_Series;
with QuadDobl_Complex_Series_Functions;

package body QuadDobl_CSeries_Vector_Functions is

  function Eval ( v : QuadDobl_Complex_Series_Vectors.Vector;
                  t : quad_double )
                return QuadDobl_Complex_Vectors.Vector is

    res : QuadDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := QuadDobl_Complex_Series_Functions.Eval(v(k),t);
    end loop;
    return res;
  end Eval;

  function Eval ( v : QuadDobl_Complex_Series_Vectors.Vector;
                  t : Complex_Number )
                return QuadDobl_Complex_Vectors.Vector is

    res : QuadDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := QuadDobl_Complex_Series_Functions.Eval(v(k),t);
    end loop;
    return res;
  end Eval;

  function Eval ( v : QuadDobl_Complex_Series_Vectors.Vector;
                  w : Standard_Integer_Vectors.Vector;
                  t : quad_double )
                return QuadDobl_Complex_Vectors.Vector is

    res : QuadDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := QuadDobl_Complex_Series_Functions.Eval(v(k),t,w(k),w(w'last));
    end loop;
    return res;
  end Eval;

  function Eval ( v : QuadDobl_Complex_Series_Vectors.Vector;
                  w : Standard_Integer_Vectors.Vector;
                  t : Complex_Number )
                return QuadDobl_Complex_Vectors.Vector is

    res : QuadDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := QuadDobl_Complex_Series_Functions.Eval(v(k),t,w(k),w(w'last));
    end loop;
    return res;
  end Eval;

  function Shift ( v : QuadDobl_Complex_Series_Vectors.Vector;
                   c : quad_double )
                 return QuadDobl_Complex_Series_Vectors.Vector is

    res : QuadDobl_Complex_Series_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := QuadDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
    return res;
  end Shift;

  function Shift ( v : QuadDobl_Complex_Series_Vectors.Vector;
                   c : Complex_Number )
                 return QuadDobl_Complex_Series_Vectors.Vector is

    res : QuadDobl_Complex_Series_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := QuadDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
    return res;
  end Shift;

  function Shift ( v : QuadDobl_Complex_Series_VecVecs.VecVec;
                   c : quad_double )
                 return QuadDobl_Complex_Series_VecVecs.VecVec is

    res : QuadDobl_Complex_Series_VecVecs.VecVec(v'range);

    use QuadDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null then
        declare
          svi : constant Vector := Shift(v(i).all,c);
        begin
          res(i) := new Vector'(svi); 
        end;
      end if;
    end loop;
    return res;
  end Shift;

  function Shift ( v : QuadDobl_Complex_Series_VecVecs.VecVec;
                   c : Complex_Number )
                 return QuadDobl_Complex_Series_VecVecs.VecVec is

    res : QuadDobl_Complex_Series_VecVecs.VecVec(v'range);

    use QuadDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null then
        declare
          svi : constant Vector := Shift(v(i).all,c);
        begin
          res(i) := new Vector'(svi); 
        end;
      end if;
    end loop;
    return res;
  end Shift;

  procedure Shift ( v : in out QuadDobl_Complex_Series_Vectors.Vector;
                    c : in quad_double ) is
  begin
    for i in v'range loop
      QuadDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
  end Shift;

  procedure Shift ( v : in out QuadDobl_Complex_Series_Vectors.Vector;
                    c : in Complex_Number ) is
  begin
    for i in v'range loop
      QuadDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
  end Shift;

  procedure Shift ( v : in out QuadDobl_Complex_Series_VecVecs.VecVec;
                    c : in quad_double ) is

    use QuadDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null
       then Shift(v(i).all,c);
      end if;
    end loop;
  end Shift;

  procedure Shift ( v : in out QuadDobl_Complex_Series_VecVecs.VecVec;
                    c : in Complex_Number ) is

    use QuadDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null
       then Shift(v(i).all,c);
      end if;
    end loop;
  end Shift;

  function Make_Deep_Copy
             ( v : QuadDobl_Complex_Series_Vectors.Vector )
             return QuadDobl_Complex_Series_Vectors.Vector is

    res : QuadDobl_Complex_Series_Vectors.Vector(v'range);

    use QuadDobl_Complex_Series;

  begin
    for i in v'range loop
      res(i) := new Series'(Create(v(i).all,v(i).deg));
    end loop;
    return res;
  end Make_Deep_Copy;

  function Make_Deep_Copy
             ( v : QuadDobl_Complex_Series_VecVecs.VecVec )
             return QuadDobl_Complex_Series_VecVecs.VecVec is

    res : QuadDobl_Complex_Series_VecVecs.VecVec(v'range);

    use QuadDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null then
        declare
          cp : constant QuadDobl_Complex_Series_Vectors.Vector(v(i)'range)
             := Make_Deep_Copy(v(i).all);
        begin
          res(i) := new QuadDobl_Complex_Series_Vectors.Vector'(cp);
        end;
      end if;
    end loop;
    return res;
  end Make_Deep_Copy;

end QuadDobl_CSeries_Vector_Functions;
