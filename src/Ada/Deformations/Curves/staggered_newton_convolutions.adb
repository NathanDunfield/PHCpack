with Standard_Integer_Numbers_io;        use Standard_Integer_Numbers_io;
with Standard_Floating_Numbers_io;       use Standard_Floating_Numbers_io;
with Newton_Convolutions;
with Newton_Coefficient_Convolutions;

package body Staggered_Newton_Convolutions is

-- INLINED NEWTON STEPS WITH LU WITHOUT CONDITION NUMBER ESTIMATE :

  procedure Inlined_LU_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                rc,ic : in Standard_Floating_VecVecs.Link_to_VecVec;
                rv,iv : in Standard_Floating_VecVecVecs.Link_to_VecVecVec;
                rb,ib : in Standard_Floating_VecVecs.Link_to_VecVec;
                ry,iy : in Standard_Floating_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put("-> in staggered_newton_convolutions.");
      put_line("Inlined_LU_Newton_Steps 1 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.Inlined_LU_Newton_Step
        (wrkdeg,csr,scf,rx,ix,absdx,info,ipvt,
         rc,ic,rv,iv,rb,ib,ry,iy,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end Inlined_LU_Newton_Steps;

  procedure Inlined_LU_Newton_Steps
              ( file : in file_type;
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                rc,ic : in Standard_Floating_VecVecs.Link_to_VecVec;
                rv,iv : in Standard_Floating_VecVecVecs.Link_to_VecVecVec;
                rb,ib : in Standard_Floating_VecVecs.Link_to_VecVec;
                ry,iy : in Standard_Floating_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put("-> in staggered_newton_convolutions.");
      put_line("Inlined_LU_Newton_Steps 2 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.Inlined_LU_Newton_Step
        (file,wrkdeg,csr,scf,rx,ix,absdx,info,ipvt,
         rc,ic,rv,iv,rb,ib,ry,iy,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end Inlined_LU_Newton_Steps;

-- INLINED NEWTON STEPS WITH LU WITH CONDITION NUMBER ESTIMATE :

  procedure Inlined_LU_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                rc,ic : in Standard_Floating_VecVecs.Link_to_VecVec;
                rv,iv : in Standard_Floating_VecVecVecs.Link_to_VecVecVec;
                rb,ib : in Standard_Floating_VecVecs.Link_to_VecVec;
                ry,iy : in Standard_Floating_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put("-> in staggered_newton_convolutions.");
      put_line("Inlined_LU_Newton_Steps 3 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.Inlined_LU_Newton_Step
        (wrkdeg,csr,scf,rx,ix,absdx,rcond,ipvt,
         rc,ic,rv,iv,rb,ib,ry,iy,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end Inlined_LU_Newton_Steps;

  procedure Inlined_LU_Newton_Steps
              ( file : in file_type;
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                rc,ic : in Standard_Floating_VecVecs.Link_to_VecVec;
                rv,iv : in Standard_Floating_VecVecVecs.Link_to_VecVecVec;
                rb,ib : in Standard_Floating_VecVecs.Link_to_VecVec;
                ry,iy : in Standard_Floating_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put("-> in staggered_newton_convolutions.");
      put_line("Inlined_LU_Newton_Steps 4 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.Inlined_LU_Newton_Step
        (file,wrkdeg,csr,scf,rx,ix,absdx,rcond,ipvt,
         rc,ic,rv,iv,rb,ib,ry,iy,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end Inlined_LU_Newton_Steps;

-- NEWTON STEPS WITH LU WITHOUT CONDITION NUMBER ESTIMATE :

  procedure LU_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
		scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.LU_Newton_Steps 1 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.LU_Newton_Step
        (wrkdeg,csr,scf,rx,ix,absdx,info,ipvt,wrk,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end LU_Newton_Steps;

  procedure LU_Newton_Steps
              ( file : in file_type; 
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.LU_Newton_Steps 2 ...");
    end if;
    for k in 1..nbrit loop
      put(file,"Step "); put(file,k,1); put_line(file," :");
      Newton_Coefficient_Convolutions.LU_Newton_Step
        (file,wrkdeg,csr,scf,rx,ix,absdx,info,ipvt,wrk,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end LU_Newton_Steps;

-- NEWTON STEPS WITH LU WITH CONDITION NUMBER ESTIMATE :

  procedure LU_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.LU_Newton_Steps 3 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.LU_Newton_Step
        (wrkdeg,csr,scf,rx,ix,absdx,rcond,ipvt,wrk,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end LU_Newton_Steps;

  procedure LU_Newton_Steps
              ( file : in file_type; 
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean; rcond : out double_float;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.LU_Newton_Steps 4 ...");
    end if;
    for k in 1..nbrit loop
      put(file,"Step "); put(file,k,1); put_line(file," :");
      Newton_Coefficient_Convolutions.LU_Newton_Step
        (file,wrkdeg,csr,scf,rx,ix,absdx,rcond,ipvt,wrk,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end LU_Newton_Steps;

-- NEWTON STEPS WITH QR ON COEFFICIENT CONVOLUTIONS :

  procedure QR_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean;
                qraux : out Standard_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out Standard_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.QR_Newton_Steps 1 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.QR_Newton_Step
        (wrkdeg,csr,scf,dx,xd,rx,ix,absdx,qraux,w1,w2,w3,w4,w5,info,ipvt,wrk,
         scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end QR_Newton_Steps;

  procedure QR_Newton_Steps
              ( file : in file_type;
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean;
                qraux : out Standard_Complex_Vectors.Vector;
                w1,w2,w3,w4,w5 : in out Standard_Complex_Vectors.Vector;
                info : out integer32;
                ipvt : out Standard_Integer_Vectors.Vector;
                wrk : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in staggered_newton_convolutions.QR_Newton_Steps 2 ...");
    end if;
    for k in 1..nbrit loop
      put(file,"Step "); put(file,k,1); put_line(file," :");
      Newton_Coefficient_Convolutions.QR_Newton_Step
        (file,wrkdeg,csr,scf,dx,xd,rx,ix,absdx,qraux,w1,w2,w3,w4,w5,
         info,ipvt,wrk,scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if absdx <= tol
       then fail := false; nbrit := k; exit;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end QR_Newton_Steps;

-- NEWTON STEPS WITH SVD ON COEFFICIENT CONVOLUTIONS :

  procedure SVD_Newton_Steps
              ( csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean;
                svl : out Standard_Complex_Vectors.Vector;
                U,V : out Standard_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_float;
                ewrk : in Standard_Complex_Vectors.Link_to_Vector;
                wrkv : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in newton_power_convolutions.SVD_Newton_Steps 1 ...");
    end if;
    for k in 1..nbrit loop
      Newton_Coefficient_Convolutions.SVD_Newton_Step
        (wrkdeg,csr,scf,dx,xd,rx,ix,absdx,svl,U,V,info,rcond,ewrk,wrkv,
         scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(wrkdeg,csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end SVD_Newton_Steps;

  procedure SVD_Newton_Steps
              ( file : in file_type;
                csr : in Standard_Coefficient_Convolutions.Link_to_System;
                scf,dx,xd : in Standard_Complex_VecVecs.VecVec;
                rx,ix : in Standard_Floating_VecVecs.Link_to_VecVec;
                maxit : in integer32; nbrit : out integer32;
                tol : in double_float; absdx : out double_float;
                fail : out boolean;
                svl : out Standard_Complex_Vectors.Vector;
                U,V : out Standard_Complex_Matrices.Matrix;
                info : out integer32; rcond : out double_float;
                ewrk : in Standard_Complex_Vectors.Link_to_Vector;
                wrkv : in Standard_Complex_Vectors.Link_to_Vector;
                scale : in boolean := true; verbose : in boolean := true;
                vrblvl : in integer32 := 0 ) is

    maxval : double_float;
    idx : integer32;
    wrkdeg : integer32 := 1;

  begin
    fail := true; nbrit := maxit;
    if vrblvl > 0 then
      put_line("-> in newton_power_convolutions.SVD_Newton_Steps 2 ...");
    end if;
    for k in 1..nbrit loop
      put(file,"Step "); put(file,k,1); put_line(file," :");
      Newton_Coefficient_Convolutions.SVD_Newton_Step
        (file,wrkdeg,csr,scf,dx,xd,rx,ix,absdx,svl,U,V,info,rcond,ewrk,wrkv,
         scale,vrblvl-1);
      Newton_Convolutions.MaxIdx(csr.vy,tol,maxval,idx);
      if verbose then
        put("max |dx| ="); put(maxval,3);
        if idx < csr.vy'first
         then put_line(" too large");
         else put(" at index "); put(idx,1); new_line;
        end if;
      end if;
      if wrkdeg > 1 then
        if absdx <= tol
         then fail := false; nbrit := k; exit;
        end if;
      end if;
      wrkdeg := 2*wrkdeg;
      if wrkdeg > csr.deg
       then wrkdeg := csr.deg;
      end if;
    end loop;
  end SVD_Newton_Steps;

end Staggered_Newton_Convolutions;
