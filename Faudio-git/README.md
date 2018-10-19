# Faudio - git version, multilib with userpatches support

https://github.com/FNA-XNA/FAudio

You'll need a working mingw-w64 install to build this. Using https://github.com/Tk-Glitch/PKGBUILDS/tree/master/mingw is recommended.

You can use your own faudio patches by putting them in the same folder as the PKGBUILD and giving them the .myfaudiopatch extension.
You can also revert faudio patches by putting them in the same folder as the PKGBUILD and giving them the .myfaudiorevert extension.

## Installation :

For a 64-bit prefix :
* run `WINEPREFIX="/path/to/your/target/wine/prefix" setup_faudio64 && ln -sf /usr/x86_64-w64-mingw32/bin/libwinpthread-1.dll $WINEPREFIX/drive_c/windows/system32/libwinpthread-1.dll` to install 64-bit dlls overrides to system32

* run `WINEPREFIX="/path/to/your/target/wine/prefix" setup_faudio3264 && ln -sf /usr/i686-w64-mingw32/bin/libwinpthread-1.dll $WINEPREFIX/drive_c/windows/syswow64/libwinpthread-1.dll` to install 32-bit dlls overrides to sysWOW64

For a 32-bit prefix :
* run `WINEPREFIX="/path/to/your/target/wine/prefix" setup_faudio32 && ln -sf /usr/i686-w64-mingw32/bin/libwinpthread-1.dll $WINEPREFIX/drive_c/windows/system32/libwinpthread-1.dll` to install 32-bit dlls overrides to system32

Note : The file not found error is harmless and may be fixed upstream at some point. Or maybe I'll patch it.
