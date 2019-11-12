#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

cat << 'EOM'
       .---.`               `.---.
    `/syhhhyso-           -osyhhhys/`
   .syNMdhNNhss/``.---.``/sshNNhdMNys.
   +sdMh.`+MNsssssssssssssssNM+`.hMds+
   :syNNdhNNhssssssssssssssshNNhdNNys:
    /ssyhhhysssssssssssssssssyhhhyss/
    .ossssssssssssssssssssssssssssso.
   :sssssssssssssssssssssssssssssssss:
  /sssssssssssssssssssssssssssssssssss/
 :sssssssssssssoosssssssoosssssssssssss:
 osssssssssssssoosssssssoossssssssssssso
 osssssssssssyyyyhhhhhhhyyyyssssssssssso
 /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/
  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms
   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/
    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`
       `-+shdNNNNNNNNNNNNNNNdhs+-`
             `.-:///////:-.`

EOM

export BUILDDIR= # Override makepkg BUILDDIR path and use PKGBUILDs dirs instead

_arg1="$1"
_where=$PWD
_dwarf2=true
_fortran=false
_win32threads=false
_cloog_git=false
_pgp_auto=true

_sdlandco=false

# Set to true to clean sources after building - If set to false, you'll be prompted about it
_NUKR=false

 echo '##################################################################'
 echo ''
 echo 'Mingw on arch automator will install mingw for you. The automation'
 echo 'process needs to use pacman, so your password will be required.'
 echo ''
 echo '####################################TkG##########was##########here'

if [ $_NUKR == "false" ]; then
  echo ''
  echo -e "  \033[1mDo you want to delete build/src dirs before & after building?\033[0m"
  echo -e "    \033[1m- Doing so will ensure you're running the latest version.\033[0m"
  echo "    - Default (No) will keep sources/tarballs and packages around,"
  echo "      without updating existing PKGBUILDs if any."
  read -rp "  N/y: " _clean_mingw;
  if [ "$_clean_mingw" == "y" ]; then
    _NUKR=true
    # cleanup
    echo "Cleaning up"
    rm -rf mingw-w64-*
    rm -rf cloo*
    rm -rf osl
    rm -rf isl
  fi
fi

_mingwloop() {
  git clone https://aur.archlinux.org/$_AURPKGNAME.git
  cd $_AURPKGNAME
  rm *.pkg.* # Delete package if exists
  if [ "$_win32threads" == "true" ]; then
    sed -i "s/threads=posix/threads=win32/g" PKGBUILD
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-headers" ]; then
    #v6.0.0 folder in 7.0.0 sources issue
    patch PKGBUILD << 'EOM'  
@@ -9,7 +9,7 @@
 options=('!strip' '!libtool' '!emptydirs')
 validpgpkeys=('CAF5641F74F7DFBA88AE205693BDB53CD4EBC740')
 source=(https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${pkgver}.tar.bz2{,.sig})
-sha256sums=('aa20dfff3596f08a7f427aab74315a6cb80c2b086b4a107ed35af02f9496b628'
+sha256sums=('f5c9a04e1a6c02c9ef2ec19b3906ec4613606d1b5450d34bbd3c4d94ac696b3b'
             'SKIP')
 
 _targets="i686-w64-mingw32 x86_64-w64-mingw32"
@@ -18,7 +18,7 @@
   for _target in ${_targets}; do
     msg "Configuring ${_target} headers"
     mkdir -p "$srcdir"/headers-${_target} && cd "$srcdir"/headers-${_target}
-    "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-headers/configure --prefix=/usr/${_target} --enable-sdk=all --enable-secure-api --host=${_target}
+    "$srcdir"/mingw-w64-v6.0.0/mingw-w64-headers/configure --prefix=/usr/${_target} --enable-sdk=all --enable-secure-api --host=${_target}
   done
 }
 
@@ -33,9 +33,9 @@
   done
 
   msg "Installing MinGW-w64 licenses"
-  install -Dm644 "$srcdir"/mingw-w64-v${pkgver}/COPYING.MinGW-w64/COPYING.MinGW-w64.txt "$pkgdir"/usr/share/licenses/${pkgname}/COPYING.MinGW-w64.txt
-  install -Dm644 "$srcdir"/mingw-w64-v${pkgver}/COPYING.MinGW-w64-runtime/COPYING.MinGW-w64-runtime.txt "$pkgdir"/usr/share/licenses/${pkgname}/COPYING.MinGW-w64-runtime.txt
-  install -Dm644 "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-headers/ddk/readme.txt "$pkgdir"/usr/share/licenses/${pkgname}/ddk-readme.txt
-  install -Dm644 "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-headers/direct-x/COPYING.LIB "$pkgdir"/usr/share/licenses/${pkgname}/direct-x-COPYING.LIB
-  install -Dm644 "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-headers/direct-x/readme.txt "$pkgdir"/usr/share/licenses/${pkgname}/direct-x-readme.txt
+  install -Dm644 "$srcdir"/mingw-w64-v6.0.0/COPYING.MinGW-w64/COPYING.MinGW-w64.txt "$pkgdir"/usr/share/licenses/${pkgname}/COPYING.MinGW-w64.txt
+  install -Dm644 "$srcdir"/mingw-w64-v6.0.0/COPYING.MinGW-w64-runtime/COPYING.MinGW-w64-runtime.txt "$pkgdir"/usr/share/licenses/${pkgname}/COPYING.MinGW-w64-runtime.txt
+  install -Dm644 "$srcdir"/mingw-w64-v6.0.0/mingw-w64-headers/ddk/readme.txt "$pkgdir"/usr/share/licenses/${pkgname}/ddk-readme.txt
+  install -Dm644 "$srcdir"/mingw-w64-v6.0.0/mingw-w64-headers/direct-x/COPYING.LIB "$pkgdir"/usr/share/licenses/${pkgname}/direct-x-COPYING.LIB
+  install -Dm644 "$srcdir"/mingw-w64-v6.0.0/mingw-w64-headers/direct-x/readme.txt "$pkgdir"/usr/share/licenses/${pkgname}/direct-x-readme.txt
 }
