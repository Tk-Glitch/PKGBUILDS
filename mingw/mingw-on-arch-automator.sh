#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

_where=$PWD
_dwarf2=true
_fortran=true

 echo '#################################################################'
 echo ''
 echo 'Mingw on arch automator will install mingw for you. Since the'
 echo 'automation process needs to use pacman, your password is required.'
 echo ''
 echo '###################################TkG##########was##########here'

# cleanup
echo "Cleaning up"
rm -rf mingw-w64-*
rm -rf cloog-git

sudo pacman -Rscnd mingw-w64 --noconfirm

# cloog git - Needed for a successful build for now
git clone https://aur.archlinux.org/cloog-git.git
cd cloog-git
makepkg -si --noconfirm
cd $_where

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

echo "Done"
