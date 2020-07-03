with Standard_Integer_Numbers;            use Standard_Integer_Numbers;
with Standard_Floating_VecVecs;

package Standard_Floating_VecVecVecs is

-- DESCRIPTION :
--   A VecVecVec is a three dimensional data structure of vectors 
--   of vectors of vectors of floating-point numbers in double precision.

  type VecVecVec is
    array ( integer32 range <> ) of Standard_Floating_VecVecs.Link_to_VecVec;
 
  type Link_to_VecVecVec is access VecVecVec; -- to store the power table

  type VecVecVec_Array is array ( integer32 range <> ) of Link_to_VecVecVec;

-- COPY PROCEDURES :

  procedure Copy ( v_from : in Link_to_VecVecVec;
                   v_to : out Link_to_VecVecVec );

  -- DESCRIPTION :
  --   Copies the v_from to the v_to,
  --   after the deallocation of v_to.

-- DEALLOCATORS :

  procedure Clear ( v : in out VecVecVec );
  procedure Clear ( v : in out Link_to_VecVecVec );
  procedure Clear ( v : in out VecVecVec_Array );

  -- DESCRIPTION :
  --   Deallocates the space occupied by v.

end Standard_Floating_VecVecVecs;
