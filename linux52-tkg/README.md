A custom Linux kernel 5.2.y with specific PDS and BMQ CPU schedulers related patchsets selector (stock CFS is also an option) and added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.

Various personnalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

PDS-mq & BMQ : http://cchalpha.blogspot.com/

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.
