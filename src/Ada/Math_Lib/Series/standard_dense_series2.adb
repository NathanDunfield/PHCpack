with unchecked_deallocation;
with Standard_Mathematical_Functions;
with Standard_Complex_Numbers_Polar;
with Binomial_Coefficients;

package body Standard_Dense_Series2 is

-- CREATORS :

  function Create ( i : integer ) return Series is
  begin
    return Create(i,0);
  end Create;

  function Create ( f : double_float ) return Series is
  begin
    return Create(f,0);
  end Create;

  function Create ( c : Complex_Number ) return Series is
  begin
    return Create(c,0);
  end Create;

  function Create ( i : integer ) return Link_to_Series is

    ser : constant Series(0) := Create(i,0);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( f : double_float ) return Link_to_Series is

    ser : constant Series(0) := Create(f,0);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( c : Complex_Number ) return Link_to_Series is

    ser : constant Series(0) := Create(c,0);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( i : integer; deg : integer32 ) return Series is

    res : Series(deg);

  begin
    res.cff(0) := Create(i);
    res.cff(1..deg)
      := Standard_Complex_Vectors.Vector'(1..deg => Create(0.0));
    return res;
  end Create;

  function Create ( f : double_float; deg : integer32 ) return Series is

    res : Series(deg);

  begin
    res.cff(0) := Create(f);
    res.cff(1..deg)
      := Standard_Complex_Vectors.Vector'(1..deg => Create(0.0));
    return res;
  end Create;

  function Create ( c : Complex_Number; deg : integer32 ) return Series is

    res : Series(deg);

  begin
    res.cff(0) := c;
    res.cff(1..deg)
      := Standard_Complex_Vectors.Vector'(1..deg => Create(0.0));
    return res;
  end Create;

  function Create ( i : integer; deg : integer32 )
                  return Link_to_Series is

    ser : constant Series(deg) := Create(i,deg);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( f : double_float; deg : integer32 )
                  return Link_to_Series is

    ser : constant Series(deg) := Create(f,deg);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( c : Complex_Number; deg : integer32 )
                  return Link_to_Series is

    ser : constant Series(deg) := Create(c,deg);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( c : Standard_Complex_Vectors.Vector ) return Series is

    res : Series(c'last);

  begin
    res.cff(0..c'last) := c;
    return res;
  end Create;

  function Create ( c : Standard_Complex_Vectors.Vector )
                  return Link_to_Series is

    ser : constant Series(c'last) := Create(c);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  function Create ( s : Series; deg : integer32 ) return Series is

    res : Series(deg);
    zero : constant Complex_Number := Create(0.0);

  begin
    if deg <= s.deg then
      for i in 0..res.deg loop
        res.cff(i) := s.cff(i);
      end loop;
    else
      for i in 0..s.deg loop
        res.cff(i) := s.cff(i);
      end loop;
      for i in s.deg+1..deg loop
        res.cff(i) := zero;
      end loop;
    end if;
    return res;
  end Create;

  function Create ( s : Series; deg : integer32 )
                  return Link_to_Series is

    ser : constant Series(deg) := Create(s,deg);
    res : constant Link_to_Series := new Series'(ser);

  begin
    return res;
  end Create;

  procedure Set_Degree ( s : in out Link_to_Series; deg : in integer32 ) is
  begin
    if s.deg /= deg then
      declare
        res : constant Link_to_Series := Create(s.all,deg);
      begin
        Clear(s);
        s := res;
      end;
    end if;
  end Set_Degree;

-- EQUALITY AND COPY :

  function Equal ( s,t : Series ) return boolean is

    zero : constant Complex_Number := Create(0.0);

  begin
    if s.deg <= t.deg then
      for i in 0..s.deg loop
        if not Standard_Complex_Numbers.Equal(s.cff(i),t.cff(i))
         then return false;
        end if;
      end loop;
      for i in s.deg+1..t.deg loop
        if not Standard_Complex_Numbers.Equal(t.cff(i),zero)
         then return false;
        end if;
      end loop;
      return true;
    else
      return Standard_Dense_Series2.Equal(s=>t,t=>s);
    end if;
  end Equal;

  function Equal ( s,t : Link_to_Series ) return boolean is
  begin
    if s = null then
      if t = null
       then return true;
       else return false;
      end if;
    elsif t = null then
      return false;
    else
      return Equal(s.all,t.all);
    end if;
  end Equal;

  procedure Copy ( s : in Series; t : in out Series ) is
  begin
    for i in 0..s.deg loop
      exit when (i > t.deg);
      t.cff(i) := s.cff(i);
    end loop;
  end Copy;

  procedure Copy ( s : in Link_to_Series; t : in out Link_to_Series ) is
  begin
    Clear(t);
    t := Create(s.cff);
  end Copy;

-- ORDER :

  function Order ( s : Series; tol : double_float := 0.0 ) return integer32 is
  begin
    for k in 0..s.deg loop
      if Standard_Complex_Numbers.AbsVal(s.cff(k)) > tol
       then return k;
      end if;
    end loop;
    return s.deg+1;
  end Order;

  function Order ( s : Link_to_Series; tol : double_float := 0.0 )
                 return integer32 is
  begin
    if s = null
     then return -1;
     else return Order(s.all,tol);
    end if;
  end Order;

-- COMPLEX CONJUGATE :

  function Conjugate ( s : Series ) return Series is

    res : Series(s.deg);

  begin
    for i in 0..res.deg loop
      res.cff(i) := Conjugate(s.cff(i));
    end loop;
    return res;
  end Conjugate;

  function Conjugate ( s : Link_to_Series ) return Link_to_Series is
  begin
    if s = null then
      return s;
    else
      declare
        sco : constant Series(s.deg) := Conjugate(s.all);
        res : constant Link_to_Series := new Series'(sco);
      begin
        return res;
      end;
    end if;
  end Conjugate;

-- ARITHMETICAL OPERATORS :

  function "+" ( s : Series; c : Complex_Number ) return Series is

    res : Series := s;

  begin
    res.cff(0) := s.cff(0) + c;
    return res;
  end "+";

  function "+" ( s : Link_to_Series;
                 c : Complex_Number ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      res := Create(c);
    else
      res := Create(s.cff);
      res.cff(0) := res.cff(0) + c;
    end if;
    return res;
  end "+";

  function "+" ( c : Complex_Number; s : Series ) return Series is

    res : Series := s;
  
  begin
    res.cff(0) := c + s.cff(0);
    return res;
  end "+";

  function "+" ( c : Complex_Number;
                 s : Link_to_Series ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      res := Create(c);
    else
      res := Create(s.cff);
      res.cff(0) := res.cff(0) + c;
    end if;
    return res;
  end "+";

  procedure Add ( s : in out Series; c : in Complex_Number ) is
  begin
    s.cff(0) := s.cff(0) + c;
  end Add;

  procedure Add ( s : in out Link_to_Series;
                  c : in Complex_Number ) is
  begin
    if s = null
     then s := Create(c);
     else s.cff(0) := s.cff(0) + c;
    end if;
  end Add;

  function "+" ( s : Series ) return Series is

    res : constant Series(s.deg) := s;

  begin
    return res;
  end "+";

  function "+" ( s : Link_to_Series ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      return null;
    else
      res := new Series'(s.all);
      return res;
    end if;
  end "+";

  function "+" ( s,t : Series ) return Series is
  begin
    if s.deg = t.deg then
      declare
        res : Series(s.deg);
      begin
        for i in 0..res.deg loop
          res.cff(i) := s.cff(i) + t.cff(i);
        end loop;
        return res;
      end;
    elsif s.deg < t.deg then -- deg of result is t.deg
      declare
        res : Series(t.deg);
      begin
        for i in 0..s.deg loop
          res.cff(i) := s.cff(i) + t.cff(i);
        end loop;
        for i in s.deg+1..t.deg loop -- copy remaining terms from t
          res.cff(i) := t.cff(i);
        end loop;
        return res;
      end;
    else -- s.deg > t.deg and the deg of result is s.deg
      declare
        res : Series(s.deg);
      begin
        for i in 0..t.deg loop
          res.cff(i) := s.cff(i) + t.cff(i);
        end loop;
        for i in t.deg+1..s.deg loop -- copy remaining terms from s
          res.cff(i) := s.cff(i);
        end loop;
        return res;
      end;
    end if;
  end "+";

  function "+" ( s,t : Link_to_Series ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      res := +t; -- return a copy of t
    elsif t = null then
      res := +s; -- return a copy of s
    else
      declare
        spt : constant Series := s.all + t.all;
      begin
        res := new Series'(spt);
      end;
    end if;
    return res;
  end "+";

  procedure Add ( s : in out Series; t : in Series ) is
  begin
    for i in 0..t.deg loop
      exit when (i > s.deg); -- ignore higher degree terms of t
      s.cff(i) := s.cff(i) + t.cff(i);
    end loop;
  end Add;

  procedure Add ( s : in out Link_to_Series; t : in Link_to_Series ) is
  begin
    if t /= null then
      if s = null then
        s := new Series'(t.all);
      else
        if t.deg <= s.deg then
          for i in 0..t.deg loop
            s.cff(i) := s.cff(i) + t.cff(i);
          end loop;
        else
          declare
            spt : Series(t.deg);
          begin
            for i in 0..s.deg loop
              spt.cff(i) := s.cff(i) + t.cff(i);
            end loop;
            for i in s.deg+1..t.deg loop
              spt.cff(i) := t.cff(i);
            end loop;
            Clear(s);
            s := new Series'(spt);
          end;
        end if;
      end if;
    end if;
  end Add;

  function "-" ( s : Series; c : Complex_Number ) return Series is

    res : Series(s.deg) := s;

  begin
    res.cff(0) := s.cff(0) - c;
    return res;
  end "-";

  function "-" ( s : Link_to_Series;
                 c : Complex_Number ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      res := Create(-c);
    else
      res := Create(s.cff);
      res.cff(0) := res.cff(0) - c;
    end if;
    return res;
  end "-";

  function "-" ( c : Complex_Number; s : Series ) return Series is

    res : Series(s.deg);

  begin
    res.cff(0) := c - s.cff(0);
    for k in 1..res.deg loop
      res.cff(k) := -s.cff(k);
    end loop;
    return res;
  end "-";

  function "-" ( c : Complex_Number;
                 s : Link_to_Series ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null then
      res := Create(c);
    else
      res := Create(s.cff);
      res.cff(0) := c - res.cff(0);
      for k in 1..res.deg loop
        res.cff(k) := -res.cff(k);
      end loop;
    end if;
    return res;
  end "-";

  procedure Sub ( s : in out Series; c : in Complex_Number ) is
  begin
    s.cff(0) := s.cff(0) - c;
  end Sub;

  procedure Sub ( s : in out Link_to_Series;
                  c : in Complex_Number ) is
  begin
    if s = null
     then s := Create(-c);
     else s.cff(0) := s.cff(0) - c;
    end if;
  end Sub;

  function "-" ( s : Series ) return Series is

    res : Series(s.deg);

  begin
    for i in 0..res.deg loop
      res.cff(i) := -s.cff(i);
    end loop;
    return res;
  end "-";

  function "-" ( s : Link_to_Series ) return Link_to_Series is
  begin
    if s = null
     then return null;
     else return new Series'(-s.all);
    end if;
  end "-";

  procedure Min ( s : in out Series ) is
  begin
    for i in 0..s.deg loop
      s.cff(i) := -s.cff(i);
    end loop;
  end Min;

  procedure Min ( s : in out Link_to_Series ) is
  begin
    if s /= null then
      for i in 0..s.deg loop
        s.cff(i) := -s.cff(i);
      end loop;
    end if;
  end Min;

  function "-" ( s,t : Series ) return Series is
  begin
    if s.deg = t.deg then
      declare
        res : Series(s.deg);
      begin
        for i in 0..t.deg loop
          res.cff(i) := s.cff(i) - t.cff(i);
        end loop;
        return res;
      end;
    elsif s.deg < t.deg then -- the deg of the result is t.deg
      declare
        res : Series(t.deg);
      begin
        for i in 0..s.deg loop
          res.cff(i) := s.cff(i) - t.cff(i);
        end loop;
        for i in s.deg+1..t.deg loop -- copy remaining terms
          res.cff(i) := -t.cff(i);       -- of t with minus sign
        end loop;
        return res;
      end;
    else
      declare
        res : Series(s.deg);
      begin
        for i in 0..s.deg loop
          res.cff(i) := s.cff(i) - t.cff(i);
        end loop;
        for i in t.deg+1..s.deg loop -- copy remaining terms of s
          res.cff(i) := s.cff(i);
        end loop;
        return res;
      end;
    end if;
  end "-";

  function "-" ( s,t : Link_to_Series ) return Link_to_Series is
  begin
    if s = null then
      return -t;
    elsif t = null then
      return +s; -- must return a copy of s, not s
    else
      declare
        smt : constant Series := s.all - t.all;
        res : constant Link_to_Series := new Series'(smt);
      begin
        return res;
      end;
    end if;
  end "-";

  procedure Sub ( s : in out Series; t : in Series ) is
  begin
    for i in 0..t.deg loop
      exit when (i > s.deg); -- ignore higher degree terms of t
      s.cff(i) := s.cff(i) - t.cff(i);
    end loop;
  end Sub;

  procedure Sub ( s : in out Link_to_Series;
                  t : in Link_to_Series ) is
  begin
    if t /= null then
      if s = null then
        s := new Series'(t.all);
      else
        if t.deg <= s.deg then
          for i in 0..t.deg loop
            s.cff(i) := s.cff(i) - t.cff(i);
          end loop;
        else
          declare
            smt : Series(t.deg);
          begin
            for i in 0..s.deg loop
              smt.cff(i) := s.cff(i) - t.cff(i);
            end loop;
            for i in s.deg+1..t.deg loop
              smt.cff(i) := -t.cff(i);
            end loop;
            Clear(s);
            s := new Series'(smt);
          end;
        end if;
      end if;
    end if;
  end Sub;

  function "*" ( s : Series; c : Complex_Number ) return Series is

    res : Series(s.deg);

  begin
    for k in 0..s.deg loop
      res.cff(k) := s.cff(k)*c;
    end loop;
    return res;
  end "*";

  function "*" ( s : Link_to_Series;
                 c : Complex_Number ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null
     then res := null;
     else res := new Series'(s.all*c);
    end if;
    return res;
  end "*";

  function "*" ( c : Complex_Number; s : Series ) return Series is

    res : Series(s.deg);

  begin
    for k in 0..s.deg loop
      res.cff(k) := c*s.cff(k);
    end loop;
    return res;
  end "*";

  function "*" ( c : Complex_Number;
                 s : Link_to_Series ) return Link_to_Series is

    res : Link_to_Series;

  begin
    if s = null
     then res := null;
     else res := new Series'(c*s.all);
    end if;
    return res;
  end "*";

  procedure Mul ( s : in out Series; c : in Complex_Number ) is
  begin
    for i in 0..s.deg loop
      s.cff(i) := s.cff(i)*c;
    end loop;
  end Mul;

  procedure Mul ( s : in out Link_to_Series; c : in Complex_Number ) is
  begin
    if s /= null then
      for i in 0..s.deg loop
        s.cff(i) := s.cff(i)*c;
      end loop;
    end if;
  end Mul;

  function "*" ( s,t : Series ) return Series is
  begin
    if s.deg = t.deg then
      declare
        res : Series(s.deg);
      begin
        for i in 0..res.deg loop
          res.cff(i) := s.cff(0)*t.cff(i);
          for j in 1..i loop
            res.cff(i) := res.cff(i) + s.cff(j)*t.cff(i-j);
          end loop;
        end loop;
        return res;
      end;
    elsif s.deg < t.deg then
      declare
        res : Series(t.deg);
      begin
        for i in 0..res.deg loop
          res.cff(i) := s.cff(0)*t.cff(i);
          for j in 1..i loop
            exit when j > s.deg;
            res.cff(i) := res.cff(i) + s.cff(j)*t.cff(i-j);
          end loop;
        end loop;
        return res;
      end;
    else -- s.deg > t.deg, we then flip s and t
      declare
        res : Series(s.deg);
      begin
        for i in 0..res.deg loop
          res.cff(i) := t.cff(0)*s.cff(i);
          for j in 1..i loop
            exit when j > t.deg;
            res.cff(i) := res.cff(i) + t.cff(j)*s.cff(i-j);
          end loop;
        end loop;
        return res;
      end;
    end if;
  end "*";

  function "*" ( s,t : Link_to_Series ) return Link_to_Series is
  begin
    if s = null or t = null
     then return null;
     else return new Series'(s.all*t.all);
    end if;
  end "*";

  procedure Mul ( s : in out Series; t : in Series ) is

    res : constant Series := s*t;

  begin
    s := res;
  end Mul;

  procedure Mul ( s : in out Link_to_Series; t : in Link_to_Series ) is
  begin
    if s /= null then
      if t = null then
        Clear(s);
      else
        if s.deg >= t.deg then
          declare
            st : constant Series(s.deg) := s.all*t.all;
          begin
            for i in 0..s.deg loop
              s.cff(i) := st.cff(i);
            end loop;
          end;
        else
          declare
            st : constant Series(t.deg) := s.all*t.all;
          begin
            Clear(s);
            s := new Series'(st);
          end;
        end if;
      end if;
    end if;
  end Mul;

  function Inverse ( s : Series ) return Series is

    res : Series(s.deg);

  begin
    res.cff(0) := 1.0/s.cff(0);
    for i in 1..res.deg loop
      res.cff(i) := -s.cff(1)*res.cff(i-1);
      for j in 2..i loop
        res.cff(i) := res.cff(i) - s.cff(j)*res.cff(i-j);
      end loop;
      res.cff(i) := res.cff(i)/s.cff(0);
    end loop;
    return res;
  end Inverse;

  function Inverse ( s : Link_to_Series ) return Link_to_Series is
  begin
    if s = null
     then return null;
     else return new Series'(Inverse(s.all));
    end if;
  end Inverse;

  function "/" ( s : Series; c : Complex_Number ) return Series is

    res : Series(s.deg);

  begin
    for k in 0..s.deg loop
      res.cff(k) := s.cff(k)/c;
    end loop;
    return res;
  end "/";

  function "/" ( s : Link_to_Series;
                 c : Complex_Number ) return Link_to_Series is
  begin
    if s = null
     then return null;
     else return new Series'(s.all/c);
    end if;
  end "/";

  function "/" ( c : Complex_Number; s : Series ) return Series is
  begin
    return c*Inverse(s);
  end "/";

  function "/" ( c : Complex_Number;
                 s : Link_to_Series ) return Link_to_Series is
  begin
    if s = null
     then return null;
     else return new Series'(c/Inverse(s.all));
    end if;
  end "/";

  procedure Div ( s : in out Series; c : in Complex_Number ) is
  begin
    for k in 0..s.deg loop
      s.cff(k) := s.cff(k)/c;
    end loop;
  end Div;

  function "/" ( s,t : Series ) return Series is
  begin
    return s*Inverse(t);
  end "/";

  procedure Div ( s : in out Series; t : in Series ) is

    invt : constant Series := Inverse(t);

  begin
    Mul(s,invt);
  end Div;

  function "**" ( s : Series; p : integer ) return Series is

    res : Series(s.deg);

  begin
    if p = 0 then
      res := Create(1);
    elsif p > 0 then
      res := s;
      for k in 2..p loop
        Mul(res,s);
      end loop;
    else -- p < 0
      res := s;
      for k in 2..(-p) loop
        Mul(res,s);
      end loop;
      res := Inverse(res);
    end if;
    return res;
  end "**";

  function "**" ( s : Series; p : natural32 ) return Series is

    res : Series(s.deg);

  begin
    if p = 0 then
      res := Create(1);
    else
      res := s;
      for k in 2..p loop
        Mul(res,s);
      end loop;
    end if;
    return res;
  end "**";

-- EVALUATORS :

  function Eval ( s : Series; t : double_float ) return Complex_Number is

    res : Complex_Number := s.cff(0);
    pwt : double_float := t;

  begin
    for i in 1..(s.deg-1) loop
      res := res + s.cff(i)*pwt;
      pwt := pwt*t;
    end loop;
    res := res + s.cff(s.deg)*pwt;
    return res;
  end Eval;

  function Eval ( s : Series; t : Complex_Number ) return Complex_Number is

    res : Complex_Number := s.cff(0);
    pwt : Complex_Number := t;

  begin
    for i in 1..(s.deg-1) loop
      res := res + s.cff(i)*pwt;
      pwt := pwt*t;
    end loop;
    res := res + s.cff(s.deg)*pwt;
    return res;
  end Eval;

  function Eval ( s : Series; t : double_float;
                  a,b : integer32 ) return Complex_Number is

    use Standard_Mathematical_Functions;

    pow : double_float := double_float(a)/double_float(b);
    pwt : double_float := t**pow;
    res : Complex_Number := s.cff(0)*pwt;

  begin
    for i in 1..s.deg loop
      pow := double_float(a+i)/double_float(b);
      pwt := t**pow;
      res := res + s.cff(i)*pwt;
    end loop;
    return res;
  end Eval;

  function Eval ( s : Series; t : Complex_Number;
                  a,b : integer32 ) return Complex_Number is

    use Standard_Complex_Numbers_Polar;

    pow : double_float := double_float(a)/double_float(b);
    pwt : Complex_Number := Polar_Exponentiation(t,pow);
    res : Complex_Number := s.cff(0)*pwt;

  begin
    for i in 1..s.deg loop
      pow := double_float(a+i)/double_float(b);
      pwt := Polar_Exponentiation(t,pow);
      res := res + s.cff(i)*pwt;
    end loop;
    return res;
  end Eval;

  procedure Filter ( s : in out Series; tol : in double_float ) is
  begin
    for i in 0..s.deg loop
      if AbsVal(s.cff(i)) < tol
       then s.cff(i) := Create(0.0);
      end if;
    end loop;
  end Filter;

-- SHIFT OPERATORS :

  function Shift ( s : Series; c : double_float ) return Series is

    res : Series(s.deg);
    bcf : double_float;
    sgn : integer32;

    use Binomial_Coefficients;

  begin
    for i in 0..s.deg loop
      res.cff(i) := Create(0.0);
      sgn := 1;
      for j in 0..i loop
        bcf := double_float(sgn*binomial(i,j));
        bcf := bcf*(c**(natural(i-j)));
        res.cff(j) := res.cff(j) + s.cff(i)*bcf;
        sgn := -sgn;
      end loop;
    end loop;
    return res;
  end Shift;

  function Shift ( s : Series; c : Complex_Number ) return Series is

    res : Series(s.deg);
    bcf : double_float;
    rcf : Complex_Number;
    sgn : integer32;

    use Binomial_Coefficients;

  begin
    for i in 0..s.deg loop
      res.cff(i) := Create(0.0);
      sgn := 1;
      for j in 0..i loop
        bcf := double_float(sgn*binomial(i,j));
        rcf := bcf*(c**(natural(i-j)));
        res.cff(j) := res.cff(j) + s.cff(i)*rcf;
        sgn := -sgn;
      end loop;
    end loop;
    return res;
  end Shift;

  procedure Shift ( s : in out Series; c : in double_float ) is
 
    r : constant Series(s.deg) := Shift(s,c);
   
  begin
    s := r;
  end Shift;

  procedure Shift ( s : in out Series; c : in Complex_Number ) is
 
    r : constant Series(s.deg) := Shift(s,c);
   
  begin
    s := r;
  end Shift;

-- DESTRUCTOR :

  procedure Clear ( s : in out Series ) is
  begin
    for i in s.cff'range loop
      s.cff(i) := Create(0.0);
    end loop;
  end Clear;

  procedure Clear ( s : in out Link_to_Series ) is

    procedure free is new unchecked_deallocation(Series,Link_to_Series);
    
  begin
    if s /= null
     then free(s);
    end if;
  end Clear;

end Standard_Dense_Series2;
