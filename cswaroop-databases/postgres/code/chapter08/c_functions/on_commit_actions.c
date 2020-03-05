

#include "postgres.h"
#include <string.h>
#include "fmgr.h"
#include "utils/geo_decls.h"

#ifdef PG_MODULE_MAGIC
PG_MODULE_MAGIC;
#endif


///////////////////////////////////////////////////////////////////////

#include "access/xact.h"

// transaction
static int commit_count = 0;
static int abort_count = 0;
static int prepare_count = 0;

// subtransaction
static int subx_start_count = 0;
static int subx_commit_count = 0;
static int subx_abort_count = 0;

// last xact ids
static TransactionId last_committed_xid = 0;
static SubTransactionId last_committed_subxid = 0;

static TransactionId current_top_xid = 0;


/*
 * Register or deregister callback functions for start- and end-of-subxact
 * operations.
 *
 * Pretty much same as above, but for subtransaction events.
 *
 * At subtransaction end, the callback occurs post-subcommit or post-subabort,
 * so the callback functions can only do noncritical cleanup.  At
 * subtransaction start, the callback is called when the subtransaction has
 * finished initializing.
 */
/*
 * stampede_xact_callback
 *
 * A callback routine of transaction commit/abort/prepare.
 */
static void
stampede_xact_callback(XactEvent event, void *arg)
{
    current_top_xid = GetTopTransactionIdIfAny();
    if (event == XACT_EVENT_COMMIT)
    {
        commit_count++;
        last_committed_xid = GetCurrentTransactionIdIfAny();
    }
    else if (event == XACT_EVENT_ABORT)
    {
        abort_count++;
    }
    else if (event ==  XACT_EVENT_PREPARE)
    {
        prepare_count++;
    }
}

/*
 * Register or deregister callback functions for start- and end-of-xact
 * operations.
 *
 * These functions are intended for use by dynamically loaded modules.
 * For built-in modules we generally just hardwire the appropriate calls
 * (mainly because it's easier to control the order that way, where needed).
 *
 * At transaction end, the callback occurs post-commit or post-abort, so the
 * callback functions can only do noncritical cleanup.
 */
/*
 * stampede_subxact_callback
 *
 * A callback routine of transaction commit/abort/prepare.
 */
static void
stampede_subxact_callback(SubXactEvent event,
                          SubTransactionId mySubid,
                          SubTransactionId parentSubid,
                          void *arg)
{
    current_top_xid = GetTopTransactionIdIfAny();
    if (event == SUBXACT_EVENT_START_SUB)
    {
//        last_committed_subxid = GetCurrentSubTransactionId();
        subx_start_count++;
    }
    else if (event == SUBXACT_EVENT_COMMIT_SUB)
    {
        subx_commit_count++;
        last_committed_subxid = GetCurrentSubTransactionId();
        last_committed_xid = GetCurrentTransactionIdIfAny();  // this xid is used for xmin
//        last_committed_subxid = mySubid;
    }
    else if (event == SUBXACT_EVENT_ABORT_SUB)
    {
        subx_abort_count++;
    }
}

///////////////////////////////////////////////////////////////////////

static int xact_callbacks_registered = 0;

void _PG_init();

// NB! this will probably fail if module is pre-loaded,CHECK!

void _PG_init() {
    /* register Transaction/Sub-transaction callbacks once */
    if (xact_callbacks_registered == 0) {
        RegisterXactCallback(stampede_xact_callback, NULL);
        RegisterSubXactCallback(stampede_subxact_callback, NULL);
        xact_callbacks_registered = 1;
    }    
}

///////////////////////////////////////////////////////////////////////

