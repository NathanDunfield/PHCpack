with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Double_Double_Numbers;              use Double_Double_Numbers;
with Double_Double_Numbers_io;           use Double_Double_Numbers_io;
with DoblDobl_Complex_Numbers;
with DoblDobl_Complex_Numbers_io;        use DoblDobl_Complex_Numbers_io;
with DoblDobl_Random_Numbers;
with Standard_Integer_Vectors;
with DoblDobl_Complex_VecVecs;
with DoblDobl_Complex_VecVecs_io;        use DoblDobl_Complex_VecVecs_io;
with DoblDobl_Complex_Polynomials;
with DoblDobl_Complex_Poly_Systems;
with DoblDobl_Complex_Poly_Systems_io;   use DoblDobl_Complex_Poly_Systems_io;
with DoblDobl_System_and_Solutions_io;
with DoblDobl_Homotopy;
with Standard_Parameter_Systems;
with Solution_Drops;
with DoblDobl_Homotopy_Convolutions_io;
with DoblDobl_Newton_Convolutions;
with DoblDobl_Newton_Convolution_Steps;
with Convergence_Radius_Estimates;

package body DoblDobl_Fabry_on_Homotopy is

  procedure DoblDobl_Newton_Fabry
              ( cfs : in DoblDobl_Speelpenning_Convolutions.Link_to_System;
                sol : in DoblDobl_Complex_Vectors.Vector ) is

    dim : constant integer32 := sol'last;
    deg : constant integer32 := cfs.deg;
    scf : constant DoblDobl_Complex_VecVecs.VecVec(1..dim)
        := DoblDobl_Newton_Convolutions.Series_Coefficients(sol,deg);
    maxit,nbrit : integer32 := 0;
    ans : character;
    tol : double_float := 1.0E-20;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : DoblDobl_Complex_Vectors.Link_to_Vector
        := new DoblDobl_Complex_Vectors.Vector(1..dim); -- dim = #equations
    fail : boolean;
    absdx,rcond,rad,err : double_double;
    scale : constant boolean := false;
    zpt : DoblDobl_Complex_Numbers.Complex_Number;

  begin
    new_line;
    put("Give the maximum number of iterations : "); get(maxit);
    loop
      put("Tolerance for the accuracy : "); put(tol,3); new_line;
      put("Change the tolerance ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      if ans = 'y' then
        put("Give the new tolerance for the accuracy : "); get(tol);
      end if;
    end loop;
    DoblDobl_Newton_Convolution_Steps.LU_Newton_Steps
      (standard_output,cfs,scf,maxit,nbrit,tol,absdx,fail,rcond,
       ipvt,wrk,scale);
    put_line("The coefficients of the series : "); put_line(scf);
    Convergence_Radius_Estimates.Fabry
      (standard_output,scf,zpt,rad,err,fail,1,true);
    put("the convergence radius : "); put(rad,3);
    put("   error estimate : "); put(err,3); new_line;
    put(zpt); put_line("  estimates nearest singularity");
    if fail
     then put_line("Reported failure.");
     else put_line("Reported success.");
    end if;
    DoblDobl_Complex_Vectors.Clear(wrk);
  end DoblDobl_Newton_Fabry;

  procedure DoblDobl_Run
              ( nbequ,idxpar,deg : in integer32;
                sols : in out DoblDobl_Complex_Solutions.Solution_List ) is

    cvh : DoblDobl_Speelpenning_Convolutions.Link_to_System;
    tmp : DoblDobl_Complex_Solutions.Solution_List := sols;
    ls : DoblDobl_Complex_Solutions.Link_to_Solution;
    ans : character;

  begin
    cvh := DoblDobl_Homotopy_Convolutions_io.Make_Homotopy(nbequ,idxpar,deg);
    while not DoblDobl_Complex_Solutions.Is_Null(tmp) loop
      ls := DoblDobl_Complex_Solutions.Head_Of(tmp);
      DoblDobl_Newton_Fabry(cvh,ls.v);
      put("Continue with the next solution ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      tmp := DoblDobl_Complex_Solutions.Tail_Of(tmp);
    end loop;
  end DoblDobl_Run;

  procedure DoblDobl_Artificial_Setup is

    target,start : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : DoblDobl_Complex_Solutions.Solution_List;
    gamma : DoblDobl_Complex_Numbers.Complex_Number;
    nbequ,nbvar,nbsols,deg : integer32 := 0;
    ans : character;

    use DoblDobl_Complex_Polynomials;

  begin
    new_line;
    put_line("Reading the name of a file for the target system ...");
    get(target);
    nbequ := target'last;
    nbvar := integer32(Number_of_Unknowns(target(target'first)));
    new_line;
    put("Read "); put(nbequ,1); put(" polynomials in ");
    put(nbvar,1); put_line(" variables.");
    new_line;
    put_line
      ("Reading the name of a file for the start system and solutions ...");
    DoblDobl_System_and_Solutions_io.get(start,sols);
    nbsols := integer32(DoblDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      nbvar := DoblDobl_Complex_Solutions.Head_Of(sols).n;
      new_line;
      put("Read "); put(nbsols,1); put(" solutions in dimension ");
      put(nbvar,1); put_line(".");
      new_line;
      put("Random gamma ? (y/n) "); Ask_Yes_or_No(ans);
      if ans = 'y'
       then gamma := DoblDobl_Random_Numbers.Random1;
       else gamma := DoblDobl_Complex_Numbers.Create(integer(1));
      end if;
      DoblDobl_Homotopy.Create(target.all,start.all,1,gamma);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      DoblDobl_Run(nbequ,nbvar+1,deg,sols);
    end if;
  end DoblDobl_Artificial_Setup;

  procedure DoblDobl_Natural_Setup is

    hom : DoblDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols,dropsols : DoblDobl_Complex_Solutions.Solution_List;
    nbequ,sysnbvar,solnbvar,nbsols,idxpar,deg : integer32 := 0;
    par : Standard_Integer_Vectors.Vector(1..1);

    use DoblDobl_Complex_Polynomials;

  begin
    new_line;
    put_line("Reading the name of a file for a homotopy ...");
    DoblDobl_System_and_Solutions_io.get(hom,sols);
    nbequ := hom'last;
    sysnbvar := integer32(Number_of_Unknowns(hom(hom'first)));
    new_line;
    put("Read "); put(nbequ,1); put(" polynomials in ");
    put(sysnbvar,1); put_line(" variables.");
    nbsols := integer32(DoblDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      solnbvar := DoblDobl_Complex_Solutions.Head_Of(sols).n;
      put("Read "); put(nbsols,1); put(" solutions in dimension ");
      put(solnbvar,1); put_line(".");
      new_line;
      par := Standard_Parameter_Systems.Define_Parameters(nbequ,sysnbvar,1);
      idxpar := par(1);
      put("The index to the continuation parameter : ");
      put(idxpar,1); new_line;
      if solnbvar = nbequ then
        put_line("Solution dimension is okay.");
      else
        put_line("Need to drop one coordinate of each solution.");
        dropsols := Solution_Drops.Drop(sols,natural32(idxpar));
      end if;
      DoblDobl_Homotopy.Create(hom.all,idxpar);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      if solnbvar = nbequ
       then DoblDobl_Run(nbequ,idxpar,deg,sols);
       else DoblDobl_Run(nbequ,idxpar,deg,dropsols);
      end if;
    end if;
  end DoblDobl_Natural_Setup;

  procedure Main is

    ans : character;

  begin
    new_line;
    put("Artificial-parameter homotopy ? (y/n) "); Ask_Yes_or_No(ans);
    if ans = 'y'
     then DoblDobl_Artificial_Setup;
     else DoblDobl_Natural_Setup;
    end if;
  end Main;

end DoblDobl_Fabry_on_Homotopy;
