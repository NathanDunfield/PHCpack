// plain C interface to DEMiCs, to call from Ada

void write_data
 ( int dimension, int nsupports,
   int* mixtype, int* cardsup, int *coordinates );
/*
 * DESCRIPTION :
 *   Writes the input data to screen.
 *
 * ON ENTRY :
 *   verbose    if 1, then data is printed, if 0, remains silent;
 *   dimension  length of the points in each support set;
 *   nsupports  number of distinct support sets;
 *   mixtype    number of occurrences of each set;
 *   cardsup    cardinalities of the support sets. */

void fill_preamble
 ( dataSet& Data,
   int verbose, int dimension, int nsupports, int* mixtype, int* cardsup );
/*
 * DESCRIPTION :
 *   Fills the preamble to the Data object.
 *
 * ON ENTRY :
 *   Data        a dataSet object;
 *   verbose     if 1, then data is printed, if 0, remains silent;
 *   dimension   length of the points in each support set;
 *   nsupports   number of distinct support sets;
 *   mixtype     number of occurrences of each set;
 *   cardsup     cardinalities of the support sets.
 *
 * ON RETURN :
 *   Data        dataSet object with working Data.info_preamble(). */

void fill_supports ( dataSet& Data, int verbose, int* coordinates );
/*
 * DESCRIPTION :
 *   Puts the coordinates into the Data object.
 *
 * ON ENTRY :
 *   Data        a dataSet object, already with preamble defined;
 *   verbose     if 1, then data is printed, if 0, remains silent;
 *   coordinates are the coordinates of the points in the supports.
 *
 * ON RETURN :
 *   Data        dataSet object with working Data.info_supports(). */

void fill_complete ( dataSet& Data );
/*
 * DESCRIPTION :
 *   Completes the filling of the dataSet object Data,
 *   needed for the mixed volume computation.
 *
 * REQUIRED : fill_preamble() and fill_supports() ran on Data. */

extern "C" int demicsrun
 ( int verbose, int dimension, int nsupports,
   int* mixtype, int* cardsup, int *coordinates );
/*
 * DESCRIPTION :
 *   Calls DEMiCs to enumerate all mixed cells.
 *
 * ON ENTRY :
 *   verbose     if 1, then data is printed, if 0, remains silent;
 *   dimension   length of the points in each support set;
 *   nsupports   number of distinct support sets;
 *   mixtype     number of occurrences of each set;
 *   cardsup     cardinalities of the support sets;
 *   coordinates are the coordinates of the points in the supports. */
