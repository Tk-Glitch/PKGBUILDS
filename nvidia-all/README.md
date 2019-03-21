# Nvidia driver 418.30 (beta), 418.49.04 (Vulkan dev), 415.27 (short lived) & 418.56 (long lived)
# Also supports user-selected driver version (lower than 396.45 is untested)

LIBGLVND compatible, with 32 bit libs and DKMS enabled out of the box (you will still be asked if you want to use the regular package). Installs for all currently installed kernels.
Unwanted packages can be disabled with switches in the PKGBUILD. Defaults to complete installation.

You may need/want to add a pacman hook for nvidia depending on your setup : https://wiki.archlinux.org/index.php/NVIDIA#DRM_kernel_mode_setting

418.49.04 : https://developer.nvidia.com/vulkan-driver (Vulkan dev drivers page)

415.27 & 418.56 : https://www.nvidia.com/object/unix.html

418.30 : https://www.nvidia.com/download/driverResults.aspx/142166/en-us


# How to generate a package for a driver that isn't listed :

- When you are prompted for driver version, select "custom" (choice 5).
- You'll then be asked the branch group. Select either "Vulkan dev" (choice 2) for Vulkan dev drivers or "stable or regular beta" (choice 1) for every other driver.
- Now you have to enter the version number of the desired driver. Vulkan dev drivers version is usually formatted as `mainbranch.version.subversion` (i.e.: 415.22.01) while the stable or regular beta drivers version is usually `mainbranch.version` (i.e.: 415.25)
- To finish, you'll be asked if you want dkms(recommended) or regular modules, similarly to the usual drivers versions.
