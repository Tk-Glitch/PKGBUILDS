#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

# This script creates Steamplay compatible wine builds based on wine-tkg-git and additional proton patches and libraries.
# It is not standalone and can be considered an addon to wine-tkg-git PKGBUILD and patchsets.

_where=$PWD

echo '       .---.`               `.---.       '
echo '    `/syhhhyso-           -osyhhhys/`    '
echo '   .syNMdhNNhss/``.---.``/sshNNhdMNys.   '
echo '   +sdMh.`+MNsssssssssssssssNM+`.hMds+   '
echo '   :syNNdhNNhssssssssssssssshNNhdNNys:   '
echo '    /ssyhhhysssssssssssssssssyhhhyss/    '
echo '    .ossssssssssssssssssssssssssssso.    '
echo '   :sssssssssssssssssssssssssssssssss:   '
echo '  /sssssssssssssssssssssssssssssssssss/  '
echo ' :sssssssssssssoosssssssoosssssssssssss: '
echo ' osssssssssssssoosssssssoossssssssssssso '
echo ' osssssssssssyyyyhhhhhhhyyyyssssssssssso '
echo ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/ '
echo '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms  '
echo '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/   '
echo '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`    '
echo '       `-+shdNNNNNNNNNNNNNNNdhs+-`       '
echo '             `.-:///////:-.`             '
echo ' ______              __                      __   __          '
echo '|   __ \.----.-----.|  |_.-----.-----.______|  |_|  |--.-----.'
echo '|    __/|   _|  _  ||   _|  _  |     |______|   _|    <|  _  |'
echo '|___|   |__| |_____||____|_____|__|__|      |____|__|__|___  |'
echo '                                                       |_____|'
echo ''
echo 'Also known as "Some kind of build wrapper for wine-tkg-git"'
echo ''

# We'll need a token to pass to register to wine-tkg-git
touch proton_tkg_token

# Now let's build
cd ../wine-tkg-git
makepkg -s

# Copy the resulting package in here to begin our work
if [ -e proton_dist*.tar.xz ]; then
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
  mkdir -p proton_template/share/fonts

  # Extract our custom package
  tar -xvf proton_dist*.tar.xz -C ./proton_dist_tmp >/dev/null 2>&1
  rm proton_dist*.tar.xz

  # Liberation Fonts
  rm -f proton_template/share/fonts/*
  git clone https://github.com/liberationfonts/liberation-fonts.git # It'll complain the path already exists on subsequent builds
  cd liberation-fonts
  git reset --hard HEAD
  git clean -xdf
  patch -Np1 < $_where/'LiberationMono-Regular.patch'
  make
  cp -rv liberation-fonts-ttf*/Liberation{Sans-Regular,Sans-Bold,Serif-Regular,Mono-Regular}.ttf $_where/proton_template/share/fonts/
  cd $_where

  # Grab share template and inject version
  echo "1552061114 proton-tkg-$_protontkg_version" > proton_dist_tmp/version && cp -r proton_template/share/* proton_dist_tmp/share/ #&& echo "1552061114" > ./proton_dist_tmp/share/default_pfx/.update-timestamp

  # Clone Proton tree as we need to build lsteamclient libs
  git clone https://github.com/ValveSoftware/Proton # It'll complain the path already exists on subsequent builds
  cd Proton
  git reset --hard HEAD
  git clean -xdf

  export WINEMAKERFLAGS="--nosource-fix --nolower-include --nodlls --nomsvcrt --dll"
  export CFLAGS="-O2 -g"
  export CXXFLAGS="-Wno-attributes -O2 -g" 
  
  mkdir -p build/lsteamclient.win64
  mkdir -p build/lsteamclient.win32

  cp -a lsteamclient/* build/lsteamclient.win64
  cp -a lsteamclient/* build/lsteamclient.win32

  cd build/lsteamclient.win64
  winemaker $WINEMAKERFLAGS -DSTEAM_API_EXPORTS .
  make -C $_where/Proton/build/lsteamclient.win64 && strip lsteamclient.dll.so
  cd ../..

  cd build/lsteamclient.win32
  winemaker $WINEMAKERFLAGS --wine32 -DSTEAM_API_EXPORTS .
  make -e CC="winegcc -m32" CXX="wineg++ -m32" -C $_where/Proton/build/lsteamclient.win32 && strip lsteamclient.dll.so
  cd $_where

  # Inject lsteamclient libs in our wine-tkg-git build
  cp -v Proton/build/lsteamclient.win64/lsteamclient.dll.so proton_dist_tmp/lib64/wine/
  cp -v Proton/build/lsteamclient.win32/lsteamclient.dll.so proton_dist_tmp/lib/wine/

  echo ''
  echo "Packaging..."

  # Package
  cd proton_dist_tmp && tar -zcf proton_dist.tar.gz bin/ include/ lib64/ lib/ share/ version && mv proton_dist.tar.gz ../proton_tkg_$_protontkg_version
  cd $_where && rm -rf proton_dist_tmp

  # Grab conf template and inject version
  echo "1552061114 proton-tkg-$_protontkg_version" > proton_tkg_$_protontkg_version/version && cp proton_template/conf/* proton_tkg_$_protontkg_version/ && sed -i -e "s|TKGVERSION|$_protontkg_version|" ./proton_tkg_$_protontkg_version/compatibilitytool.vdf

  # Nuke same version if exists before copying new build
  if [ -e $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version ]; then
    rm -rf $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version
  fi

  mv proton_tkg_$_protontkg_version $HOME/.steam/root/compatibilitytools.d/ && echo "" && echo "Proton-tkg build installed to $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version"

else
  rm proton_tkg_token
  echo "The required proton_dist package is missing! Wine-tkg-git compilation may have failed."
fi
