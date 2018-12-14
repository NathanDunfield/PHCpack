with text_io;                            use text_io;
with Standard_Natural_Numbers;           use Standard_Natural_Numbers;
with Standard_Integer_Numbers;           use Standard_Integer_Numbers;
with Standard_Floating_Numbers;          use Standard_Floating_Numbers;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Numbers;           use Standard_Complex_Numbers;
with Standard_Complex_Vectors;
with Standard_Complex_VecVecs;
with Standard_Complex_Series_Vectors;
with Standard_CSeries_Poly_Systems;
with Standard_Pade_Approximants;
with Standard_Homotopy;
with Series_and_Homotopies;
with Series_and_Predictors;
with Series_and_Trackers;
with Homotopy_Newton_Steps;

package body Standard_SeriesPade_Tracker is

-- INTERNAL DATA :

  nbeqs : integer32;
  homconpars : Homotopy_Continuation_Parameters.Link_to_Parameters;
  htp : Standard_CSeries_Poly_Systems.Link_to_Poly_Sys;
  current : Link_to_Solution;

-- CONSTRUCTORS :

  procedure Init ( pars : in Homotopy_Continuation_Parameters.Parameters ) is
  begin
    homconpars := new Homotopy_Continuation_Parameters.Parameters'(pars);
  end Init;

  procedure Init ( p,q : in Link_to_Poly_Sys ) is

    tpow : constant natural32 := 2;
    gamma : constant Complex_Number := homconpars.gamma;

  begin
    Standard_Homotopy.Create(p.all,q.all,tpow,gamma);
    nbeqs := p'last;
    declare
      h : Standard_Complex_Poly_Systems.Poly_Sys(1..nbeqs)
        := Standard_Homotopy.Homotopy_System;
      s : Standard_CSeries_Poly_Systems.Poly_Sys(1..nbeqs)
        := Series_and_Homotopies.Create(h,nbeqs+1,false);
    begin
      htp := new Standard_CSeries_Poly_Systems.Poly_Sys'(s);
    end;
  end Init;

  procedure Init ( s : in Link_to_Solution ) is
  begin
    current := s;
  end Init;

-- PREDICTOR-CORRECTOR STAGE :

  procedure Predict ( fail : out boolean; verbose : in boolean := false ) is

    numdeg : constant integer32 := integer32(homconpars.numdeg);
    dendeg : constant integer32 := integer32(homconpars.dendeg);
    maxdeg : constant integer32 := numdeg + dendeg + 2;
    nit : constant integer32 := integer32(homconpars.corsteps);
    sol : Standard_Complex_Vectors.Vector(1..current.n) := current.v;
    srv : Standard_Complex_Series_Vectors.Vector(1..current.n);
    eva : Standard_Complex_Series_Vectors.Vector(1..nbeqs);
    pv : Standard_Pade_Approximants.Pade_Vector(srv'range);
    poles : Standard_Complex_VecVecs.VecVec(pv'range);
    t,step,frp,predres : double_float;
    tolcff : constant double_float := homconpars.epsilon;
    alpha : constant double_float := homconpars.alpha;

  begin
    Series_and_Predictors.Newton_Prediction(maxdeg,nit,htp.all,sol,srv,eva);
    Series_and_Predictors.Pade_Approximants(numdeg,dendeg,srv,pv,poles,frp);
    if verbose
     then put("The smallest forward pole radius :"); put(frp,2); new_line;
    end if;
    Standard_Complex_VecVecs.Clear(poles);
    step := Series_and_Predictors.Set_Step_Size(eva,tolcff,alpha);
    step := homconpars.sbeta*step;
    Standard_Complex_Series_Vectors.Clear(eva);
    if frp > 0.0 then
      step := Series_and_Predictors.Cap_Step_Size(step,frp,homconpars.pbeta);
    end if;
    t := Standard_Complex_Numbers.REAL_PART(current.t);
    Series_and_Trackers.Set_Step(t,step,homconpars.maxsize,1.0);
    if verbose
     then put("Step size :"); put(step,2); put("  t ="); put(t,2);
    end if;
    loop
      sol := Series_and_Predictors.Predicted_Solution(pv,step);
      predres := Series_and_Trackers.Residual_Prediction(htp.all,sol,step);
      if verbose
       then put("  residual :"); put(predres,2); new_line;
      end if;
      exit when (predres <= alpha);
      t := t - step; step := step/2.0; t := t + step;
      if verbose
       then put("Step size :"); put(step,2); put("  t ="); put(t,2);
      end if;
      exit when (step < homconpars.minsize);
    end loop;
    current.t := Standard_Complex_Numbers.Create(t);
    current.v := sol;
    if t = 1.0 
     then fail := false;
     else fail := (step < homconpars.minsize);
    end if;
    Standard_Complex_VecVecs.Clear(poles);
    Standard_Complex_Series_Vectors.Clear(eva);
    Standard_Complex_Series_Vectors.Clear(srv);
    Standard_Pade_Approximants.Clear(pv);
    Series_and_Homotopies.Shift(htp.all,-step);
  end Predict;

  procedure Correct ( fail : out boolean; verbose : in boolean := false ) is

    t : constant double_float := REAL_PART(current.t);
    nbrit : natural32 := 0;

  begin
    if verbose then
      Homotopy_Newton_Steps.Correct
        (standard_output,nbeqs,t,homconpars.tolres,homconpars.corsteps,nbrit,
         current.v,current.err,current.rco,current.res,fail,true);
    else
      Homotopy_Newton_Steps.Correct
        (nbeqs,t,homconpars.tolres,homconpars.corsteps,nbrit,
         current.v,current.err,current.rco,current.res,fail);
    end if;
  end Correct;

  procedure Predict_and_Correct
              ( fail : out boolean; verbose : in boolean := false ) is
  begin
    Predict(fail,verbose);
    if not fail
     then Correct(fail,verbose);
    end if;
  end Predict_and_Correct;

-- SELECTORS :

  function Get_Parameters
    return Homotopy_Continuation_Parameters.Link_to_Parameters is

  begin
    return homconpars;
  end Get_Parameters;

  function Get_Current_Solution return Link_to_Solution is
  begin
    return current;
  end Get_Current_Solution;

-- DESTRUCTOR :

  procedure Clear is
  begin
    Homotopy_Continuation_Parameters.Clear(homconpars);
    Standard_CSeries_Poly_Systems.Clear(htp);
  end Clear;

end Standard_SeriesPade_Tracker;