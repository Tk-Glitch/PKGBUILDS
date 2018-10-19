# Faudio - git version, multilib with userpatches support

https://github.com/FNA-XNA/FAudio

You'll need a working mingw-w64 install to build this. Using https://github.com/Tk-Glitch/PKGBUILDS/tree/master/mingw is recommended.

You can use your own faudio patches by putting them in the same folder as the PKGBUILD and giving them the .myfaudiopatch extension.
You can also revert faudio patches by putting them in the same folder as the PKGBUILD and giving them the .myfaudiorevert extension.

## Installation :

* run `faudio_install "/path/to/your/target/wine/prefix"`


Note : The file not found error is harmless and may be fixed upstream at some point. Or maybe I'll patch it.
