# wine-tkg-git patches

## Proton patches
- amdags.mypatch : Add amdags dll (proton patch)
- GNUTLShack.mypatch : Fixes Sword Art Online: Fatal Bullet, and others, on gnutls 3.5 (proton patch)
- hide-prefix-update-window.mypatch : As the name implies, will hide the prefix update dialog - https://github.com/ValveSoftware/wine/commit/6051b0612ca0436139f6e059cdaa704b7d9fa7ab
- winex11-fs-no_above_state.mypatch : Don't set ABOVE state for FULLSCREEN windows, fixing alt-tabbing in various games. There's a reported issue with Xfce where panels can stay above games with this patch applied. Requires `_proton_fs_hack="true"` in your .cfg - https://github.com/ValveSoftware/wine/commit/a8675091927c01a0c28de349517c5010557f06a9

## Game-specific
- legoisland_168726.mypatch : Add functions needed by, notably, lego island - https://bugs.winehq.org/show_bug.cgi?id=10729
- FinalFantasyXVHack.mypatch : Hack enabling Final Fantasy XV Steam to run - https://github.com/ValveSoftware/Proton/issues/74#issuecomment-553084621
- MWSE_hack.mypatch : Hack to allow Morrowind Script Extender to work - https://bugs.winehq.org/show_bug.cgi?id=47940#c24
- 0001-wined3d-Support-SRGB-read-for-B5G6R5-textures.mypatch : Fix for very bright ground in Warhammer Online - Only affects wined3d - https://bugs.winehq.org/show_bug.cgi?id=48302

WoW d3d12 fixes - **Requires using vkd3d patched with [Support_RS_1.0_Volatile patch](https://github.com/Tk-Glitch/PKGBUILDS/blob/master/community-patches/vkd3d-git/Support_RS_1.0_Volatile.mypatch)** :
- D3D12SerializeVersionedRootSignature.mypatch : 1/2 patch to enable WoW to run correctly in d3d12 mode - https://www.winehq.org/pipermail/wine-devel/2019-October/152356.html
- D3D12CreateVersionedRootSignatureDeserializer.mypatch : 2/2 patch to enable WoW to run correctly in d3d12 mode - https://www.winehq.org/pipermail/wine-devel/2019-October/152357.html

## Misc
- rem-rawinput.mypatch : Remi Bernon raw input implementation, pending for merge. Requires `_proton_fs_hack="false"` in your .cfg - https://github.com/rbernon/wine/tree/wip/rawinput
- rockstarlauncher_install_fix.mypatch : Fix for rockstar launcher installer crashing - https://github.com/ValveSoftware/wine/commit/e485252dfad51a7e463643d56fe138129597e4b6 - Doesn't apply to proton-tkg (already included)
- rockstarlauncher_downloads.mypatch : Hack to workaround failing downloads with rockstar launcher - https://bugs.winehq.org/show_bug.cgi?id=47843
- origin_downloads_e4ca5dbe_revert.mypatch : Workaround for Origin client game downloading issues - https://bugs.winehq.org/show_bug.cgi?id=48032
- proton_rawinput_addon.mypatch : Adds the *not yet merged* bits of rbernon's rawinput patchset to proton rawinput - Requires _use_staging="true", _proton_fs_hack="true" and _proton_rawinput="true" (all three enabled by default in proton-tkg) - https://github.com/rbernon/wine/tree/proton/wip/rawinput
