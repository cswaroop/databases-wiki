#include "postgres.h"
#include "fmgr.h"

#include "utils/array.h"
#include "catalog/pg_type.h" // for INT4OID

PG_MODULE_MAGIC;

Datum add_int32_array(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(add_int32_array);

Datum
add_int32_array(PG_FUNCTION_ARGS)
{
    ArrayType  *input_array;

    int32   sum = 0;
    bool     not_null = false;
    // where deconstruct_array(...) stores it's result
    Datum      *datums;
    bool       *nulls;
    int         count;
    // for for loop
    int         i;


    input_array = PG_GETARG_ARRAYTYPE_P(0);
    // let's check that we do indeed have a one-dimensional int array
    Assert(ARR_ELEMTYPE(input_array) == INT4OID);
    Assert(ARR_NDIM(input_array) == 1);
    
    if (ARR_NDIM(input_array) > 1)
        ereport(ERROR,
                (errcode(ERRCODE_ARRAY_SUBSCRIPT_ERROR),
                 errmsg("1-dimensional array needed")));

    deconstruct_array(input_array,  // one-dimensional array
                      INT4OID,      // of integers
                      4,            // sise of integer is 4 bytes
                      true,         // int4 is pass-by value
                      'i',          // it's alignment type is 'i'
                      &datums, &nulls, &count); // put result into these

    for(i=0;i<count;i++) {
        // first check and ignore null elements
        if ( nulls[i] )
            continue;
        // accumulate and remember there were non-null values
        sum += DatumGetInt32(datums[i]);
        not_null = true;
    }

    if (not_null)
        PG_RETURN_INT32(sum);
    PG_RETURN_NULL();
}

