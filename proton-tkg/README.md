# Proton-tkg

This is an addon script for [wine-tkg-git](https://github.com/Tk-Glitch/PKGBUILDS/tree/master/wine-tkg-git).

It can create Steamplay compatible wine builds based on wine-tkg-git + additional proton patches and libraries. Wine-staging based? Latest master? Yup, you can.

**This is not standalone and requires Steam. If you want a standalone wine build, use [wine-tkg-git](https://github.com/Tk-Glitch/PKGBUILDS/tree/master/wine-tkg-git) instead.**

Running the proton-tkg.sh script will launch the usual wine-tkg-git building process... with extra spice. **Older than 3.16 wine bases are untested.**

**Resulting builds will be installed in `~/.steam/steam/compatibilitytools.d`**

The following wine-tkg-git options will be enforced (might change in the future):
- _EXTERNAL_INSTALL="true"
- _EXTERNAL_INSTALL_TYPE="proton"
- _EXTERNAL_NOVER="false"
- _use_dxvk="true"
- _dxvk_dxgi="true"
- _use_faudio="true"

**All other wine-tkg-git settings can be tweaked such as wine version, staging, esync, game fixes (etc.) and the userpatches functionality is kept intact**

## Things to know :

- DXVK winelib currently has limitations versus mingw built. It might prevent some games to see your GPU even though most games should be fine. Installing a mingw built DXVK (using winetricks for example) to such game's prefix is a workaround.
- Proton doesn't like running games from NTFS. Consider symlinking your compatdata dir(s) (usually found in /SteamApps) to some place on an EXT4 partition.
- SteamVR support is missing for compatibility reasons.
- Dinput SDL support is missing for lazyness reasons.
- In the userpatches folder, you'll find two patches I decided against merging in the master patch for proton-tkg. You can put them in wine-tkg-git userpatches dir if you want to use them.
