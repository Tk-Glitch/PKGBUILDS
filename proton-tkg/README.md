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

**Note: No SteamVR support for compatibility reasons.**
