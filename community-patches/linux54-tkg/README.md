# linux54-tkg patches

- 0008-drm-amd-powerplay-force-the-trim-of-the-mclk-dpm-levels-if-OD-is-enabled.mypatch : Fixes flickering on *some* AMD GPUs while using multiple monitors (https://bugs.freedesktop.org/show_bug.cgi?id=102646 https://bugs.freedesktop.org/show_bug.cgi?id=108941)
- amdgpu_dyn_mem_clock_75Hz_fix.mypatch : Allows dynamic video memory clocking with amdgpu and 75Hz display (https://cgit.freedesktop.org/~agd5f/linux/commit/?h=amd-staging-drm-next&id=b396b001487db18ac84d8d773d0234ac6b376dea)
- mm_proactive_compaction.mypatch : https://lkml.org/lkml/2019/10/30/1076
- net_WireGuard_secure_network_tunnel.mypatch : implements WireGuard as an in-kernel network device driver. Includes the crypto-2.6 branch (https://lkml.org/lkml/2019/11/27/266)
- le9i.mypatch : An attempt to improve Linux's OOM behaviour - https://web.archive.org/web/20191018064145/https://gist.github.com/howaboutsynergy/04fd9be927835b055ac15b8b64658e85
- zstd.mypatch : Add support for ZSTD-compressed kernel
- new_slab.mypatch : Slab memory controller changes from Roman Gushchin - https://lkml.org/lkml/2019/9/5/1132
- uksm-5.4.mypatch - UKSM support from https://github.com/dolohow/uksm
