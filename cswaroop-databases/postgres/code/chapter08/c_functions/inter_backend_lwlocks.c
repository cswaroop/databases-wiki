
/*
35.9.11. Shared Memory and LWLocks

Add-ins can reserve LWLocks and an allocation of shared memory on server
startup. The add-in's shared library must be preloaded by specifying it
in shared_preload_libraries. Shared memory is reserved by calling:

void RequestAddinShmemSpace(int size)
from your _PG_init function.

LWLocks are reserved by calling:

void RequestAddinLWLocks(int n)
from _PG_init.

To avoid possible race-conditions, each backend should use the LWLock
AddinShmemInitLock when connecting to and initializing its allocation
of shared memory, as shown here:

static mystruct *ptr = NULL;

if (!ptr)
{
        bool    found;

        LWLockAcquire(AddinShmemInitLock, LW_EXCLUSIVE);
        ptr = ShmemInitStruct("my struct name", size, &found);
        if (!found)
        {
                initialize contents of shmem area;
                acquire any requested LWLocks using:
                ptr->mylockid = LWLockAssign();
        }
        LWLockRelease(AddinShmemInitLock);
}
 */