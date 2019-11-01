# wine-tkg-git patches

- amdags.mypatch : Add amdags dll (proton patch)
- GNUTLShack.mypatch : Fixes Sword Art Online: Fatal Bullet, and others, on gnutls 3.5 (proton patch)
- rem-rawinput.mypatch : Remi Bernon raw input implementation, pending for merge. Requires `_rawinput_fix="false"` and `_proton_fs_hack="false"` in your .cfg - https://github.com/rbernon/wine/tree/wip/rawinput
- rockstarlauncher_install_fix.mypatch : Fix for rockstar launcher installer crashing - https://github.com/ValveSoftware/wine/commit/e485252dfad51a7e463643d56fe138129597e4b6 - Doesn't apply to proton-tkg (already included)
- rockstarlauncher_downloads.mypatch : Hack to workaround failing downloads with rockstar launcher - https://bugs.winehq.org/show_bug.cgi?id=47843
