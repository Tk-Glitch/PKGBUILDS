# DXVK and DXUP scripts to build/patch/install/update, also Lutris compatible (DXVK only, Lutris doesn't support DXUP yet).

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

### Building DXUP DLL

Inside the dxvk-tools directory, run:
```
./updxup build
```

You'll find more details on the various functions (such as installation-related ones) of these scripts right inside them.

# DXVK : https://github.com/doitsujin/dxvk

# DXUP : https://github.com/Joshua-Ashton/dxup
