#include "postgres.h"
#include "fmgr.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

/* by value */

//Datum add_ab(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(add_ab);

Datum
add_ab(PG_FUNCTION_ARGS)
{
    int32   arg_a = PG_GETARG_INT32(0);
    int32   arg_b = PG_GETARG_INT32(1);

    PG_RETURN_INT32(arg_a + arg_b);
}

/* by reference, fixed length */

Datum add_ab_float8(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(add_ab_float8);

Datum
add_ab_float8(PG_FUNCTION_ARGS)
{
    /* The macros for FLOAT8 hide its pass-by-reference nature. */
    float8   arg_a = PG_GETARG_FLOAT8(0);
    float8   arg_b = PG_GETARG_FLOAT8(1);

    PG_RETURN_FLOAT8(arg_a + arg_b);
}