Datum register_xact_callbacks(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(register_xact_callbacks);

Datum
register_xact_callbacks(PG_FUNCTION_ARGS)
{
    /* register Transaction/Sub-transaction callbacks once */
    if (xact_callbacks_registered == 0) {
        RegisterXactCallback(stampede_xact_callback, NULL);
        RegisterSubXactCallback(stampede_subxact_callback, NULL);
        xact_callbacks_registered = 1;
    }

    PG_RETURN_VOID();
}

///////////////////////////////////////////////////////////////////////

Datum get_commit_count(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_commit_count);

Datum
get_commit_count(PG_FUNCTION_ARGS)
{
    PG_RETURN_INT32(commit_count);
}

///////////////////////////////////////////////////////////////////////

Datum get_abort_count(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_abort_count);

Datum
get_abort_count(PG_FUNCTION_ARGS)
{
    PG_RETURN_INT32(abort_count);
}

///////////////////////////////////////////////////////////////////////

Datum get_subx_start_count(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_subx_start_count);

Datum
get_subx_start_count(PG_FUNCTION_ARGS)
{
    PG_RETURN_INT32(subx_start_count);
}

///////////////////////////////////////////////////////////////////////

Datum get_subx_commit_count(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_subx_commit_count);

Datum
get_subx_commit_count(PG_FUNCTION_ARGS)
{
    PG_RETURN_INT32(subx_commit_count);
}

///////////////////////////////////////////////////////////////////////

Datum get_subx_abort_count(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_subx_abort_count);

Datum
get_subx_abort_count(PG_FUNCTION_ARGS)
{
    PG_RETURN_INT32(subx_abort_count);
}

///////////////////////////////////////////////////////////////////////

Datum get_current_top_xid(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_current_top_xid);

Datum
get_current_top_xid(PG_FUNCTION_ARGS)
{
//    int32   arg = PG_GETARG_INT32(0);

    PG_RETURN_INT32(current_top_xid);
}

///////////////////////////////////////////////////////////////////////

Datum get_last_committed_xid(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(get_last_committed_xid);

Datum
get_last_committed_xid(PG_FUNCTION_ARGS)
{
//    int32   arg = PG_GETARG_INT32(0);

    PG_RETURN_INT32(last_committed_xid);
}

///////////////////////////////////////////////////////////////////////

Datum get_last_committed_subxid(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(last_committed_subxid);

Datum
get_last_committed_subxid(PG_FUNCTION_ARGS)
{
//    int32   arg = PG_GETARG_INT32(0);

    PG_RETURN_INT32(last_committed_subxid);
}

////////////////////////////////
///   from original sample   ///
////////////////////////////////
/* by reference, fixed length */

Datum add_one_float8(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(add_one_float8);

Datum
add_one_float8(PG_FUNCTION_ARGS)
{
    /* The macros for FLOAT8 hide its pass-by-reference nature. */
    float8   arg = PG_GETARG_FLOAT8(0);

    PG_RETURN_FLOAT8(arg + 1.0);
}

///////////////////////////////////////////////////////////////////////

Datum makepoint(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(makepoint);

Datum
makepoint(PG_FUNCTION_ARGS)
{
    /* Here, the pass-by-reference nature of Point is not hidden. */
    Point     *pointx = PG_GETARG_POINT_P(0);
    Point     *pointy = PG_GETARG_POINT_P(1);
    Point     *new_point = (Point *) palloc(sizeof(Point));

    new_point->x = pointx->x;
    new_point->y = pointy->y;

    PG_RETURN_POINT_P(new_point);
}

///////////////////////////////////////////////////////////////////////
/* by reference, variable length */

Datum copytext(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(copytext);

Datum
copytext(PG_FUNCTION_ARGS)
{
    text     *t = PG_GETARG_TEXT_P(0);
    /*
     * VARSIZE is the total size of the struct in bytes.
     */
    text     *new_t = (text *) palloc(VARSIZE(t));
    SET_VARSIZE(new_t, VARSIZE(t));
    /*
     * VARDATA is a pointer to the data region of the struct.
     */
    memcpy((void *) VARDATA(new_t), /* destination */
           (void *) VARDATA(t),     /* source */
           VARSIZE(t) - VARHDRSZ);  /* how many bytes */
    PG_RETURN_TEXT_P(new_t);
}

///////////////////////////////////////////////////////////////////////

Datum concat_text(PG_FUNCTION_ARGS);

PG_FUNCTION_INFO_V1(concat_text);

Datum
concat_text(PG_FUNCTION_ARGS)
{
    text  *arg1 = PG_GETARG_TEXT_P(0);
    text  *arg2 = PG_GETARG_TEXT_P(1);
    int32 new_text_size = VARSIZE(arg1) + VARSIZE(arg2) - VARHDRSZ;
    text *new_text = (text *) palloc(new_text_size);

    SET_VARSIZE(new_text, new_text_size);
    memcpy(VARDATA(new_text), VARDATA(arg1), VARSIZE(arg1) - VARHDRSZ);
    memcpy(VARDATA(new_text) + (VARSIZE(arg1) - VARHDRSZ),
           VARDATA(arg2), VARSIZE(arg2) - VARHDRSZ);
    PG_RETURN_TEXT_P(new_text);
}

///////////////////////////////////////////////////////////////////////
