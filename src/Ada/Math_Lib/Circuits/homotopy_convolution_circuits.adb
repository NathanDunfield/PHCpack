with Double_Double_Numbers;              use Double_Double_Numbers;
with Quad_Double_Numbers;                use Quad_Double_Numbers;
with Standard_Complex_Numbers;
with DoblDobl_Complex_Numbers;
with QuadDobl_Complex_Numbers;

package body Homotopy_Convolution_Circuits is

  procedure Add_Continuation_Parameter
              ( c : in Standard_Speelpenning_Convolutions.Link_to_Circuit ) is

    cf : Standard_Complex_Vectors.Link_to_Vector;

    use Standard_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := Standard_Complex_Numbers.Create(1.0);
    end loop;
    if c.cst /= null then
      c.cst(1) := Standard_Complex_Numbers.Create(1.0);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in DoblDobl_Speelpenning_Convolutions.Link_to_Circuit ) is

    cf : DoblDobl_Complex_Vectors.Link_to_Vector;
    one : constant double_double := create(1.0);

    use DoblDobl_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := DoblDobl_Complex_Numbers.Create(one);
    end loop;
    if c.cst /= null then
      c.cst(1) := DoblDobl_Complex_Numbers.Create(one);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in QuadDobl_Speelpenning_Convolutions.Link_to_Circuit ) is

    cf : QuadDobl_Complex_Vectors.Link_to_Vector;
    one : constant quad_double := create(1.0);

    use QuadDobl_Complex_Vectors;

  begin
    for k in c.cff'range loop
      cf := c.cff(k);
      cf(1) := QuadDobl_Complex_Numbers.Create(one);
    end loop;
    if c.cst /= null then
      c.cst(1) := QuadDobl_Complex_Numbers.Create(one);
    end if;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in Standard_Speelpenning_Convolutions.Circuits ) is
  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in DoblDobl_Speelpenning_Convolutions.Circuits ) is
  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Add_Continuation_Parameter
              ( c : in QuadDobl_Speelpenning_Convolutions.Circuits ) is
  begin
    for k in c'range loop
      Add_Continuation_Parameter(c(k));
    end loop;
  end Add_Continuation_Parameter;

  procedure Add_Parameter_to_Constant
              ( c : in Standard_Speelpenning_Convolutions.Link_to_Circuit;
                deg : in integer32 ) is

    use Standard_Complex_Numbers;
    use Standard_Complex_Vectors;

  begin
    if c.cst /= null then
      c.cst(1) := Create(1.0);
    else
      c.cst := new Standard_Complex_Vectors.Vector'(0..deg => Create(0.0));
      c.cst(1) := Create(1.0);
    end if;
  end Add_Parameter_to_Constant;

  procedure Add_Parameter_to_Constant
              ( c : in DoblDobl_Speelpenning_Convolutions.Link_to_Circuit;
                deg : in integer32 ) is

    use DoblDobl_Complex_Numbers;
    use DoblDobl_Complex_Vectors;

  begin
    if c.cst /= null then
      c.cst(1) := Create(integer32(1));
    else
      c.cst := new DoblDobl_Complex_Vectors.Vector'
                     (0..deg => Create(integer32(0)));
      c.cst(1) := Create(integer32(1));
    end if;
  end Add_Parameter_to_Constant;

  procedure Add_Parameter_to_Constant
              ( c : in QuadDobl_Speelpenning_Convolutions.Link_to_Circuit;
                deg : in integer32 ) is

    use QuadDobl_Complex_Numbers;
    use QuadDobl_Complex_Vectors;

  begin
    if c.cst /= null then
      c.cst(1) := Create(integer32(1));
    else
      c.cst := new QuadDobl_Complex_Vectors.Vector'
                     (0..deg => Create(integer32(0)));
      c.cst(1) := Create(integer32(1));
    end if;
  end Add_Parameter_to_Constant;

  procedure Add_Parameter_to_Constant
              ( s : in Standard_Speelpenning_Convolutions.Link_to_System ) is
  begin
    for k in s.crc'range loop
      Add_Parameter_to_Constant(s.crc(k),s.deg);
    end loop;
  end Add_Parameter_to_Constant;

  procedure Add_Parameter_to_Constant
              ( s : in DoblDobl_Speelpenning_Convolutions.Link_to_System ) is
  begin
    for k in s.crc'range loop
      Add_Parameter_to_Constant(s.crc(k),s.deg);
    end loop;
  end Add_Parameter_to_Constant;

  procedure Add_Parameter_to_Constant
              ( s : in QuadDobl_Speelpenning_Convolutions.Link_to_System ) is
  begin
    for k in s.crc'range loop
      Add_Parameter_to_Constant(s.crc(k),s.deg);
    end loop;
  end Add_Parameter_to_Constant;

  procedure Set_Solution_Constant
              ( c : in Standard_Speelpenning_Convolutions.Link_to_Circuit;
                z : in Standard_Complex_Vectors.Vector ) is

    use Standard_Complex_Numbers;
    use Standard_Complex_Vectors;
    use Standard_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
      else
        deg := c.cff(1)'last;
        c.cst := new Standard_Complex_Vectors.Vector'(0..deg => Create(0.0));
        c.cst(0) := -y;
      end if;
    end if;
  end Set_Solution_Constant;

  procedure Set_Solution_Constant
              ( c : in DoblDobl_Speelpenning_Convolutions.Link_to_Circuit;
                z : in DoblDobl_Complex_Vectors.Vector ) is

    use DoblDobl_Complex_Numbers;
    use DoblDobl_Complex_Vectors;
    use DoblDobl_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;
    zero : constant double_double := create(0.0);

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
      else
        deg := c.cff(1)'last;
        c.cst := new DoblDobl_Complex_Vectors.Vector'(0..deg => Create(zero));
        c.cst(0) := -y;
      end if;
    end if;
  end Set_Solution_Constant;

  procedure Set_Solution_Constant
              ( c : in QuadDobl_Speelpenning_Convolutions.Link_to_Circuit;
                z : in QuadDobl_Complex_Vectors.Vector ) is

    use QuadDobl_Complex_Numbers;
    use QuadDobl_Complex_Vectors;
    use QuadDobl_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;
    zero : constant quad_double := create(0.0);

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
      else
        deg := c.cff(1)'last;
        c.cst := new QuadDobl_Complex_Vectors.Vector'(0..deg => Create(zero));
        c.cst(0) := -y;
      end if;
    end if;
  end Set_Solution_Constant;

  procedure Set_Solution_Constant
              ( c : in Standard_Speelpenning_Convolutions.Circuits;
                z : in Standard_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Set_Solution_Constant(c(k),z);
    end loop;
  end Set_Solution_Constant;

  procedure Set_Solution_Constant
              ( c : in DoblDobl_Speelpenning_Convolutions.Circuits;
                z : in DoblDobl_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Set_Solution_Constant(c(k),z);
    end loop;
  end Set_Solution_Constant;

  procedure Set_Solution_Constant
              ( c : in QuadDobl_Speelpenning_Convolutions.Circuits;
                z : in QuadDobl_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Set_Solution_Constant(c(k),z);
    end loop;
  end Set_Solution_Constant;

  procedure Newton_Homotopy
              ( c : in Standard_Speelpenning_Convolutions.Link_to_Circuit;
                z : in Standard_Complex_Vectors.Vector ) is

    use Standard_Complex_Numbers;
    use Standard_Complex_Vectors;
    use Standard_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
        c.cst(1) := y;
        for k in 2..c.cst'last loop
          c.cst(k) := Create(0.0);
        end loop;
      else
        deg := c.cff(1)'last;
        c.cst := new Standard_Complex_Vectors.Vector'(0..deg => Create(0.0));
        c.cst(0) := -y;
        c.cst(1) := y;   -- c turned into c - y + t*y
      end if;
    end if;
  end Newton_Homotopy;

  procedure Newton_Homotopy
              ( c : in DoblDobl_Speelpenning_Convolutions.Link_to_Circuit;
                z : in DoblDobl_Complex_Vectors.Vector ) is

    use DoblDobl_Complex_Numbers;
    use DoblDobl_Complex_Vectors;
    use DoblDobl_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;
    zero : constant double_double := create(0.0);

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
        c.cst(1) := y;
        for k in 2..c.cst'last loop
          c.cst(k) := Create(zero);
        end loop;
      else
        deg := c.cff(1)'last;
        c.cst := new DoblDobl_Complex_Vectors.Vector'(0..deg => Create(zero));
        c.cst(0) := -y;
        c.cst(1) := y;   -- c turned into c - y + t*y
      end if;
    end if;
  end Newton_Homotopy;

  procedure Newton_Homotopy 
              ( c : in QuadDobl_Speelpenning_Convolutions.Link_to_Circuit;
                z : in QuadDobl_Complex_Vectors.Vector ) is

    use QuadDobl_Complex_Numbers;
    use QuadDobl_Complex_Vectors;
    use QuadDobl_Speelpenning_Convolutions;

    y : Complex_Number;
    deg : integer32;
    zero : constant quad_double := create(0.0);

  begin
    if c /= null then
      y := Eval(c,z);
      if c.cst /= null then
        c.cst(0) := c.cst(0) - y;
        c.cst(1) := y;
        for k in 2..c.cst'last loop
          c.cst(k) := Create(zero);
        end loop;
      else
        deg := c.cff(1)'last;
        c.cst := new QuadDobl_Complex_Vectors.Vector'(0..deg => Create(zero));
        c.cst(0) := -y;
        c.cst(1) := y;   -- c turned into c - y + t*y
      end if;
    end if;
  end Newton_Homotopy;

  procedure Newton_Homotopy
              ( c : in Standard_Speelpenning_Convolutions.Circuits;
                z : in Standard_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Newton_Homotopy(c(k),z);
    end loop;
  end Newton_Homotopy;

  procedure Newton_Homotopy
              ( c : in DoblDobl_Speelpenning_Convolutions.Circuits;
                z : in DoblDobl_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Newton_Homotopy(c(k),z);
    end loop;
  end Newton_Homotopy;

  procedure Newton_Homotopy
              ( c : in QuadDobl_Speelpenning_Convolutions.Circuits;
                z : in QuadDobl_Complex_Vectors.Vector ) is
  begin
    for k in c'range loop
      Newton_Homotopy(c(k),z);
    end loop;
  end Newton_Homotopy;

end Homotopy_Convolution_Circuits;
