# Wine to rule them all !

## DO NOT REPORT BUGS ENCOUNTERED WITH CUSTOM BUILDS AT WINEHQ, REPORT HERE INSTEAD !

This pkgbuild allows you to create custom wine builds using an opt-in mechanism (by editing the customization.cfg file). You can now easily get the "plain wine + pba + steam fix" build you've been dreaming about.

You can now turn your wine-tkg-git builds to Steamplay compatible and use them directly from Steam! - https://github.com/Tk-Glitch/PKGBUILDS/tree/master/proton-tkg

**Since this is a -git package, wine and wine-staging sources will be pulled from latest master branches by default. You can define specific releases commit in the cfg file if needed.**

*Can be built with VKD3D for D3D12 support (using https://github.com/Tk-Glitch/PKGBUILDS/tree/master/vkd3d-git is recommended)* - https://source.winehq.org/git/vkd3d.git

*Can be built with Faudio (requires both faudio and lib32-faudio packages installed)* - https://github.com/FNA-XNA/FAudio

**Can also be built with your own patches - See [README in ./wine-tkg-userpatches](wine-tkg-userpatches/README.md) for instructions**

Wine : https://github.com/wine-mirror/wine

Wine-staging : https://github.com/wine-staging/wine-staging

Wine esync : https://github.com/zfigura/wine/tree/esync

Wine fsync : https://github.com/zfigura/wine/tree/fsync

Wine-pba (Only working correctly up to 3.18 - Force disabled on newer wine bases due to regressions) : https://github.com/acomminos/wine-pba

Thanks to @Firerat and @bobwya for their rebase work :
- https://github.com/Firerat/wine-pba
- https://github.com/bobwya/gentoo-wine-pba

With other patches available such as (but not limited to - see [customization.cfg for the full list and details](customization.cfg) ) :
- CSMT-toggle fixed logic - https://github.com/wine-staging/wine-staging/pull/60/commits/ad474559590a659b3df72ec9965de20c7f51c3a8
- GLSL-toggle for wined3d
- Path of Exile DX11 fix
- Steam --no-sandbox auto fix (for store support on higher than winxp mode)
- The Sims 2 fix
- Magic: The Gathering Arena fix
- Fortnite crash fix - https://github.com/Guy1524/fortnite-wine - "Working once every fortnite" ~FeetOnGrass
- Fallout 4 and Skyrim SE Script Extender fix - https://github.com/hdmap/wine-hackery/tree/master/f4se
- Winepulse disable patch (fix for various sound issues related to winepulse/pulsaudio)
- Lowlatency audio patch for osu! - https://blog.thepoon.fr/osuLinuxAudioLatency
- Use CLOCK_MONOTONIC instead of CLOCK_MONOTONIC_RAW in ntdll/server
- "Launch with dedicated gpu" desktop entry
- Bypass compositor in fullscreen mode
- Proton Fullscreen hack (Allows resolution changes for fullscreen games without changing desktop resolution)
- Plasma 5 systray fix

For Gallium 9 support, use https://github.com/iXit/wine-nine-standalone (available from winetricks and AUR) - Legacy nine support can still be turned on if you're building a 4.1 base or older.


# Quick how-to :

## Download the source :


 * Clone the repo (that enables you to use `git pull` to get updates) :
```
git clone https://github.com/Tk-Glitch/PKGBUILDS.git
```


## Building on Arch (and other pacman/makepkg distros) :

From the `wine-tkg-git` directory (where the PKGBUILD is located), run the following command in a terminal to start the building process :
```
makepkg -si
```


## Building on other distros (experimental - see [the comments inside the script for more details](non-makepkg-build.sh) ) :

From the `wine-tkg-git` directory (where the PKGBUILD is located), run the following command in a terminal to start the building process :
```
./non-makepkg-build.sh
```
**Your build will be found in the `PKGBUILD/wine-tkg-git/non-makepkg-builds` dir independently of the chosen configuration**


Note for Ubuntu users who want to use docker instead: https://github.com/Tk-Glitch/PKGBUILDS/issues/69#issuecomment-450548800 Thanks to @yuiiio
