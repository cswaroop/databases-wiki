#include "postgres.h"
#include "fmgr.h"

PG_MODULE_MAGIC;

Datum add_ab_null(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(add_ab_null);

Datum
add_ab_null(PG_FUNCTION_ARGS)
{
    int32   not_null = 0;
    int32   sum = 0;
    if (!PG_ARGISNULL(0)) {
        sum += PG_GETARG_INT32(0);
        not_null = 1;
    }
    if (!PG_ARGISNULL(1)) {
        sum += PG_GETARG_INT32(1);
        not_null = 1;
    }
    if (not_null) {
        PG_RETURN_INT32(sum);
    }
    PG_RETURN_NULL();
}

