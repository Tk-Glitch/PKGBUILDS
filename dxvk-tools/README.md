# DXVK and DXUP scripts to build/patch/install/update, Lutris and Proton-tkg compatible.

### Requirements:
- [wine 3.10](https://www.winehq.org/) or newer
- [Meson](http://mesonbuild.com/) build system (at least version 0.43)
- [MinGW64](http://mingw-w64.org/) 6.0 compiler and headers (I'm providing a script for Arch based distros here : https://github.com/Tk-Glitch/PKGBUILDS/tree/master/mingw )
- [glslang](https://github.com/KhronosGroup/glslang) compile

### Building DXVK DLLs

Inside the dxvk-tools directory, run:
```
./updxvk build
```

### Exporting DXVK DLLs for Proton-tkg

Still inside the dxvk-tools directory, after you ran the command above, run:
```
./updxvk proton-tkg
```
*DXVK files will be copied in a folder next to proton-tkg script, ready for building.*


### Building DXUP DLL

Inside the dxvk-tools directory, run:
```
./updxup build
```

You'll find more details on the various functions (such as installation-related ones) of these scripts right inside them.

# DXVK : https://github.com/doitsujin/dxvk

# D9VK : https://github.com/Joshua-Ashton/d9vk

# DXUP : https://github.com/Joshua-Ashton/dxup
