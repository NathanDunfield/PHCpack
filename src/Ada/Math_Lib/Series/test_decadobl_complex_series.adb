with text_io;                           use text_io;
with Communications_with_User;          use Communications_with_User;
with Standard_Natural_Numbers;          use Standard_Natural_Numbers;
with Standard_Natural_Numbers_io;       use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;         use Standard_Floating_Numbers;
with Deca_Double_Numbers;               use Deca_Double_Numbers;
with Deca_Double_Numbers_io;            use Deca_Double_Numbers_io;
with DecaDobl_Complex_Numbers;
with DecaDobl_Complex_Numbers_io;       use DecaDobl_Complex_Numbers_io;
with DecaDobl_Complex_Vectors_io;
with DecaDobl_Complex_Series;
with DecaDobl_Complex_Series_io;        use DecaDobl_Complex_Series_io;
with DecaDobl_Complex_Random_Series;
with DecaDobl_Complex_Algebraic_Series;
with DecaDobl_Complex_Series_Norms;
with DecaDobl_Complex_Series_Functions;
with DecaDobl_Complex_Series_Transforms;

package body Test_DecaDobl_Complex_Series is

  procedure DecaDobl_Construct is

    i : constant integer := 123;
    first : constant DecaDobl_Complex_Series.Series
          := DecaDobl_Complex_Series.Create(i);
    second : DecaDobl_Complex_Series.Series(4);
    third : DecaDobl_Complex_Series.Series(4);

  begin
    text_io.put_line("The first series, the constant 123 : ");
    DecaDobl_Complex_Vectors_io.put_line(first.cff);
    text_io.put_line("The second series : ");
    second.cff(0) := DecaDobl_Complex_Numbers.Create(integer32(1));
    second.cff(1) := DecaDobl_Complex_Numbers.Create(integer32(-1));
    second.cff(2) := DecaDobl_Complex_Numbers.Create(integer32(0));
    second.cff(3) := DecaDobl_Complex_Numbers.Create(integer32(0));
    second.cff(4) := DecaDobl_Complex_Numbers.Create(integer32(0));
    DecaDobl_Complex_Vectors_io.put_line(second.cff);
    third := DecaDobl_Complex_Series.Inverse(second);
    text_io.put_line("The inverse of the second series : ");
    DecaDobl_Complex_Vectors_io.put_line(third.cff);
  end DecaDobl_Construct;

  procedure DecaDobl_Test_Creation ( degree : in integer32 ) is

    use DecaDobl_Complex_Numbers;
    use DecaDobl_Complex_Series;

    s : constant Link_to_Series := Create(1,degree);
    t,x,y,z : Link_to_Series;
    minone : constant deca_double := create(-1.0);

  begin
    put("One as series of degree "); put(degree,1); put_line(" :");
    put(s);
    t := Create(1,degree);
    t.cff(1) := Create(minone);
    put_line("The series 1 - t :"); put(t); 
    x := s/t;
    put_line("The series 1/(1-t) : "); put(x);
    y := x*t;
    put_line("Verifying multiplication with inverse : "); put(y);
    z := t*x;
    put_line("Verifying commutativity : "); put(z);
  end DecaDobl_Test_Creation;

  procedure DecaDobl_Test_Arithmetic ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;

    a,b,c : Series(degree);
    ans : character;

  begin
    a := DecaDobl_Complex_Random_Series.Random_Series(degree);
    put_line("The first random series A :"); put(a);
    b := DecaDobl_Complex_Random_Series.Random_Series(degree);
    put_line("The second random series B :"); put(b);
    c := a+b;
    put_line("The sum A + B :"); put(c);
    c := c-a;
    put_line("The sum A + B - A :"); put(c); 
    new_line;
    put("Continue ? (y/n) "); Ask_Yes_or_No(ans);
    if ans = 'y' then
      c := a*b;
      put_line("The product A*B :"); put(c);
      c := c/a;
      put_line("The product A*B/A :"); put(c);
    end if;
  end DecaDobl_Test_Arithmetic;

  procedure DecaDobl_Random_Test_sqrt ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;

    c : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    ans : character;
    x,y,z : Series(degree);
 
  begin
    put("Extra output during the computation ? (y/n) ");
    Ask_Yes_or_No(ans);
    new_line;
    put("A random series c of degree "); put(degree,1); put_line(" :");
    put(c);
    if ans = 'y'
     then x := DecaDobl_Complex_Algebraic_Series.sqrt(c,0,true);
     else x := DecaDobl_Complex_Algebraic_Series.sqrt(c,0);
    end if;
    put_line("The square root x of the random series :"); put(x);
    y := x*x;
    put_line("The square y of the square root x : "); put(y);
    z := y-c;
    put_line("The equation x*x - c :"); put(z);
  end DecaDobl_Random_Test_sqrt;

  procedure DecaDobl_Random_Test_root ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;

    c : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    n,i : natural32 := 0;
    ans : character;
    x,y,z : Series(degree);
 
  begin
    put("Give the power n in x**n - c : "); get(n);
    put("Give the index i of the root : "); get(i);
    new_line;
    put("Extra output during the computation ? (y/n) ");
    Ask_Yes_or_No(ans);
    new_line;
    put("A random series c of degree "); put(degree,1); put_line(" :");
    put(c);
    if ans = 'y'
     then x := DecaDobl_Complex_Algebraic_Series.Root(c,n,i,true);
     else x := DecaDobl_Complex_Algebraic_Series.Root(c,n,i);
    end if;
    put("The root x of index "); put(i,1);
    put_line(" of the random series :"); put(x);
    y := x**integer(n);
    put_line("The n-th power y of the root x : "); put(y);
    z := y-c;
    put_line("The equation x**n - c :"); put(z);
  end DecaDobl_Random_Test_root;

  procedure DecaDobl_Test_Conjugate ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;
    use DecaDobl_Complex_Series_Norms;

    s : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    c : constant Series(degree) := Conjugate(s);
    p,r,n,q,rq : Series(degree);

  begin
    put("A random series of degree "); put(degree,1); put_line(" :");
    put(s);
    put_line("Its conjugate : "); put(c);
    put_line("Conjugate(s)*s : "); put(c*s);
    put_line("s*Conjugate(s) : "); put(s*c);
    p := c*s;
    r := DecaDobl_Complex_Algebraic_Series.sqrt(p,0);
    put_line("The square root r of Conjugate(s)*s :"); put(r);
    n := s/r;
    put_line("The normalized series s is s/r :"); put(n);
    q := Conjugate(n)*n;
    rq := DecaDobl_Complex_Algebraic_Series.sqrt(q,0);
    put_line("The norm of the normalized series :"); put(rq);
  end DecaDobl_Test_Conjugate;

  procedure DecaDobl_Test_Norm ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;
    use DecaDobl_Complex_Series_Norms;

    s : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    nrm : constant Series(degree) := Norm(s);
    ns : constant Series(degree) := Normalize(s);
    nrm2 : constant Series(degree) := Norm(ns);
  
  begin
    put("A random series of degree "); put(degree,1); put_line(" :");
    put(s);
    put_line("Its norm :"); put(nrm);
    put("The max-norm of the series : ");
    put(Max_Norm(s),3); new_line;
    put("The two-norm of the series : ");
    put(Two_Norm(s),3); new_line;
    put_line("The normalized series :"); put(ns);
    put_line("The norm of the normalized series :"); put(nrm2);
    put("The max-norm of the normalized series : ");
    put(Max_Norm(ns),3); new_line;
    put("The two-norm of the normalized series : ");
    put(Two_Norm(ns),3); new_line;
  end DecaDobl_Test_Norm;

  procedure DecaDobl_Test_Shift ( degree : in integer32 ) is

    use DecaDobl_Complex_Numbers;
    use DecaDobl_Complex_Series;
    use DecaDobl_Complex_Series_Functions;

    s : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    zero : constant deca_double := create(0.0);
    rc : deca_double := zero;
    shifteds : Series(degree);
    cc,y,z : Complex_Number;

  begin
    put_line("Shifting the series parameter ...");
    put_line("on a random series s :"); put(s);
    skip_line;
    put("Give a real constant for the shift : "); get(rc);
    shifteds := Shift(s,rc);
    y := Eval(s,-rc);
    z := Eval(shifteds,zero);
    put("s(-shift constant) : "); put(y); new_line;
    put(" shifted series(0) : "); put(z); new_line;
    new_line;
    put_line("Testing with a complex shift ...");
    put("Give a complex number for the shift : "); get(cc);
    shifteds := Shift(s,cc);
    y := Eval(s,-cc);
    z := Eval(shifteds,zero);
    put("s(-shift constant) : "); put(y); new_line;
    put(" shifted series(0) : "); put(z); new_line;
  end DecaDobl_Test_Shift;

  procedure DecaDobl_Test_Transform ( degree : in integer32 ) is

    use DecaDobl_Complex_Series;
    use DecaDobl_Complex_Series_Transforms;

    s : constant Series(degree)
      := DecaDobl_Complex_Random_Series.Random_Series(degree);
    c : deca_double := create(0.0);
    sc : Series(degree);
    idx : integer32;
    mxc : deca_double;

  begin
    put_line("a random series s :"); put(s);
    skip_line;
    put("Give a deca double : "); get(c);
    put("-> your constant c : "); put(c); new_line;
    sc := DecaDobl_Complex_Series_Transforms.Scale(s,c);
    put_line("the series s scaled by c, s(c*t) :"); put(sc);
    Maximum_Coefficient_Modulus(sc,idx,mxc);
    put("the index : "); put(idx,1);
    put("  maximum modulus : "); put(mxc); new_line;
    Coefficient_Modulus_Transform(sc,idx,mxc);
    put_line("the transformed series :"); put(sc);
  end DecaDobl_Test_Transform;

  procedure Main is

    ans : character;
    degree : integer32 := 0;

  begin
    new_line;
    put_line("MENU with testing operations :");
    put_line("  0. test the basic construct methods");
    put_line("  1. test the computation of 1/(1-t) for any degree");
    put_line("  2. test arithmetic");
    put_line("  3. square root of a random series");
    put_line("  4. p-th root of a random series");
    put_line("  5. test complex conjugate of a series");
    put_line("  6. test the norm of a series");
    put_line("  7. test shift of series parameter");
    put_line("  8. test coefficient modulus transforms");
    put("Type 0, 1, 2, 3, 4, 5, 6, 7, or 8 to select a test : ");
    Ask_Alternative(ans,"012345678");
    if ans /= '0' then
      new_line;
      put("Give the degree of the series : "); get(degree);
    end if;
    new_line;
    case ans is 
      when '0' => DecaDobl_Construct;
      when '1' => DecaDobl_Test_Creation(degree);
      when '2' => DecaDobl_Test_Arithmetic(degree);
      when '3' => DecaDobl_Random_Test_Sqrt(degree);
      when '4' => DecaDobl_Random_Test_root(degree);
      when '5' => DecaDobl_Test_Conjugate(degree);
      when '6' => DecaDobl_Test_Norm(degree);
      when '7' => DecaDobl_Test_Shift(degree);
      when '8' => DecaDobl_Test_Transform(degree);
      when others => null;
    end case;
  end Main;

end Test_DecaDobl_Complex_Series;
