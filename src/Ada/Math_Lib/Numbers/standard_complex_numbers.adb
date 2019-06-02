package body Standard_Complex_Numbers is

-- CREATORS :

  function Create ( n : natural32 ) return Complex_Number is
  begin
    return Create(integer32(n));
  end Create;

  function Create ( i : integer ) return Complex_Number is
  begin
    return Create(integer32(i));
  end Create;

  function Create ( i : integer32 ) return Complex_Number is

    res : Complex_Number;

  begin
    res.RE := Create(integer(i));
    res.IM := 0.0;
    return res;
  end Create;

  function Create ( f : double_float ) return Complex_Number is

    res : Complex_Number;

  begin
    res.RE := f;
    res.IM := 0.0;
    return res;
  end Create;

  function Create ( re,im : double_float ) return Complex_Number is

    res : Complex_Number;

  begin
    res.RE := re;
    res.IM := im;
    return res;
  end Create;

  function Conjugate ( c : Complex_Number ) return Complex_Number is

    res : Complex_Number;

  begin
    res.RE := c.RE;
    res.IM := -c.IM;
    return res;
  end Conjugate;

-- COMPARISON and COPYING :

  function Equal ( x,y : Complex_Number ) return boolean is
  begin
    return ((x.RE = y.RE) and (x.IM = y.IM));
  end Equal;

  procedure Copy ( x : in Complex_Number; y : in out Complex_Number ) is
  begin
    y.RE := x.RE;
    y.IM := x.IM;
  end Copy;

  function "<" ( x,y : Complex_Number ) return boolean is

    avx : constant double_float := AbsVal(x);
    avy : constant double_float := AbsVal(y);
    res : constant boolean := (avx < avy);

  begin
    return res;
  end "<";

  function ">" ( x,y : Complex_Number ) return boolean is

    avx : constant double_float := AbsVal(x);
    avy : constant double_float := AbsVal(y);
    res : constant boolean := (avx > avy);

  begin
    return res;
  end ">";

-- SELECTORS :

  function REAL_PART ( x : Complex_Number ) return double_float is
  begin
    return x.RE;
  end REAL_PART;

  function IMAG_PART ( x : Complex_Number ) return double_float is
  begin
    return x.IM;
  end IMAG_PART;

  function AbsVal ( x : Complex_Number ) return double_float is

    res : constant double_float := abs(x.RE) + abs(x.IM);

  begin
    return res;
  end AbsVal;

  function AbsVal ( x : Complex_Number ) return Complex_Number is

    abx : constant double_float := AbsVal(x);
    res : constant Complex_Number := Create(abx);

  begin
    return res;
  end AbsVal;

