#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

# This script creates Steamplay compatible wine builds based on wine-tkg-git and additional proton patches and libraries.
# It is not standalone and can be considered an addon to wine-tkg-git PKGBUILD and patchsets.

_where=$PWD

echo ""
echo "Proton-tkg"
echo 'Also known as "Some kind of build wrapper for wine-tkg-git"'
echo ""

# We'll need a token to pass to register to wine-tkg-git
touch proton_tkg_token

# Now let's build
cd ../wine-tkg-git
makepkg -s

# Copy the resulting package in here to begin our work
mv proton_dist*.tar.xz $_where/
cd $_where

# Wine-tkg-git has injected version in the token for us
# Get the value back and get rid of the token
source proton_tkg_token
rm proton_tkg_token

# Create required dirs
mkdir -p $HOME/.steam/root/compatibilitytools.d
mkdir proton_dist_tmp
mkdir proton_tkg_$_protontkg_version

# Extract our custom package
tar -xvf proton_dist*.tar.xz -C ./proton_dist_tmp
rm proton_dist*.tar.xz

# Grab share template and inject version
echo "1552061114 proton-tkg-$_protontkg_version" > ./proton_dist_tmp/version #&& cp -r ./proton_template/share/* ./proton_dist_tmp/share/ && echo "1552061114" > ./proton_dist_tmp/share/default_pfx/.update-timestamp

# Clone Proton tree as we need to build lsteamclient libs FIXME
build_lsteamclient() {
rm -rf Proton
git clone https://github.com/ValveSoftware/Proton
cd Proton

export WINEMAKERFLAGS="--nosource-fix --nolower-include --nodlls --nomsvcrt"

mkdir -p build/lsteamclient.win64
mkdir -p build/lsteamclient.win32

cp -a lsteamclient/* build/lsteamclient.win64
cp -a lsteamclient/* build/lsteamclient.win32

cd build/lsteamclient.win64
winemaker $WINEMAKERFLAGS -DSTEAM_API_EXPORTS --dll .
export  CXXFLAGS="-Wno-attributes -O2 -g" CFLAGS="-O2 -g" && make -C $_where/Proton/build/lsteamclient.win64
cd ../..

cd build/lsteamclient.win32
winemaker $WINEMAKERFLAGS --wine32 -DSTEAM_API_EXPORTS --dll .
export LDFLAGS="-m32" CXXFLAGS="-m32 -Wno-attributes -O2 -g" CFLAGS="-m32 -O2 -g" && make -C $_where/Proton/build/lsteamclient.win32
cd $_where

# Inject lsteamclent libs in our wine-tkg-git build
cp -v Proton/build/lsteamclient.win64/lsteamclient.dll.so ./proton_dist_tmp/lib/wine/
cp -v Proton/build/lsteamclient.win32/lsteamclient.dll.so ./proton_dist_tmp/lib32/wine/
}

# Rename lib folders to stick to proton defaults
cd proton_dist_tmp && mv lib lib64 && mv lib32 lib

# Inject prebuit lsteamclient libs in our wine-tkg-git build for now as we are unable to compile 32-bit lib atm -- Any help appreciated FIXME
cp -v $_where/proton_template/lsteamclient/lib/wine/lsteamclient.dll.so ./lib/wine/
cp -v $_where/proton_template/lsteamclient/lib64/wine/lsteamclient.dll.so ./lib64/wine/

# Package
tar -zcf proton_dist.tar.gz bin/ include/ lib64/ lib/ share/ version && mv proton_dist.tar.gz ../proton_tkg_$_protontkg_version
cd $_where && rm -rf proton_dist_tmp

# Grab conf template and inject version
echo "1552061114 proton-tkg-$_protontkg_version" > ./proton_tkg_$_protontkg_version/version && cp ./proton_template/conf/* ./proton_tkg_$_protontkg_version/ && sed -i -e "s|TKGVERSION|$_protontkg_version|" ./proton_tkg_$_protontkg_version/compatibilitytool.vdf

# Nuke same version if exists before copying new build
if [ -e $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version ]; then
  rm -rf $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version
fi

echo "Packaging..."
mv ./proton_tkg_$_protontkg_version $HOME/.steam/root/compatibilitytools.d/ && echo "" && echo "Proton-tkg build installed to $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version"
