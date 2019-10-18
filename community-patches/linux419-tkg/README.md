# linux419-tkg patches

- 0008-drm-amd-powerplay-force-the-trim-of-the-mclk-dpm-levels-if-OD-is-enabled.mypatch : Fixes flickering on *some* AMD GPUs while using multiple monitors (https://bugs.freedesktop.org/show_bug.cgi?id=102646 https://bugs.freedesktop.org/show_bug.cgi?id=108941)
- amd-mckl-switching.mypatch : Support mclk switching when monitors are in sync. Enable with `amdgpu.dcfeaturemask=2` (https://lists.freedesktop.org/archives/amd-gfx/2019-August/039006.html)
- amdgpu_cursor_async_updates_for_fb_swaps.mypatch : Fixes stuttering cases on AMD GPUs (https://cgit.freedesktop.org/~agd5f/linux/commit/?h=drm-next&id=e16e37efb4c9eb7bcb9dab756c975040c5257e98)
- amdgpu_dyn_mem_clock_75Hz_fix.mypatch : Allows dynamic video memory clocking with amdgpu and 75Hz display (https://cgit.freedesktop.org/~agd5f/linux/commit/?h=amd-staging-drm-next&id=b396b001487db18ac84d8d773d0234ac6b376dea)
- amdgpu_extratemps-4.19.mypatch : Adds GPU hotspot temp reading on some AMD GPUs (https://github.com/matszpk/amdgpu-vega-hotspot)
