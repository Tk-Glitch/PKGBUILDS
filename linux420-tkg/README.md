A custom Linux kernel 4.20.y with specific PDS and MuQSS CPU schedulers related patchsets selector (stock CFS is also an option) and added tweaks for a nice interactivity/performance balance, aiming for the best gaming experience.

```diff
- 4.20 kernel is unstable on my main machine, so to not keep you waiting for too long,
- testing has been done on my C2D-based laptop. Please report issues you may encounter.
```

Various personnalization options available and userpatches support (put your own patches in the same dir as the PKGBUILD, with the ".mypatch" extension.

PDS-mq : http://cchalpha.blogspot.com/

MuQSS : http://ck-hack.blogspot.com/

Comes with a slightly modified Arch config asking for a few core personalization settings at compilation time.
If you want to streamline your kernel config for lower footprint and faster compilations : https://wiki.archlinux.org/index.php/Modprobed-db
You can enable support for it at the beginning of the PKGBUILD file. Make sure to read everything you need to know about it.

**Gentoo users, @ghost-101 has been working on a kernel sharing similar goals :** https://framagit.org/3/agile-kernel
