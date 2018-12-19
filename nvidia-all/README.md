# Nvidia driver 415.22.01 (Vulkan dev), 415.25 (short lived) & 410.78 (long lived)
# Also supports user-selected driver version (lower than 396.45 is untested)

LIBGLVND compatible, with 32 bit libs and DKMS enabled out of the box (you will still be asked if you want to use the regular package). Installs for all currently installed kernels.
Unwanted packages can be disabled with switches in the PKGBUILD. Defaults to complete installation.

You may need/want to add a pacman hook for nvidia depending on your setup : https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting

415.22.01 : https://developer.nvidia.com/vulkan-driver (Vulkan dev drivers page)

415.25 & 410.78 : https://www.nvidia.com/object/unix.html
