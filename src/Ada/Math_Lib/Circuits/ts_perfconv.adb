with text_io;                             use text_io;
with Communications_with_User;            use Communications_with_User;
with Timing_Package;                      use Timing_Package;
with Standard_Integer_Numbers;            use Standard_Integer_Numbers;
with Standard_Integer_Numbers_io;         use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;           use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;        use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;
with Standard_Complex_Numbers_io;         use Standard_Complex_Numbers_io;
with Standard_Floating_Vectors;
with Standard_Complex_Vectors;
with Standard_Complex_Vectors_io;         use Standard_Complex_Vectors_io;
with Standard_Random_Vectors;

procedure ts_perfconv is

-- DESCRIPTION :
--   Tests the development of more efficient convolutions.

  procedure Add ( first,second : in Standard_Complex_Vectors.Link_to_Vector;
                  product : in Standard_Complex_Vectors.Link_to_Vector ) is

  -- DESCRIPTION :
  --   Adds the coefficients of first with second
  --   and stores the results in the product.

  -- REQUIRED :
  --   All vectors have the same range and start at 0.

    deg : constant integer32 := first'last;

    use Standard_Complex_Numbers;

  begin
    for k in 0..deg loop
      product(k) := first(k) + second(k);
    end loop;
  end Add;

  procedure Add ( xr,xi,yr,yi : in Standard_Floating_Vectors.Link_to_Vector;
                  zr,zi : in Standard_Floating_Vectors.Link_to_Vector ) is

  -- DESCRIPTION :
  --   Adds the vector x to y and stores the result in z.
  --   Real parts of x, y, and z are stored in xr, yr, and zr.
  --   Imaginary parts of x, y, and z are stored in xi, yi, and zi.

  -- REQUIRED :
  --   All vectors have the same range and start at 0.

    deg : constant integer32 := xr'last;

  begin
    for k in 0..deg loop
      zr(k) := xr(k) + yr(k);
      zi(k) := xi(k) + yi(k);
    end loop;
  end Add;

  procedure Inner_Product
              ( first,second : in Standard_Complex_Vectors.Link_to_Vector;
                product : out Standard_Complex_Numbers.Complex_Number ) is

  -- DESCRIPTION :
  --   Computes the inner product of the vectors first and second
  --   and stores the result in product.

  -- REQUIRED :
  --   All vectors have the same range and start at 0.

    deg : constant integer32 := first'last;

    use Standard_Complex_Numbers;

  begin
    product := Create(0.0);
    for k in 0..deg loop
      product := product + first(k)*second(k);
    end loop;
  end Inner_Product;

  procedure Inner_Product
              ( xr,xi,yr,yi : in Standard_Floating_Vectors.Link_to_Vector;
                zr,zi : out double_float ) is

  -- DESCRIPTION :
  --   Computes the inner product of the vectors x and y,
  --   with real parts in xr, yr, and imaginary parts in xi, yi.
  --   The real part of the inner product is returned in zr
  --   and the imaginary part is returned in zi.

  -- REQUIRED :
  --   All vectors have the same range and start at 0.

    deg : constant integer32 := xr'last;
    xrk,xik,yrk,yik,p1,p2,p3,p4 : double_float;

    use Standard_Complex_Numbers;

  begin
   -- product := Create(0.0);
    zr := 0.0; zi := 0.0;
    for k in 0..deg loop
     -- product := product + first(k)*second(k);
      xrk := xr(k); xik := xi(k);
      yrk := yr(k); yik := yi(k);
      p1 := xrk*yrk;
      p2 := xik*yik;
      zr := zr + p1 - p2;
      p3 := xik*yrk;
      p4 := xrk*yik;
      zi := zi + p3 + p4;
    end loop;
  end Inner_Product;

  procedure Multiply
              ( first,second : in Standard_Complex_Vectors.Link_to_Vector;
                product : in Standard_Complex_Vectors.Link_to_Vector ) is

  -- DESCRIPTION :
  --   Multiplies the coefficients of first with second
  --   and stores the results in the product.

  -- REQUIRED :
  --   All vectors have the same range.

    deg : constant integer32 := first'last;

    use Standard_Complex_Numbers;

  begin
    product(0) := first(0)*second(0);
    for k in 1..deg loop
      product(k) := first(0)*second(k);
      for i in 1..k loop
        product(k) := product(k) + first(i)*second(k-i);
      end loop;
    end loop;
  end Multiply;

  procedure Multiply
              ( xr,xi,yr,yi : in Standard_Floating_Vectors.Link_to_Vector;
                zr,zi : in Standard_Floating_Vectors.Link_to_Vector ) is

  -- DESCRIPTION :
  --   Multiplies the coefficients of the vector x with y,
  --   with real parts in xr, yr, and imaginary parts in xi, yi,
  --   and stores the results in the z, with real and imaginary
  --   parts in zr and zi.

  -- REQUIRED :
  --   All vectors have the same range.

    deg : constant integer32 := xr'last;
    rpa,ipa : double_float; -- accumulates real and imaginary parts
    xr0,xi0 : double_float; -- to hold values in xr and xi
    yr0,yi0 : double_float; -- to hold values in yr and yi
    idx : integer32;

  begin
   -- product(0) := first(0)*second(0);
    xr0 := xr(0); xi0 := xi(0);
    yr0 := yr(0); yi0 := yi(0);
    zr(0) := xr0*yr0 - xi0*yi0;
    zi(0) := xi0*yr0 + xr0*yi0;
    for k in 1..deg loop
     -- product(k) := first(0)*second(k);
      xr0 := xr(0); xi0 := xi(0);
      yr0 := yr(k); yi0 := yi(k);
      rpa := xr0*yr0 - xi0*yi0;
      ipa := xi0*yr0 + xr0*yi0;
      for i in 1..k loop
       -- product(k) := product(k) + first(i)*second(k-i);
        xr0 := xr(i); xi0 := xi(i);
        idx := k-i;
        yr0 := yr(idx); yi0 := yi(idx);
        rpa := rpa + xr0*yr0 - xi0*yi0;
        ipa := ipa + xi0*yr0 + xr0*yi0;
      end loop;
      zr(k) := rpa;
      zi(k) := ipa;
    end loop;
  end Multiply;

  procedure Multiply2
              ( xr,xi,yr,yi : in Standard_Floating_Vectors.Link_to_Vector;
                zr,zi : in Standard_Floating_Vectors.Link_to_Vector ) is

  -- DESCRIPTION :
  --   Multiplies the coefficients of the vector x with y,
  --   with real parts in xr, yr, and imaginary parts in xi, yi,
  --   and stores the results in the z, with real and imaginary
  --   parts in zr and zi.

  -- REQUIRED :
  --   All vectors have the same range.

    deg : constant integer32 := xr'last;
    acc : double_float;

  begin
    zr(0) := xr(0)*yr(0) - xi(0)*yi(0);
    for k in 1..deg loop
      acc := xr(0)*yr(k) - xi(0)*yi(k);
      for i in 1..k loop
        acc := acc + xr(i)*yr(k-i) - xi(i)*yi(k-i);
      end loop;
      zr(k) := acc;
    end loop;
    zi(0) := xi(0)*yr(0) + xr(0)*yi(0);
    for k in 1..deg loop
      acc := xi(0)*yr(k) + xr(0)*yi(k);
      for i in 1..k loop
        acc := acc + xi(i)*yr(k-i) + xr(i)*yi(k-i);
      end loop;
      zi(k) := acc;
    end loop;
  end Multiply2;

  function Real_Part ( x : Standard_Complex_Vectors.Link_to_Vector )
                     return Standard_Floating_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the vector of the real parts of the vector x.

    res : Standard_Floating_Vectors.Link_to_Vector;
    rpx : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      rpx(k) := Standard_Complex_Numbers.REAL_PART(x(k));
    end loop;
    res := new Standard_Floating_Vectors.Vector'(rpx);
    return res;
  end Real_Part;

  function Imag_Part ( x : Standard_Complex_Vectors.Link_to_Vector )
                     return Standard_Floating_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the vector of the imaginary parts of the vector x.

    res : Standard_Floating_Vectors.Link_to_Vector;
    ipx : Standard_Floating_Vectors.Vector(x'range);

  begin
    for k in x'range loop
      ipx(k) := Standard_Complex_Numbers.IMAG_PART(x(k));
    end loop;
    res := new Standard_Floating_Vectors.Vector'(ipx);
    return res;
  end Imag_Part;

  function Make_Complex
             ( rpx,ipx : Standard_Floating_Vectors.Link_to_Vector )
             return Standard_Complex_Vectors.Link_to_Vector is

  -- DESCRIPTION :
  --   Returns the vector with real and imaginary parts in the
  --   vector rpx and ipx.

    res : Standard_Complex_Vectors.Link_to_Vector;
    cvx : Standard_Complex_Vectors.Vector(rpx'range);

  begin
    for k in cvx'range loop
      cvx(k) := Standard_Complex_Numbers.Create(rpx(k),ipx(k));
    end loop;
    res := new Standard_Complex_Vectors.Vector'(cvx);
    return res;
  end Make_Complex;

  procedure Test_Multiply ( deg : in integer32 ) is

  -- DESCRIPTION :
  --   Generates two random coefficients vectors of degree deg
  --   and tests the multiplication.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);
    cz : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Complex_Vectors.Vector'(0..deg => zero);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cz);
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(z);
    iz : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(z);
    v,w : Standard_Complex_Vectors.Link_to_Vector;

  begin
    Multiply(x,y,z);
    put_line("the result : "); put_line(z);
    Multiply(rx,ix,ry,iy,rz,iz);
    v := Make_Complex(rz,iz);
    put_line("recomputed : "); put_line(v);
    Multiply2(rx,ix,ry,iy,rz,iz);
    w := Make_Complex(rz,iz);
    put_line("recomputed : "); put_line(w);
  end Test_Multiply;

  procedure Test_Add ( deg : in integer32 ) is

  -- DESCRIPTION :
  --   Generates two random coefficients vectors of degree deg
  --   and tests the addition.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);
    cz : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Complex_Vectors.Vector'(0..deg => zero);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cz);
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(z);
    iz : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(z);
    v : Standard_Complex_Vectors.Link_to_Vector;

  begin
    Add(x,y,z);
    put_line("the result : "); put_line(z);
    Add(rx,ix,ry,iy,rz,iz);
    v := Make_Complex(rz,iz);
    put_line("recomputed : "); put_line(v);
  end Test_Add;

  procedure Test_Inner ( deg : in integer32 ) is

  -- DESCRIPTION :
  --   Generates two random coefficients vectors of degree deg
  --   and tests the inner product.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : Standard_Complex_Numbers.Complex_Number;
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz,iz : double_float;

  begin
    Inner_Product(x,y,z);
    put_line("the result : "); put(z); new_line;
    Inner_Product(rx,ix,ry,iy,rz,iz);
    put_line("recomputed : ");
    put(rz); put("  "); put(iz); new_line;
  end Test_Inner;

  procedure Timing_Test_Add ( deg,frq : in integer32 ) is

  -- DESCRIPTION :
  --   Does as many additions as freq on random coefficient vectors
  --   of series truncated to degree deg.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);
    cz : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Complex_Vectors.Vector'(0..deg => zero);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cz);
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(z);
    iz : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(z);
    timer : Timing_Widget;

  begin
    tstart(timer);
    for k in 1..frq loop
      Add(x,y,z);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"complex add");
    tstart(timer);
    for k in 1..frq loop
      Add(rx,ix,ry,iy,rz,iz);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"real add");
  end Timing_Test_Add;

  procedure Timing_Test_Inner ( deg,frq : in integer32 ) is

  -- DESCRIPTION :
  --   Does as many inner products as freq on random coefficient vectors
  --   of series truncated to degree deg.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : Standard_Complex_Numbers.Complex_Number;
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz,iz : double_float;
    timer : Timing_Widget;

  begin
    tstart(timer);
    for k in 1..frq loop
      Inner_Product(x,y,z);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"complex inner product");
    tstart(timer);
    for k in 1..frq loop
      Inner_Product(rx,ix,ry,iy,rz,iz);
      z := Standard_Complex_Numbers.Create(rz,iz);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"real inner product");
  end Timing_Test_Inner;

  procedure Timing_Test_Multiply ( deg,frq : in integer32 ) is

  -- DESCRIPTION :
  --   Does as many convolutions as freq on random coefficient vectors
  --   of series truncated to degree deg.

    cx : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    cy : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Random_Vectors.Random_Vector(0,deg);
    zero : constant Standard_Complex_Numbers.Complex_Number
         := Standard_Complex_Numbers.Create(0.0);
    cz : constant Standard_Complex_Vectors.Vector(0..deg)
       := Standard_Complex_Vectors.Vector'(0..deg => zero);
    x : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cx);
    y : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cy);
    z : constant Standard_Complex_Vectors.Link_to_Vector
      := new Standard_Complex_Vectors.Vector'(cz);
    rx : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(x);
    ix : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(x);
    ry : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(y);
    iy : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(y);
    rz : constant Standard_Floating_Vectors.Link_to_Vector := Real_Part(z);
    iz : constant Standard_Floating_Vectors.Link_to_Vector := Imag_Part(z);
    timer : Timing_Widget;

  begin
    tstart(timer);
    for k in 1..frq loop
      Multiply(x,y,z);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"complex multiply");
    tstart(timer);
    for k in 1..frq loop
      Multiply(rx,ix,ry,iy,rz,iz);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"real multiply");
    tstart(timer);
    for k in 1..frq loop
      Multiply2(rx,ix,ry,iy,rz,iz);
    end loop;
    tstop(timer);
    new_line;
    print_times(standard_output,timer,"real multiply 2");
  end Timing_Test_Multiply;

  procedure Main is

  -- DESCRIPTION :
  --   Prompts the user for the degree of the series
  --   and then launches the test.

    deg : integer32 := 0;
    ans,opertest : character;
    freq : integer32 := 0;

  begin
    new_line;
    put("Give the degree of the series : "); get(deg);
    new_line;
    put_line("MENU for the operations :");
    put_line("  0. addition of two vectors");
    put_line("  1. inner product of two vectors");
    put_line("  2. convolution of two vectors");
    put("Type 0, 1, or 2 to select the operation : ");
    Ask_Alternative(opertest,"012");
    new_line;
    put("Interactive test ? (y/n) "); Ask_Yes_or_No(ans);
    if ans /= 'y'
     then put("Give the frequency : "); get(freq);
    end if;
    if freq = 0 then
      new_line;
      case opertest is
        when '0' => Test_Add(deg);
        when '1' => Test_Inner(deg);
        when '2' => Test_Multiply(deg);
        when others => null;
      end case;
    else
      case opertest is
        when '0' => Timing_Test_Add(deg,freq);
        when '1' => Timing_Test_Inner(deg,freq);
        when '2' => Timing_Test_Multiply(deg,freq);
        when others => null;
      end case;
    end if;
  end Main;

begin
  Main;
end ts_perfconv;
