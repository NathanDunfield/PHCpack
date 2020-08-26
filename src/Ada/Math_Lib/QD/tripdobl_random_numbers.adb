with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Random_Numbers;

package body TripDobl_Random_Numbers is

  function Random return triple_double is

    res : triple_double;
    first : constant double_float := Standard_Random_Numbers.Random; 
    second : constant double_float := Standard_Random_Numbers.Random; 
    third : constant double_float := Standard_Random_Numbers.Random; 
    eps : constant double_float := 2.0**(-52);
    dd_eps : constant double_float := 2.0**(-104);

  begin
    res := create(first);
    res := res + eps*second;
    res := res + dd_eps*third;
    return res;
  end random;

  procedure Random_Triple_Double
              ( seed : in out integer32; f : out triple_double ) is

    res : triple_double;
    first,second,third : double_float;
    eps : constant double_float := 2.0**(-52);
    dd_eps : constant double_float := 2.0**(-104);

  begin
    Standard_Random_Numbers.Random_Double_Float(seed,first);
    Standard_Random_Numbers.Random_Double_Float(seed,second);
    Standard_Random_Numbers.Random_Double_Float(seed,third);
    res := create(first);
    res := res + eps*second;
    res := res + dd_eps*third;
    f := res;
  end Random_Triple_Double;

  function Random return Complex_Number is

    res : Complex_Number;
    realpart : constant triple_double := Random; 
    imagpart : constant triple_double := Random; 

  begin
    res := Create(realpart,imagpart);
    return res;
  end Random;

  procedure Random_Complex_Number
              ( seed : in out integer32; c : out Complex_Number ) is

    realpart,imagpart : triple_double;

  begin
    Random_Triple_Double(seed,realpart);
    Random_Triple_Double(seed,imagpart);
    c := Create(realpart,imagpart);
  end Random_Complex_Number;

end TripDobl_Random_Numbers; 
