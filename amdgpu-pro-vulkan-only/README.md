# Only the vulkan part of AMDGPU-PRO 18.50-708488 drivers

Can live next to RADV

 https://www.amd.com/en/support/kb/release-notes/rn-rad-lin-18-50-unified

Start your game/app with either `VK_ICD_FILENAMES=/opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd64.json` for 64-bit or `VK_ICD_FILENAMES=/opt/amdgpu-pro/etc/vulkan/icd.d/amd_icd32.json` for 32-bit.