EOM
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-winpthreads" ]; then
    patch PKGBUILD << 'EOM'
@@ -13,7 +13,7 @@
 options=('!strip' '!buildflags' 'staticlibs' '!emptydirs')
 validpgpkeys=('CAF5641F74F7DFBA88AE205693BDB53CD4EBC740')
 source=(https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${pkgver}.tar.bz2{,.sig})
-sha256sums=('aa20dfff3596f08a7f427aab74315a6cb80c2b086b4a107ed35af02f9496b628'
+sha256sums=('f5c9a04e1a6c02c9ef2ec19b3906ec4613606d1b5450d34bbd3c4d94ac696b3b'
             'SKIP')
 
 _targets="i686-w64-mingw32 x86_64-w64-mingw32"
@@ -22,7 +22,7 @@
   for _target in ${_targets}; do
     msg "Building ${_target} winpthreads..."
     mkdir -p "$srcdir"/winpthreads-build-${_target} && cd "$srcdir"/winpthreads-build-${_target}
-    "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-libraries/winpthreads/configure --prefix=/usr/${_target} \
+    "$srcdir"/mingw-w64-v6.0.0/mingw-w64-libraries/winpthreads/configure --prefix=/usr/${_target} \
         --host=${_target} --enable-static --enable-shared
     make
   done 
EOM
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-gcc-base" ] && [ $_dwarf2 == "true" ]; then
    #dwarf2 exceptions
    patch PKGBUILD << 'EOM'
@@ -44,7 +44,7 @@
         --enable-languages=c,lto \
         --enable-static \
         --with-system-zlib \
-        --enable-lto --disable-dw2-exceptions \
+        --enable-lto --disable-sjlj-exceptions --with-dwarf2 \
         --disable-nls --enable-version-specific-runtime-libs \
         --disable-multilib --enable-checking=release
     make all-gcc
EOM
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-crt" ]; then
    patch PKGBUILD << 'EOM'
@@ -10,7 +10,7 @@
 options=('!strip' '!buildflags' 'staticlibs' '!emptydirs')
 validpgpkeys=('CAF5641F74F7DFBA88AE205693BDB53CD4EBC740')
 source=(https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${pkgver}.tar.bz2{,.sig})
-sha256sums=('aa20dfff3596f08a7f427aab74315a6cb80c2b086b4a107ed35af02f9496b628'
+sha256sums=('f5c9a04e1a6c02c9ef2ec19b3906ec4613606d1b5450d34bbd3c4d94ac696b3b'
             'SKIP')
 
 _targets="i686-w64-mingw32 x86_64-w64-mingw32"
@@ -25,7 +25,7 @@
         _crt_configure_args="--disable-lib32 --enable-lib64"
     fi
     mkdir -p "$srcdir"/crt-${_target} && cd "$srcdir"/crt-${_target}
-    "$srcdir"/mingw-w64-v${pkgver}/mingw-w64-crt/configure --prefix=/usr/${_target} \
+    "$srcdir"/mingw-w64-v6.0.0/mingw-w64-crt/configure --prefix=/usr/${_target} \
         --host=${_target} --enable-wildcard \
         ${_crt_configure_args}
     make

EOM
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-gcc" ] && [ $_fortran == "false" ]; then
    #no fortran
    patch PKGBUILD << 'EOM'
@@ -45,7 +45,7 @@
 
     "$srcdir"/gcc/configure --prefix=/usr --libexecdir=/usr/lib \
         --target=${_target} \
-        --enable-languages=c,lto,c++,objc,obj-c++,fortran,ada \
+        --enable-languages=c,lto,c++,objc,obj-c++,ada \
         --enable-shared --enable-static \
         --enable-threads=posix --enable-fully-dynamic-string \
         --enable-libstdcxx-time=yes --enable-libstdcxx-filesystem-ts=yes \
@@ -62,7 +62,7 @@
     make DESTDIR="$pkgdir" install
     ${_target}-strip "$pkgdir"/usr/${_target}/lib/*.dll
     strip "$pkgdir"/usr/bin/${_target}-*
-    strip "$pkgdir"/usr/lib/gcc/${_target}/${pkgver:0:5}/{cc1*,collect2,gnat1,f951,lto*}
+    strip "$pkgdir"/usr/lib/gcc/${_target}/${pkgver:0:5}/{cc1*,collect2,gnat1,lto*}
     ln -s ${_target}-gcc "$pkgdir"/usr/bin/${_target}-cc
     # mv dlls
     mkdir -p "$pkgdir"/usr/${_target}/bin/
EOM
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-gcc" ] && [ $_dwarf2 == "true" ]; then
    #dwarf2 exceptions
    patch PKGBUILD << 'EOM'
@@ -50,7 +50,7 @@
         --enable-threads=posix --enable-fully-dynamic-string \
         --enable-libstdcxx-time=yes --enable-libstdcxx-filesystem-ts=yes \
         --with-system-zlib --enable-cloog-backend=isl \
-        --enable-lto --disable-dw2-exceptions --enable-libgomp \
+        --enable-lto --disable-sjlj-exceptions --with-dwarf2 --enable-libgomp \
         --disable-multilib --enable-checking=release
     make
   done
EOM
  fi
  if [[ "$_arg1" == "-f" ]] || [[ "$_arg1" == "--force" ]]; then
    makepkg -csi --noconfirm --force
  else
    makepkg -csi --noconfirm
  fi
  if [ "$_AURPKGNAME" == "mingw-w64-winpthreads" ]; then
    libtool --finish /usr/x86_64-w64-mingw32/lib
  fi
  cd $_where
}

# PGP keys
if [ $_pgp_auto == "true" ]; then
  gpg --recv-keys 13FCEF89DD9E3C4F
  gpg --recv-keys 93BDB53CD4EBC740
  gpg --recv-keys A328C3A2C3C45C06
fi

sudo pacman -Rscnd mingw-w64 --noconfirm

if [ ! -e ../wine-tkg-git/BIG_UGLY_FROGMINER ]; then
  trap "exit" INT TERM
  trap "kill 0" EXIT
fi

sudo -v || exit $?
sleep 1
while true; do
  sleep 60
  sudo -nv
done 2>/dev/null &

# cloog git - If the usual cloog package fails with mingw, you'll need -git
if [ $_cloog_git == "true" ]; then
  sudo pacman -Rscnd cloog --noconfirm
  _AURPKGNAME=cloog-git
  _mingwloop || exit 1
else
  sudo pacman -Rscnd cloog-git --noconfirm

  # osl - isl - cloog
  _AURPKGS=(osl isl cloog)
  for _AURPKGNAME in "${_AURPKGS[@]}"; do
    _mingwloop || exit 1
  done
fi

# mingw-w64-binutils - mingw-w64-headers - mingw-w64-headers-bootstrap - mingw-w64-gcc-base - mingw-w64-crt
_AURPKGS=(mingw-w64-binutils mingw-w64-headers mingw-w64-headers-bootstrap mingw-w64-gcc-base mingw-w64-crt)
for _AURPKGNAME in "${_AURPKGS[@]}"; do
  _mingwloop || exit 1
done

# remove mingw-w64-headers-bootstrap
sudo pacman -Rdd --noconfirm mingw-w64-headers-bootstrap

# mingw-w64-winpthreads
_AURPKGNAME=mingw-w64-winpthreads
_mingwloop || exit 1

# remove mingw-w64-gcc-base
sudo pacman -Rdd --noconfirm mingw-w64-gcc-base

# mingw-w64-gcc
_AURPKGNAME=mingw-w64-gcc
_mingwloop || exit 1

if [ $_sdlandco == "true" ]; then
  # mingw-w64-pkg-config - mingw-w64-configure - mingw-w64-cmake - mingw-w64-sdl2
  _AURPKGS=(mingw-w64-pkg-config mingw-w64-configure mingw-w64-cmake mingw-w64-sdl2)
  for _AURPKGNAME in "${_AURPKGS[@]}"; do
    _mingwloop || exit 1
  done
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
echo "mingw-on-arch done !" && exit 0
