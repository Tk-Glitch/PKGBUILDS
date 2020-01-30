# wine-tkg-git patches

**More userpatches for wine-tkg are also made available by @openglfreak : https://github.com/openglfreak/wine-tkg-userpatches**

*Thank you!*

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
- detroit_BH.mypatch : Allows Detroit: Become Human to run and fix low performance - https://bugs.winehq.org/show_bug.cgi?id=48291
- monster_hunter_world_hacky_fix.mypatch : Hacky fix for the terrible performance introduced with patch VU10.12.00 - May affect other games and apps negatively, so use at your own risk - From Guy1524 https://github.com/ValveSoftware/Proton/issues/175#issuecomment-574365695
- blackops2_unhandled_exception_fix.mypatch : Fix for the Unhandled Exception crash of Call of Duty - Black Ops 2 on start up - https://bugs.winehq.org/show_bug.cgi?id=46472


WoW d3d12 fixes - **Requires using vkd3d patched with [Support_RS_1.0_Volatile patch](https://github.com/Tk-Glitch/PKGBUILDS/blob/master/community-patches/vkd3d-git/Support_RS_1.0_Volatile.mypatch)** :
- D3D12SerializeVersionedRootSignature.mypatch : 1/2 patch to enable WoW to run correctly in d3d12 mode - https://www.winehq.org/pipermail/wine-devel/2019-October/152356.html
- D3D12CreateVersionedRootSignatureDeserializer.mypatch : 2/2 patch to enable WoW to run correctly in d3d12 mode - https://www.winehq.org/pipermail/wine-devel/2019-October/152357.html

## Misc
- rockstarlauncher_install_fix.mypatch : Fix for rockstar launcher installer crashing - https://github.com/ValveSoftware/wine/commit/e485252dfad51a7e463643d56fe138129597e4b6 - Doesn't apply to proton-tkg (already included)
- rockstarlauncher_downloads.mypatch : Hack to workaround failing downloads with rockstar launcher - https://bugs.winehq.org/show_bug.cgi?id=47843
- origin_downloads_e4ca5dbe_revert.mypatch : Workaround for Origin client game downloading issues - https://bugs.winehq.org/show_bug.cgi?id=48032
- BCryptSecretAgreement.mypatch : Pending patchset that notably allows For Honor (no multiplayer though, that's using EAC), and Steep to connect to Ubisoft servers - https://www.winehq.org/pipermail/wine-devel/2020-January/157432.html
- 0001-Add-some-semi-stubs-in-user32.mypatch : Fixes black/green screen when running Steep in fullscreen/windowed fullscreen mode, courtesy of Guy1524
