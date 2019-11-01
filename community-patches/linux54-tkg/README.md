# linux54-tkg patches

- 0008-drm-amd-powerplay-force-the-trim-of-the-mclk-dpm-levels-if-OD-is-enabled.mypatch : Fixes flickering on *some* AMD GPUs while using multiple monitors (https://bugs.freedesktop.org/show_bug.cgi?id=102646 https://bugs.freedesktop.org/show_bug.cgi?id=108941)
- amdgpu_dyn_mem_clock_75Hz_fix.mypatch : Allows dynamic video memory clocking with amdgpu and 75Hz display (https://cgit.freedesktop.org/~agd5f/linux/commit/?h=amd-staging-drm-next&id=b396b001487db18ac84d8d773d0234ac6b376dea)
- mm_proactive_compaction.mypatch : https://lkml.org/lkml/2019/10/30/1076
