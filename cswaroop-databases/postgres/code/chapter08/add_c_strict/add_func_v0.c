#include "postgres.h"
#include <string.h>
#include "utils/geo_decls.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif

/* by value */

int
add_ab(int arg_a, int arg_b)
{
    return arg_a + arg_b;
}

/* by reference, fixed length */

float8 *
add_ab_float8(float8 *arg_a, float8 *arg_b)
{
    float8    *result = (float8 *) palloc(sizeof(float8));

    *result = *arg_a + *arg_b;

    return result;
}

