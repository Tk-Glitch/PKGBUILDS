# Proton-tkg

This is an addon script for [wine-tkg-git](https://github.com/Tk-Glitch/PKGBUILDS/tree/master/wine-tkg-git).

### It can create Steamplay compatible wine builds based on wine-tkg-git + additional proton patches and libraries. Wine-staging based? Latest master? Yup, you can.
( **Older than 3.16 wine bases are untested.** )

### This is not standalone and requires Steam. If you want a standalone wine build, use [wine-tkg-git](https://github.com/Tk-Glitch/PKGBUILDS/tree/master/wine-tkg-git) instead.

**The following wine-tkg-git options will be enforced (might change in the future):**
- `_EXTERNAL_INSTALL="true"`
- `_EXTERNAL_INSTALL_TYPE="proton"`
- `_EXTERNAL_NOVER="false"`
- `_use_faudio="true"`

**You cannot actually build proton-tkg without DXVK.** When `_use_dxvk_winelib` is set to "false", you'll need to put prebuilt DXVK dlls inside a dxvk folder, in the root folder of proton-tkg (here):
```
proton-tkg
   |
   |__dxvk___x64--> d3d11.dll, dxgi.dll etc.
          |
          |__x32--> d3d11.dll, dxgi.dll etc.
```

**All other wine-tkg-git settings can be tweaked such as wine version, staging, esync, game fixes (etc.) and the userpatches functionality is kept intact.**

You can find all your usual options in the proton-tkg.cfg file. If you create a proton-tkg.cfg file in ~/.config/frogminer dir, it'll be used as an override.

### Running the proton-tkg.sh script will launch the usual wine-tkg-git building process... with extra spice. ###
```
./proton-tkg.sh
```

## Special options and builtin features :

Proton-tkg builds are coming with special additional features you can enable/disable post install in the `user_settings.py` file found in your build's folder (`~/.steam/root/compatibilitytools.d/proton_tkg_*`):
- `PROTON_NVAPI_DISABLE` - Enabled by default, it'll set nvapi and nvapi64 dlls to disabled. It is a common fix for many games.
- `PROTON_WINEDBG_DISABLE` - Enabled by default, it'll set winedbg.exe to disabled. It's a known fix for GTA V online.
- `PROTON_PULSE_LOWLATENCY` - Enabled by default, it'll set Pulseaudio latency to 60ms. This usually helps with audio crackling issues on some setups.
- `PROTON_DXVK_ASYNC` - Disabled by default, it'll enable DXVK's async pipecompiler on a compatible DXVK build. Known as the "poe hack", that option *could* be unsafe, so beware.

You can also change there default value before building in your `proton-tkg.cfg` file.


## Other things to know :

- DXVK winelib currently has limitations and might prevent some (rare) games to see your GPU. Making a non-winelib build is recommended for compatibility sakes. Installing a mingw built DXVK (using winetricks for example) to an affected game's prefix can also be used as a workaround. **You can build DXVK using [dxvk-tools](https://github.com/Tk-Glitch/PKGBUILDS/tree/master/dxvk-tools)**

- Proton doesn't like running games from NTFS. Consider symlinking your compatdata dir(s) (usually found in /SteamApps) to some place on an EXT4 partition.

- SteamVR support is missing for compatibility reasons.

- Dinput SDL support is missing for lazyness reasons.

- In the userpatches folder, you'll find two patches I decided against merging in the master patch for proton-tkg. You can put them in wine-tkg-git userpatches dir if you want to use them. They might not apply cleanly on older wine bases.

- Proton-tkg builds will get installed in `~/.steam/root/compatibilitytools.d` directory. If you want to uninstall a build, just delete its folder there and restart Steam. **MAKE SURE NO STEAM GAME IS CURRENTLY SET TO USE THAT SPECIFIC VERSION BEFORE DELETION**
