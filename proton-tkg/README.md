# Proton-tkg-git

This is an addon script for wine-tkg-git.

It can create Steamplay compatible wine builds based on wine-tkg-git + additional proton patches and libraries.

**This is not standalone**

Running the proton-tkg.sh script will launch the usual wine-tkg-git building process.. With extra spice.

**Resulting builds will be installed in `~/.steam/steam/compatibilitytools.d`**

The following wine-tkg-git options will be enforced (might change in the future):
- _EXTERNAL_INSTALL="true"
- _EXTERNAL_INSTALL_TYPE="proton"
- _EXTERNAL_NOVER="false"
- _use_dxvk="true"
- _dxvk_dxgi="true"
- _use_faudio="true"