-- ARITHMETIC OPERATIONS AS FUNCTIONS :

  function "+" ( x : Complex_Number; y : double_float ) return Complex_Number is
  begin
    return (x.RE+y,x.IM);
  end "+";

  function "-" ( x : Complex_Number; y : double_float ) return Complex_Number is
  begin
    return (x.RE-y,x.IM);
  end "-";

  function "*" ( x : Complex_Number; y : double_float ) return Complex_Number is
  begin
    return (x.RE*y,x.IM*y);
  end "*";

  function "/" ( x : Complex_Number; y : double_float ) return Complex_Number is
  begin
    return (x.RE/y,x.IM/y);
  end "/";

  function "+" ( x : double_float; y : Complex_Number ) return Complex_Number is
  begin
    return (x+y.RE,y.IM);
  end "+";

  function "-" ( x : double_float; y : Complex_Number ) return Complex_Number is
  begin
    return (x-y.RE,-y.IM);
  end "-";

  function "*" ( x : double_float; y : Complex_Number ) return Complex_Number is
  begin
    return (x*y.RE,x*y.IM);
  end "*";

  function "/" ( x : double_float; y : Complex_Number ) return Complex_Number is

    res : Complex_Number;
    nrm,acc : double_float;

  begin
    nrm := y.RE*y.RE + y.IM*y.IM;
    acc := x/nrm;
    res.RE := acc*y.RE;
    res.IM := -acc*y.IM;
    return res;
  end "/";

  function "+" ( x : Complex_Number ) return Complex_Number is
  begin
    return (x.RE,x.IM);
  end "+";

  function "-" ( x : Complex_Number ) return Complex_Number is
  begin
    return (-x.RE,-x.IM);
  end "-";

  function "+" ( x,y : Complex_Number ) return Complex_Number is
  begin
    return (x.RE+y.RE,x.IM+y.IM);
  end "+";

  function "-" ( x,y : Complex_Number ) return Complex_Number is
  begin
    return (x.RE-y.RE,x.IM-y.IM);
  end "-";

  function "*" ( x,y : Complex_Number ) return Complex_Number is

    res : Complex_Number;

  begin
    res.RE := x.RE*y.RE - x.IM*y.IM;
    res.IM := x.RE*y.IM + x.IM*y.RE;
    return res;
  end "*";

  function "/"  ( x,y : Complex_Number ) return Complex_Number is

    res : Complex_Number;
    nrm : double_float;

  begin
    nrm := y.RE*y.RE + y.IM*y.IM;
    res.RE := x.RE*y.RE + x.IM*y.IM;
    res.IM := x.IM*y.RE - x.RE*y.IM;
    res.RE := res.RE/nrm;
    res.IM := res.IM/nrm;
    return res;
  end "/";

  function "**" ( x : Complex_Number; m : integer ) return Complex_Number is

    res : Complex_Number;

  begin
    if m = 0 then
      res := Create(natural32(1));
    elsif m > 0 then
      res := x;
      for j in 2..m loop
        res := res*x;
      end loop;
    else
      res := Create(natural32(1));
      for j in 1..(-m) loop
        res := res/x;
      end loop;
    end if;
    return res;
  end "**";

-- ARITHMETIC OPERATIONS AS PROCEDURES :

  procedure Add ( x : in out Complex_Number; y : in double_float ) is
  begin
    x.RE := x.RE + y;
  end Add;

  procedure Sub ( x : in out Complex_Number; y : in double_float ) is
  begin
    x.RE := x.RE - y;
  end Sub;

  procedure Mul ( x : in out Complex_Number; y : in double_float ) is
  begin
    x.RE := x.RE*y;
    x.IM := x.IM*y;
  end Mul;

  procedure Div ( x : in out Complex_Number; y : in double_float ) is
  begin
    x.RE := x.RE/y;
    x.IM := x.IM/y;
  end Div;

  procedure Add ( x : in out Complex_Number; y : in Complex_Number ) is
  begin
    x.RE := x.RE + y.RE;
    x.IM := x.IM + y.IM;
  end Add;

  procedure Sub ( x : in out Complex_Number; y : in Complex_Number ) is
  begin
    x.RE := x.RE - y.RE;
    x.IM := x.IM - y.IM;
  end Sub;

  procedure Min ( x : in out Complex_Number ) is
  begin
    x.RE := -x.RE;
    x.IM := -x.IM;
  end Min;

  procedure Mul ( x : in out Complex_Number; y : in Complex_Number ) is

    res : Complex_Number;

  begin
    res.RE := x.RE*y.RE - x.IM*y.IM;
    res.IM := x.RE*y.IM + x.IM*y.RE;
    x := res;   
  end Mul;

  procedure Div ( x : in out Complex_Number; y : in Complex_Number ) is

    res : Complex_Number;
    nrm : double_float;

  begin
    nrm := y.RE*y.RE + y.IM*y.IM;
    res.RE := x.RE*y.RE + x.IM*y.IM;
    res.IM := x.IM*y.RE - x.RE*y.IM;
    x.RE := res.RE/nrm;
    x.IM := res.IM/nrm;
  end Div;

-- CHECK IF NaN :

  function is_valid ( x : Complex_Number ) return boolean is
  begin
    if not is_valid(x.RE) then
      return false;
    elsif not is_valid(x.IM) then
      return false;
    else
      return true;
    end if;
  end is_valid;

-- DESTRUCTOR :

  procedure Clear ( x : in out Complex_Number ) is
  begin
    null;
  end Clear;

end Standard_Complex_Numbers;
