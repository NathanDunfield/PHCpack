with Timing_Package;                     use Timing_Package;
with Standard_Natural_Numbers_io;        use Standard_Natural_Numbers_io;
with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Standard_Complex_Solutions_io;
with DoblDobl_Complex_Solutions_io;
with QuadDobl_Complex_Solutions_io;
with Standard_CSeries_Jaco_Matrices;
with Homotopy_Mixed_Residuals;
with Standard_Pade_Trackers;
with DoblDobl_Pade_Trackers;
with QuadDobl_Pade_Trackers;

package body Series_and_Trackers is

  procedure Update_Counters
              ( mincnt,maxcnt : in out natural32; cnt : in natural32 ) is
  begin
    if cnt < mincnt then
      mincnt := cnt;
    elsif cnt > maxcnt then
      maxcnt := cnt;
    end if;
  end Update_Counters;

  procedure Update_MinMax
              ( smallest,largest : in out double_float;
                minsize,maxsize : in double_float ) is
  begin
    if minsize < smallest
     then smallest := minsize;
    end if;
    if maxsize > largest
     then largest := maxsize;
    end if;
  end Update_MinMax;

  procedure Track_Many_Paths
              ( file : in file_type;
                jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in Standard_CSeries_Poly_Systems.Poly_Sys;
                sols : in out Standard_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                monitor,verbose : in boolean := false;
                vrblvl : in integer32 := 0 ) is

    use Standard_Complex_Solutions;

    abh : Standard_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.Standard_AbsVal_Homotopy;
    nvr : constant integer32 := Head_Of(sols).n;
    fhm : Standard_CSeries_Poly_SysFun.Eval_Coeff_Poly_Sys(hom'range)
        := Standard_CSeries_Poly_SysFun.Create(hom);
    fcf : Standard_Complex_Series_VecVecs.VecVec(hom'range)
        := Standard_CSeries_Poly_SysFun.Coeff(hom);
    ejm : Standard_CSeries_Jaco_Matrices.Eval_Coeff_Jaco_Mat(hom'range,1..nvr);
    mlt : Standard_CSeries_Jaco_Matrices.Mult_Factors(hom'range,1..nvr);
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    timer : Timing_Widget;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 1 ...");
    end if;
    Standard_CSeries_Jaco_Matrices.Create(hom,ejm,mlt);
    minnbrsteps := pars.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (pars.maxsteps+1)*pars.corsteps+1; maxnbrcorrs := 0;
    smallest := pars.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put(file,"Tracking path "); put(file,i,1); put_line(file," ...");
      end if;
      Standard_Pade_Trackers.Track_One_Path
        (file,abh,jm,hs,fhm,fcf,ejm,mlt,ls.all,pars,nbrsteps,
         nbrcorrs,cntcut,cntfail,minsize,maxsize,verbose,vrblvl-1);
      if verbose then
        Write_Path_Statistics
          (file,nbrsteps,nbrcorrs,cntcut,cntfail,minsize,maxsize);
      end if;
      put(file,"Solution "); put(file,i,1); put_line(file," :");
      Standard_Complex_Solutions_io.put(file,ls.all); new_line(file);
      tmp := Tail_Of(tmp);
      Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    Write_Total_Path_Statistics
      (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
    new_line(file);
    print_times(file,timer,"Tracking in double precision.");
    Standard_CSeries_Poly_SysFun.Clear(fhm);
    Standard_Complex_Series_VecVecs.Clear(fcf);
    Standard_CSeries_Jaco_Matrices.Clear(ejm);
    Standard_CSeries_Jaco_Matrices.Clear(mlt);
    Standard_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Track_Many_Paths
              ( file : in file_type;
                jm : in DoblDobl_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in DoblDobl_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in DoblDobl_CSeries_Poly_Systems.Poly_Sys;
                sols : in out DoblDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                monitor,verbose : in boolean := false;
                vrblvl : in integer32 := 0 ) is

    use DoblDobl_Complex_Solutions;

    abh : DoblDobl_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.DoblDobl_AbsVal_Homotopy;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    timer : Timing_Widget;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 2 ...");
    end if;
    minnbrsteps := pars.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (pars.maxsteps+1)*pars.corsteps+1; maxnbrcorrs := 0;
    smallest := pars.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put(file,"Tracking path "); put(file,i,1); put_line(file," ...");
      end if;
      DoblDobl_Pade_Trackers.Track_One_Path
        (file,abh,jm,hs,hom,ls.all,pars,nbrsteps,nbrcorrs,cntcut,cntfail,
         minsize,maxsize,verbose,vrblvl-1);
      if verbose then
        Write_Path_Statistics
          (file,nbrsteps,nbrcorrs,cntcut,cntfail,minsize,maxsize);
      end if;
      put(file,"Solution "); put(file,i,1); put_line(file," :");
      DoblDobl_Complex_Solutions_io.put(file,ls.all); new_line(file);
      tmp := Tail_Of(tmp);
      Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    Write_Total_Path_Statistics
      (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
    new_line(file);
    print_times(file,timer,"Tracking in double double precision.");
    DoblDobl_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Track_Many_Paths
              ( file : in file_type;
                jm : in QuadDobl_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in QuadDobl_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in QuadDobl_CSeries_Poly_Systems.Poly_Sys;
                sols : in out QuadDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                monitor,verbose : in boolean := false;
                vrblvl : in integer32 := 0 ) is

    use QuadDobl_Complex_Solutions;

    abh : QuadDobl_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.QuadDobl_AbsVal_Homotopy;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    timer : Timing_Widget;
    nbrsteps,minnbrsteps,maxnbrsteps : natural32;
    nbrcorrs,minnbrcorrs,maxnbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize,smallest,largest : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 3 ...");
    end if;
    minnbrsteps := pars.maxsteps+1; maxnbrsteps := 0;
    minnbrcorrs := (pars.maxsteps+1)*pars.corsteps+1; maxnbrcorrs := 0;
    smallest := pars.maxsize; largest := 0.0;
    tstart(timer);
    for i in 1..len loop
      ls := Head_Of(tmp);
      if monitor
       then put(file,"Tracking path "); put(file,i,1); put_line(file," ...");
      end if;
      QuadDobl_Pade_Trackers.Track_One_Path
        (file,abh,jm,hs,hom,ls.all,pars,nbrsteps,nbrcorrs,cntcut,cntfail,
         minsize,maxsize,verbose,vrblvl-1);
      if verbose then
        Write_Path_Statistics
          (file,nbrsteps,nbrcorrs,cntcut,cntfail,minsize,maxsize);
      end if;
      put(file,"Solution "); put(file,i,1); put_line(file," :");
      QuadDobl_Complex_Solutions_io.put(file,ls.all); new_line(file);
      tmp := Tail_Of(tmp);
      Update_Counters(minnbrsteps,maxnbrsteps,nbrsteps);
      Update_Counters(minnbrcorrs,maxnbrcorrs,nbrcorrs);
      Update_MinMax(smallest,largest,minsize,maxsize);
    end loop;
    tstop(timer);
    Write_Total_Path_Statistics
      (file,minnbrsteps,maxnbrsteps,minnbrcorrs,maxnbrcorrs,smallest,largest);
    new_line(file);
    print_times(file,timer,"Tracking in quad double precision.");
    QuadDobl_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Track_Many_Paths
              ( jm : in Standard_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in Standard_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in Standard_CSeries_Poly_Systems.Poly_Sys;
                sols : in out Standard_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                vrblvl : in integer32 := 0 ) is

    use Standard_Complex_Solutions;

    abh : Standard_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.Standard_AbsVal_Homotopy;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    nbrsteps,nbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 4 ...");
    end if;
    for i in 1..len loop
      ls := Head_Of(tmp);
      Standard_Pade_Trackers.Track_One_Path
        (abh,jm,hs,hom,ls.all,pars,nbrsteps,nbrcorrs,cntcut,cntfail,
         minsize,maxsize,vrblvl-1);
      tmp := Tail_Of(tmp);
    end loop;
    Standard_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Track_Many_Paths
              ( jm : in DoblDobl_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in DoblDobl_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in DoblDobl_CSeries_Poly_Systems.Poly_Sys;
                sols : in out DoblDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                vrblvl : in integer32 := 0 ) is

    use DoblDobl_Complex_Solutions;

    abh : DoblDobl_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.DoblDobl_AbsVal_Homotopy;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    nbrsteps,nbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 5 ...");
    end if;
    for i in 1..len loop
      ls := Head_Of(tmp);
      DoblDobl_Pade_Trackers.Track_One_Path
        (abh,jm,hs,hom,ls.all,pars,nbrsteps,nbrcorrs,cntcut,cntfail,
         minsize,maxsize,vrblvl-1);
      tmp := Tail_Of(tmp);
    end loop;
    DoblDobl_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Track_Many_Paths
              ( jm : in QuadDobl_Complex_Jaco_Matrices.Link_to_Jaco_Mat;
                hs : in QuadDobl_Complex_Hessians.Link_to_Array_of_Hessians;
                hom : in QuadDobl_CSeries_Poly_Systems.Poly_Sys;
                sols : in out QuadDobl_Complex_Solutions.Solution_List;
                pars : in Homotopy_Continuation_Parameters.Parameters;
                vrblvl : in integer32 := 0 ) is

    use QuadDobl_Complex_Solutions;

    abh : QuadDobl_Complex_Poly_SysFun.Eval_Poly_Sys(hom'range)
        := Homotopy_Mixed_Residuals.QuadDobl_AbsVal_Homotopy;
    tmp : Solution_List := sols;
    len : constant integer32 := integer32(Length_Of(sols));
    ls : Link_to_Solution;
    nbrsteps,nbrcorrs,cntcut,cntfail : natural32;
    minsize,maxsize : double_float;

  begin
    if vrblvl > 0
     then put_line("-> in series_and_trackers.Track_Many_Paths 6 ...");
    end if;
    for i in 1..len loop
      ls := Head_Of(tmp);
      QuadDobl_Pade_Trackers.Track_One_Path
        (abh,jm,hs,hom,ls.all,pars,nbrsteps,nbrcorrs,cntcut,cntfail,
         minsize,maxsize,vrblvl-1);
      tmp := Tail_Of(tmp);
    end loop;
    QuadDobl_Complex_Poly_SysFun.Clear(abh);
  end Track_Many_Paths;

  procedure Write_Path_Statistics
              ( file : in file_type;
                nbrsteps,nbrcorrs,cntcut,cntfail : in natural32;
                minsize,maxsize : in double_float ) is
  begin
    put(file,"The total number of steps on the path     : ");
    put(file,nbrsteps,1); new_line(file);
    put(file,"Total number of correct steps on the path : ");
    put(file,nbrcorrs,1); new_line(file);
    put(file,"Number of predictor residuals cut step size : ");
    put(file,cntcut,1); new_line(file);
    put(file,"Number of corrector failures on the path  : ");
    put(file,cntfail,1); new_line(file);
    put(file,"The smallest step size on the path        :");
    put(file,minsize,2); new_line(file);
    put(file,"The largest step size on the path         :");
    put(file,maxsize,2); new_line(file);
  end Write_Path_Statistics;

  procedure Write_Total_Path_Statistics
              ( file : in file_type;
                minnbrsteps,maxnbrsteps : in natural32;
                minnbrcorrs,maxnbrcorrs : in natural32;
                smallestsize,largestsize : in double_float ) is
  begin
    new_line(file);
    put(file,"The smallest number of total steps : ");
    put(file,minnbrsteps,1); new_line(file);
    put(file,"The largest number of total steps  : ");
    put(file,maxnbrsteps,1); new_line(file);
    put(file,"The smallest number of corrector iterations : ");
    put(file,minnbrcorrs,1); new_line(file);
    put(file,"The largest number of corrector iterations  : ");
    put(file,maxnbrcorrs,1); new_line(file);
    put(file,"The smallest step size on a path :");
    put(file,smallestsize,2); new_line(file);
    put(file,"The largest step size on a path  :");
    put(file,largestsize,2); new_line(file);
  end Write_Total_Path_Statistics;

end Series_and_Trackers;
