with DecaDobl_Complex_Numbers_cv;        use DecaDobl_Complex_Numbers_cv;

package body DecaDobl_Complex_Vectors_cv is

  function Standard_to_DecaDobl_Complex
             ( v : Standard_Complex_Vectors.Vector )
             return DecaDobl_Complex_Vectors.Vector is

    res : DecaDobl_Complex_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := Standard_to_DecaDobl_Complex(v(i));
    end loop;
    return res;
  end Standard_to_DecaDobl_Complex;

  function Multprec_to_DecaDobl_Complex
             ( v : Multprec_Complex_Vectors.Vector )
             return DecaDobl_Complex_Vectors.Vector is

    res : DecaDobl_Complex_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := Multprec_to_DecaDobl_Complex(v(i));
    end loop;
    return res;
  end Multprec_to_DecaDobl_Complex;

  function DecaDobl_Complex_to_Standard
             ( v : DecaDobl_Complex_Vectors.Vector )
             return Standard_Complex_Vectors.Vector is

    res : Standard_Complex_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := DecaDobl_Complex_to_Standard(v(i));
    end loop;
    return res;
  end DecaDobl_Complex_to_Standard;

  function DecaDobl_Complex_to_Multprec
             ( v : DecaDobl_Complex_Vectors.Vector )
             return Multprec_Complex_Vectors.Vector is

    res : Multprec_Complex_Vectors.Vector(v'range);

  begin
    for i in v'range loop
      res(i) := DecaDobl_Complex_to_Multprec(v(i));
    end loop;
    return res;
  end DecaDobl_Complex_to_Multprec;

end DecaDobl_Complex_Vectors_cv;
