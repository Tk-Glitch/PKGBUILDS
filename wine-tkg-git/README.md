# Wine to rule them all !

This pkgbuild allows you to create custom wine builds using an opt-in mechanism (by editing the customization.cfg file). You can now easily get the "plain wine + pba + steam fix" build you've been dreaming about.

Can be built with DXVK winelib prebaked (replacing wined3d for d3d10 and d3d11 support) - https://github.com/doitsujin/dxvk

Can be built with VKD3D for D3D12 support (using https://github.com/Tk-Glitch/PKGBUILDS/tree/master/vkd3d-git is recommended) - https://source.winehq.org/git/vkd3d.git

Can be built with Faudio (requires both faudio-git and lib32-faudio-git packages from AUR) - https://github.com/FNA-XNA/FAudio

Wine : https://github.com/wine-mirror/wine

Wine-staging : https://github.com/wine-staging/wine-staging

Wine esync : https://github.com/zfigura/wine/tree/esync

Wine-pba : https://github.com/acomminos/wine-pba

Thanks to @Firerat and @bobwya for their rebase work :
- https://github.com/Firerat/wine-pba
- https://github.com/bobwya/gentoo-wine-pba

With other patches available such as :
- CSMT-toggle fixed logic - https://github.com/wine-staging/wine-staging/pull/60/commits/ad474559590a659b3df72ec9965de20c7f51c3a8
- GLSL-toggle for wined3d
- Path of Exile DX11 fix
- Steam --no-sandbox auto fix (for store support on higher than winxp mode)
- The Sims 2 fix
- Magic: The Gathering Arena fix
- Fortnite crash fix - https://github.com/Guy1524/fortnite-wine - "Working once every fortnite" ~FeetOnGrass
- Fallout 4 and Skyrim SE Script Extender fix - https://github.com/hdmap/wine-hackery/tree/master/f4se
- Fallout 4 Direct sound fix - https://bugs.winehq.org/show_bug.cgi?id=41271
- Winepulse disable patch (fix for various sound issues related to winepulse/pulsaudio)
- Lowlatency audio patch for osu! - https://blog.thepoon.fr/osuLinuxAudioLatency
- Use CLOCK_MONOTONIC instead of CLOCK_MONOTONIC_RAW in ntdll/server
- "Launch with dedicated gpu" desktop entry
- Bypass compositor in fullscreen mode
- Proton Fullscreen hack (Allows resolution changes for fullscreen games without changing desktop resolution)
- Plasma 5 systray fix
- Gallium 9 support

Also supports user patches for you to make even more exotic builds (more details at the end of the customization.cfg file).

Lutris esync (+staging +pba) builds are currently created using this pkgbuild - https://github.com/lutris/wine

Some daily builds are available on http://lonewolf-builder.duckdns.org/chaotic-aur as pacman packages.


# Quick how-to :

## Download the source :

 * Clone only this repo (you need to have the `subversion` package installed) :
```
svn export https://github.com/Tk-Glitch/PKGBUILDS/trunk/wine-tkg-git
```

OR

 * Clone the whole thing (that enables you to use `git pull` to get updates) :
```
git clone https://github.com/Tk-Glitch/PKGBUILDS.git
```


## Build  :

From the `wine-tkg-git` directory (where the PKGBUILD is located), run the following command in a terminal to start the building process :
```
makepkg -si
```

See the bottom of the customization.cfg file for how to apply your own patches.
