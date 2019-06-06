with Ada.Calendar;
with text_io;                           use text_io;
with Standard_Integer_Numbers_io;       use Standard_Integer_Numbers_io;
with String_Splitters;                  use String_Splitters;
with Communications_with_User;          use Communications_with_User;
with File_Scanning;                     use File_Scanning;
with QuadDobl_Complex_Poly_Systems;     use QuadDobl_Complex_Poly_Systems;
with QuadDobl_Complex_Laur_Systems;     use QuadDobl_Complex_Laur_Systems;
with QuadDobl_Complex_Laur_Systems_io;  use QuadDobl_Complex_Laur_Systems_io;
with QuadDobl_Laur_Poly_Convertors;
with QuadDobl_System_Readers;
with Embeddings_and_Cascades;           use Embeddings_and_Cascades;
with Greetings_and_Conclusions;

procedure compsolve4 ( nt : in natural32; infilename,outfilename : in string;
                       verbose : in integer32 := 0 ) is

  start_moment : constant Ada.Calendar.Time := Ada.Calendar.Clock;

  procedure Main is

  -- DESCRIPTION :
  --   Processing of the input and the output file name arguments.

    infile,outfile : file_type;
    outname : Link_to_String;
    append_sols : boolean := false;
    greeted : boolean := false;
    p : Link_to_Poly_Sys;
    q : Link_to_Laur_Sys;
    tofile : character;

  begin
    if verbose > 0 then
      put("At verbose level "); put(verbose,1);
      put_line(", in compsolve4.Main ...");
    end if;
    QuadDobl_System_Readers.Read_System(infile,infilename,q);
    if q = null then
      greeted := true;
      Greetings_and_Conclusions.Write_Greeting(nt,2);
      new_line; get(q);
    else
      Scan_and_Skip(infile,"SOLUTIONS",append_sols);
      append_sols := not append_sols;
      close(infile);
    end if;
    if not greeted then
      Greetings_and_Conclusions.Write_Greeting(nt,2);
      greeted := true;
    end if;
    if outfilename /= "" then
      tofile := 'y';
    else
      new_line;
      put("Do you want the output to file ? (y/n) ");
      Ask_Yes_or_No(tofile); -- will be 'y' if yes
    end if;
    if tofile = 'y'
     then Create_Output_File(outfile,outfilename,outname);
    end if;
    if QuadDobl_Laur_Poly_Convertors.Is_Genuine_Laurent(q.all) then
      if tofile = 'y'
       then QuadDobl_Embed_and_Cascade(outfile,outname.all,nt,q.all,true,true);
       else QuadDobl_Embed_and_Cascade(nt,q.all,true,true);
      end if;
    else
      declare
        use QuadDobl_Laur_Poly_Convertors;
        t : constant Poly_Sys(q'range)
          := Positive_Laurent_Polynomial_System(q.all);
      begin
        p := new Poly_Sys'(t);
        if tofile = 'y' then
          QuadDobl_Embed_and_Cascade(outfile,outname.all,nt,p.all,true,true);
        else
          QuadDobl_Embed_and_Cascade(nt,p.all,true,true);
        end if;
      end;
    end if;
    if tofile = 'y'
     then Greetings_and_Conclusions.Write_Conclusion(outfile,start_moment,nt);
     else Greetings_and_Conclusions.Write_Conclusion(start_moment,nt);
    end if;
  end Main;

begin
  Main;
end compsolve4;
