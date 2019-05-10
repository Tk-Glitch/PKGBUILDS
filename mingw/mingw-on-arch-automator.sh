#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

_where=$PWD
_dwarf2=true
_fortran=true
_cloog_git=false
_pgp_auto=true

_sdlandco=false

# Set to true to clean sources after building - If set to false, you'll be prompted about it
_NUKR=false

 echo '#################################################################'
 echo ''
 echo 'Mingw on arch automator will install mingw for you. Since the'
 echo 'automation process needs to use pacman, your password is required.'
 echo ''
 echo '###################################TkG##########was##########here'

# cleanup
echo "Cleaning up"
rm -rf mingw-w64-*
rm -rf cloo*
rm -rf osl
rm -rf isl

if [ $_NUKR == "false" ]; then
  read -rp "Wanna clean everything after building? N/y: " _clean_mingw;
  if [ "$_clean_mingw" == "y" ]; then
    _NUKR=true
  fi
fi

# PGP keys
if [ $_pgp_auto == "true" ]; then
  gpg --recv-keys 13FCEF89DD9E3C4F
  gpg --recv-keys 93BDB53CD4EBC740
  gpg --recv-keys A328C3A2C3C45C06
fi

sudo pacman -Rscnd mingw-w64 --noconfirm

trap "exit" INT TERM
trap "kill 0" EXIT
sudo -v || exit $?
sleep 1
while true; do
  sleep 60
  sudo -nv
done 2>/dev/null &

# cloog git - If the usual cloog package fails with mingw, you'll need -git
if [ $_cloog_git == "true" ]; then
  sudo pacman -Rscnd cloog --noconfirm
  git clone https://aur.archlinux.org/cloog-git.git
  cd cloog-git
  makepkg -si --noconfirm
  cd $_where
else
  sudo pacman -Rscnd cloog-git --noconfirm

  # osl
  git clone https://aur.archlinux.org/osl.git
  cd osl
  makepkg -si --noconfirm
  cd $_where

  #isl
  git clone https://aur.archlinux.org/isl.git
  cd isl
  makepkg -si --noconfirm
  cd $_where

  # cloog
  sudo pacman -Rscnd cloog --noconfirm
  git clone https://aur.archlinux.org/cloog.git
  cd cloog
  makepkg -si --noconfirm
  cd $_where
fi

# mingw-w64-binutils
git clone https://aur.archlinux.org/mingw-w64-binutils.git
cd mingw-w64-binutils
makepkg -si --noconfirm
cd $_where

# mingw-w64-headers
git clone https://aur.archlinux.org/mingw-w64-headers.git
cd mingw-w64-headers
makepkg -si --noconfirm
cd $_where

# mingw-w64-headers-bootstrap
git clone https://aur.archlinux.org/mingw-w64-headers-bootstrap.git
cd mingw-w64-headers-bootstrap
makepkg -si --noconfirm
cd $_where

# mingw-w64-gcc-base
git clone https://aur.archlinux.org/mingw-w64-gcc-base.git
cd mingw-w64-gcc-base

if [ $_dwarf2 == "true" ]; then
  sed -i -e "s|        --enable-lto --disable-dw2-exceptions.*|        --enable-lto --disable-sjlj-exceptions --with-dwarf2 \\\|" PKGBUILD #dwarf2 exceptions
fi

makepkg -si --noconfirm
cd $_where

# mingw-w64-crt.git
git clone https://aur.archlinux.org/mingw-w64-crt.git
cd mingw-w64-crt
makepkg -si --noconfirm
cd $_where

# remove mingw-w64-headers-bootstrap
sudo pacman -Rdd --noconfirm mingw-w64-headers-bootstrap

# mingw-w64-winpthreads
git clone https://aur.archlinux.org/mingw-w64-winpthreads.git
cd mingw-w64-winpthreads
makepkg -si --noconfirm
libtool --finish /usr/x86_64-w64-mingw32/lib
cd $_where

# remove mingw-w64-gcc-base
sudo pacman -Rdd --noconfirm mingw-w64-gcc-base

# mingw-w64-gcc
git clone https://aur.archlinux.org/mingw-w64-gcc.git
cd mingw-w64-gcc

if [ $_fortran == "false" ]; then
  sed -i -e "s|        --enable-languages=c,lto,c++,objc,obj-c++,fortran,ada.*|        --enable-languages=c,lto,c++,objc,obj-c++,ada \\\|" PKGBUILD #no fortran
fi

if [ $_dwarf2 == "true" ]; then
  sed -i -e "s|        --enable-lto --disable-dw2-exceptions.*|        --enable-lto --disable-sjlj-exceptions --with-dwarf2 --enable-libgomp \\\|" PKGBUILD #dwarf2 exceptions
fi

makepkg -si --noconfirm
cd $_where

# mingw-w64-crt.git - Rebuild against main gcc package
rm -rf mingw-w64-crt
git clone https://aur.archlinux.org/mingw-w64-crt.git
cd mingw-w64-crt
makepkg -si --noconfirm
cd $_where

# mingw-w64-winpthreads - Rebuild against main gcc package
rm -fr mingw-w64-winpthreads
git clone https://aur.archlinux.org/mingw-w64-winpthreads.git
cd mingw-w64-winpthreads
makepkg -si --noconfirm
libtool --finish /usr/x86_64-w64-mingw32/lib
cd $_where

if [ $_sdlandco == "true" ]; then
  # mingw-w64-pkg-config
  git clone https://aur.archlinux.org/mingw-w64-pkg-config.git
  cd mingw-w64-pkg-config
  makepkg -si --noconfirm
  cd $_where

  # mingw-w64-configure
  git clone https://aur.archlinux.org/mingw-w64-configure.git
  cd mingw-w64-configure
  makepkg -si --noconfirm
  cd $_where

  # mingw-w64-sdl2
  git clone https://aur.archlinux.org/mingw-w64-sdl2.git
  cd mingw-w64-sdl2
  makepkg -si --noconfirm
  cd $_where
fi

if [ $_NUKR == "true" ]; then
  # cleanup
  echo "Cleaning up..."
  rm -rf mingw-w64-*
  rm -rf cloo*
  rm -rf osl
  rm -rf isl
fi

echo ""
echo "mingw-on-arch done !"
