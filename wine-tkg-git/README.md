# Wine to rule them all !

This pkgbuild allows you to create custom wine builds using an opt-in mechanism (by editing the customization.cfg file). You can now easily get the "plain wine + pba + steam fix" build you've been dreaming about.

Can be built with DXVK winelib prebaked (replacing wined3d for d3d10 and d3d11 support) - https://github.com/doitsujin/dxvk

VKD3D builder integrated (for d3d12 to vulkan translation) - You'll need https://github.com/Tk-Glitch/PKGBUILDS/tree/master/spirv-tools-git to build VKD3D packages

Wine : https://github.com/wine-mirror/wine

Wine-staging : https://github.com/wine-staging/wine-staging

Wine esync : https://github.com/zfigura/wine/tree/esync

Wine-pba : https://github.com/Firerat/wine-pba

With other patches available such as :
- CSMT-toggle fixed logic - https://github.com/wine-staging/wine-staging/pull/60/commits/ad474559590a659b3df72ec9965de20c7f51c3a8
- Harmony fix
- Path of Exile DX11 fix
- Steam --no-sandbox auto fix
- Fortnite crash fix - https://github.com/Guy1524/fortnite-wine - "Working once every fortnite" ~FeetOnGrass
- Fallout 4 and Skyrim SE Script Extender fix - https://github.com/hdmap/wine-hackery/tree/master/f4se
- Fallout 4 Direct sound fix - https://bugs.winehq.org/show_bug.cgi?id=41271
- Final Fantasy XIV mouse jitter fix
- Winepulse disable patch (fix for various sound issues related to winepulse/pulsaudio)
- Lowlatency audio patch for osu! - https://blog.thepoon.fr/osuLinuxAudioLatency
- Gallium 9 support

Lutris esync (+staging +pba) builds are currently created using this pkgbuild - https://github.com/lutris/wine
