with text_io;                            use text_io;
with Communications_with_User;           use Communications_with_User;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Octo_Double_Numbers;                use Octo_Double_Numbers;
with Octo_Double_Numbers_io;             use Octo_Double_Numbers_io;
with OctoDobl_Complex_Numbers;
with OctoDobl_Complex_Numbers_io;        use OctoDobl_Complex_Numbers_io;
with OctoDobl_Random_Numbers;
with Standard_Integer_Vectors;
with OctoDobl_Complex_VecVecs;
with OctoDobl_Complex_VecVecs_io;        use OctoDobl_Complex_VecVecs_io;
with OctoDobl_Complex_Polynomials;
with OctoDobl_Complex_Poly_Systems;
with OctoDobl_Complex_Poly_Systems_io;   use OctoDobl_Complex_Poly_Systems_io;
with OctoDobl_System_and_Solutions_io;
with OctoDobl_Homotopy;
with Standard_Parameter_Systems;
with Solution_Drops;
with OctoDobl_Homotopy_Convolutions_io;
with OctoDobl_Newton_Convolutions;
with OctoDobl_Newton_Convolution_Steps;
with Convergence_Radius_Estimates;

package body OctoDobl_Fabry_on_Homotopy is

  procedure OctoDobl_Newton_Fabry
              ( cfs : in OctoDobl_Speelpenning_Convolutions.Link_to_System;
                sol : in OctoDobl_Complex_Vectors.Vector ) is

    dim : constant integer32 := sol'last;
    deg : constant integer32 := cfs.deg;
    scf : constant OctoDobl_Complex_VecVecs.VecVec(1..dim)
        := OctoDobl_Newton_Convolutions.Series_Coefficients(sol,deg);
    maxit,nbrit : integer32 := 0;
    ans : character;
    tol : double_float := 1.0E-32;
    ipvt : Standard_Integer_Vectors.Vector(1..dim);
    wrk : OctoDobl_Complex_Vectors.Link_to_Vector
        := new OctoDobl_Complex_Vectors.Vector(1..dim); -- dim = #equations
    fail : boolean;
    absdx,rcond,rad,err : octo_double;
    scale : constant boolean := false;
    zpt : OctoDobl_Complex_Numbers.Complex_Number;

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
    OctoDobl_Newton_Convolution_Steps.LU_Newton_Steps
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
    OctoDobl_Complex_Vectors.Clear(wrk);
  end OctoDobl_Newton_Fabry;

  procedure OctoDobl_Run
              ( nbequ,idxpar,deg : in integer32;
                sols : in out OctoDobl_Complex_Solutions.Solution_List ) is

    cvh : OctoDobl_Speelpenning_Convolutions.Link_to_System;
    tmp : OctoDobl_Complex_Solutions.Solution_List := sols;
    ls : OctoDobl_Complex_Solutions.Link_to_Solution;
    ans : character;

  begin
    cvh := OctoDobl_Homotopy_Convolutions_io.Make_Homotopy(nbequ,idxpar,deg);
    while not OctoDobl_Complex_Solutions.Is_Null(tmp) loop
      ls := OctoDobl_Complex_Solutions.Head_Of(tmp);
      OctoDobl_Newton_Fabry(cvh,ls.v);
      put("Continue with the next solution ? (y/n) "); Ask_Yes_or_No(ans);
      exit when (ans /= 'y');
      tmp := OctoDobl_Complex_Solutions.Tail_Of(tmp);
    end loop;
  end OctoDobl_Run;

  procedure OctoDobl_Artificial_Setup is

    target,start : OctoDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols : OctoDobl_Complex_Solutions.Solution_List;
    gamma : OctoDobl_Complex_Numbers.Complex_Number;
    nbequ,nbvar,nbsols,deg : integer32 := 0;
    ans : character;

    use OctoDobl_Complex_Polynomials;

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
    OctoDobl_System_and_Solutions_io.get(start,sols);
    nbsols := integer32(OctoDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      nbvar := OctoDobl_Complex_Solutions.Head_Of(sols).n;
      new_line;
      put("Read "); put(nbsols,1); put(" solutions in dimension ");
      put(nbvar,1); put_line(".");
      new_line;
      put("Random gamma ? (y/n) "); Ask_Yes_or_No(ans);
      if ans = 'y'
       then gamma := OctoDobl_Random_Numbers.Random1;
       else gamma := OctoDobl_Complex_Numbers.Create(integer(1));
      end if;
      OctoDobl_Homotopy.Create(target.all,start.all,1,gamma);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      OctoDobl_Run(nbequ,nbvar+1,deg,sols);
    end if;
  end OctoDobl_Artificial_Setup;

  procedure OctoDobl_Natural_Setup is

    hom : OctoDobl_Complex_Poly_Systems.Link_to_Poly_Sys;
    sols,dropsols : OctoDobl_Complex_Solutions.Solution_List;
    nbequ,sysnbvar,solnbvar,nbsols,idxpar,deg : integer32 := 0;
    par : Standard_Integer_Vectors.Vector(1..1);

    use OctoDobl_Complex_Polynomials;

  begin
    new_line;
    put_line("Reading the name of a file for a homotopy ...");
    OctoDobl_System_and_Solutions_io.get(hom,sols);
    nbequ := hom'last;
    sysnbvar := integer32(Number_of_Unknowns(hom(hom'first)));
    new_line;
    put("Read "); put(nbequ,1); put(" polynomials in ");
    put(sysnbvar,1); put_line(" variables.");
    nbsols := integer32(OctoDobl_Complex_Solutions.Length_Of(sols));
    if nbsols = 0 then
      put_line("No solutions read.");
    else
      solnbvar := OctoDobl_Complex_Solutions.Head_Of(sols).n;
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
      OctoDobl_Homotopy.Create(hom.all,idxpar);
      new_line;
      put("Give the degree of the power series : "); get(deg);
      if solnbvar = nbequ
       then OctoDobl_Run(nbequ,idxpar,deg,sols);
       else OctoDobl_Run(nbequ,idxpar,deg,dropsols);
      end if;
    end if;
  end OctoDobl_Natural_Setup;

  procedure Main is

    ans : character;

  begin
    new_line;
    put("Artificial-parameter homotopy ? (y/n) "); Ask_Yes_or_No(ans);
    if ans = 'y'
     then OctoDobl_Artificial_Setup;
     else OctoDobl_Natural_Setup;
    end if;
  end Main;

end OctoDobl_Fabry_on_Homotopy;
