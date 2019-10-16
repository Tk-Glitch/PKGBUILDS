# DXVK patches

- asyncpresent.dxvkrevert : Restores asynchronous present option (Off-loads presentation to the queue submission thread, turn on with `dxgi.asyncPresent` option)
- dxvk-win32-thread-model-support.dxvkpatch : Use win32 threads instead of posix (doesn't affect perf, not recommended)
- nativeopt-when-using-dxvk-win32-thread-model-support.dxvkpatch : native opts for use with win32 threads patch above (native optimizations breaks DXVK, not recommended)
