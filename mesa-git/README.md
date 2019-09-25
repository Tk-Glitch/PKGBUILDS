# Mesa - The 3D Graphics Library - git version, multilib with userpatches support

https://gitlab.freedesktop.org/mesa/mesa

You can customize key features in the `customization.cfg` file such as :
- Selecting which LLVM backend version to use
- Enabling/disabling compilation of the lib32 package
- Change userpatches behaviour

You can use your own mesa patches by putting them in the mesa-userpatches folder and giving them the .mymesapatch extension.
You can also revert mesa patches by putting them in the mesa-userpatches folder and giving them the .mymesarevert extension.
