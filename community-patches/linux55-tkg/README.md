# linux55-tkg patches

- 0008-drm-amd-powerplay-force-the-trim-of-the-mclk-dpm-levels-if-OD-is-enabled.mypatch : Fixes flickering on *some* AMD GPUs while using multiple monitors (https://bugs.freedesktop.org/show_bug.cgi?id=102646 https://bugs.freedesktop.org/show_bug.cgi?id=108941)
- amdgpu_extratemps-5.5.mypatch : Adds GPU hotspot temp reading on some AMD GPUs (https://github.com/matszpk/amdgpu-vega-hotspot)
- le9i.mypatch : An attempt to improve Linux's OOM behaviour - https://web.archive.org/web/20191018064145/https://gist.github.com/howaboutsynergy/04fd9be927835b055ac15b8b64658e85
- mm_proactive_compaction.mypatch : https://lkml.org/lkml/2019/10/30/1076
- wireguard.mypatch : Implements WireGuard as an in-kernel network device driver. (https://lkml.org/lkml/2019/11/27/266)
- zstd.mypatch : Add support for ZSTD-compressed kernel
- pipe_use_exclusive_waits_when_reading_or_writing.mypatch : https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=0ddad21d3e99c743a3aa473121dc5561679e26bb
