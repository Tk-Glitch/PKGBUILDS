A custom Linux kernel 5.2 rc with added tweaks for a nice interactivity/performance balance.
Due to rc state, various tweaks and options are missing compared to stable-based releases of wine-tkg. If you're using nvidia proprietary drivers, 430.14 is required.

Various personnalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.
