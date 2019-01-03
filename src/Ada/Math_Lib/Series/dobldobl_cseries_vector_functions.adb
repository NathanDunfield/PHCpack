with DoblDobl_Complex_Series_Functions;

package body DoblDobl_CSeries_Vector_Functions is

  function Eval ( v : DoblDobl_Complex_Series_Vectors.Vector;
                  t : double_double )
                return DoblDobl_Complex_Vectors.Vector is

    res : DoblDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := DoblDobl_Complex_Series_Functions.Eval(v(k),t);
    end loop;
    return res;
  end Eval;

  function Eval ( v : DoblDobl_Complex_Series_Vectors.Vector;
                  t : Complex_Number )
                return DoblDobl_Complex_Vectors.Vector is

    res : DoblDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := DoblDobl_Complex_Series_Functions.Eval(v(k),t);
    end loop;
    return res;
  end Eval;

  function Eval ( v : DoblDobl_Complex_Series_Vectors.Vector;
                  w : Standard_Integer_Vectors.Vector;
                  t : double_double )
                return DoblDobl_Complex_Vectors.Vector is

    res : DoblDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := DoblDobl_Complex_Series_Functions.Eval(v(k),t,w(k),w(w'last));
    end loop;
    return res;
  end Eval;

  function Eval ( v : DoblDobl_Complex_Series_Vectors.Vector;
                  w : Standard_Integer_Vectors.Vector;
                  t : Complex_Number )
                return DoblDobl_Complex_Vectors.Vector is

    res : DoblDobl_Complex_Vectors.Vector(v'range);

  begin
    for k in v'range loop
      res(k) := DoblDobl_Complex_Series_Functions.Eval(v(k),t,w(k),w(w'last));
    end loop;
    return res;
  end Eval;

  function Shift ( v : DoblDobl_Complex_Series_Vectors.Vector;
                   c : double_double )
                 return DoblDobl_Complex_Series_Vectors.Vector is

    res : DoblDobl_Complex_Series_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := DoblDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
    return res;
  end Shift;

  function Shift ( v : DoblDobl_Complex_Series_Vectors.Vector;
                   c : Complex_Number )
                 return DoblDobl_Complex_Series_Vectors.Vector is

    res : DoblDobl_Complex_Series_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := DoblDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
    return res;
  end Shift;

  function Shift ( v : DoblDobl_Complex_Series_VecVecs.VecVec;
                   c : double_double )
                 return DoblDobl_Complex_Series_VecVecs.VecVec is

    res : DoblDobl_Complex_Series_VecVecs.VecVec(v'range);

    use DoblDobl_Complex_Series_Vectors;

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

  function Shift ( v : DoblDobl_Complex_Series_VecVecs.VecVec;
                   c : Complex_Number )
                 return DoblDobl_Complex_Series_VecVecs.VecVec is

    res : DoblDobl_Complex_Series_VecVecs.VecVec(v'range);

    use DoblDobl_Complex_Series_Vectors;

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

  procedure Shift ( v : in out DoblDobl_Complex_Series_Vectors.Vector;
                    c : in double_double ) is
  begin
    for i in v'range loop
      DoblDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
  end Shift;

  procedure Shift ( v : in out DoblDobl_Complex_Series_Vectors.Vector;
                    c : in Complex_Number ) is
  begin
    for i in v'range loop
      DoblDobl_Complex_Series_Functions.Shift(v(i),c);
    end loop;
  end Shift;

  procedure Shift ( v : in out DoblDobl_Complex_Series_VecVecs.VecVec;
                    c : in double_double ) is

    use DoblDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null
       then Shift(v(i).all,c);
      end if;
    end loop;
  end Shift;

  procedure Shift ( v : in out DoblDobl_Complex_Series_VecVecs.VecVec;
                    c : in Complex_Number ) is

    use DoblDobl_Complex_Series_Vectors;

  begin
    for i in v'range loop
      if v(i) /= null
       then Shift(v(i).all,c);
      end if;
    end loop;
  end Shift;

end DoblDobl_CSeries_Vector_Functions;
