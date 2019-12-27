# mesa-git patches

- bias_shadows_radv_dxvk.mymesapatch : Fixes some shadow rendering issues with RADV - ! Not compatible with VK_JOSH_depth_bias patches ! (https://bugs.freedesktop.org/show_bug.cgi?id=109599)
- intel_haswell_vk_workaround.mymesarevert : Reverts https://gitlab.freedesktop.org/mesa/mesa/commit/7c1b39cf18481f0d15f3ffb1130da4479032d76a to workaround visual breakage on haswell and older iGPUs with vulkan
- VK_JOSH_depth_bias_info_radv.mymesapatch : Adds VK_JOSH_depth_bias_info extension for use with D9VK (fixes shadows rendering in various cases)
- VK_JOSH_depth_bias_info_header.mymesapatch : VK_JOSH_depth_bias_info extension header, dependency for the above patch
