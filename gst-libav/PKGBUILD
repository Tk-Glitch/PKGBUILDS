# Based on gst-libav pkgbuild for Archlinux
# Maintainer: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
# Contributor: Jan de Groot <jgc@archlinux.org>

# Modified for extended+multilib by: Tk-Glitch <ti3nou at gmail dot com>

plain '       .---.`               `.---.'
plain '    `/syhhhyso-           -osyhhhys/`'
plain '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
plain '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
plain '   :syNNdhNNhssssssssssssssshNNhdNNys:'
plain '    /ssyhhhysssssssssssssssssyhhhyss/'
plain '    .ossssssssssssssssssssssssssssso.'
plain '   :sssssssssssssssssssssssssssssssss:'
plain '  /sssssssssssssssssssssssssssssssssss/'
plain ' :sssssssssssssoosssssssoosssssssssssss:'
plain ' osssssssssssssoosssssssoossssssssssssso'
plain ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
plain ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
plain '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
plain '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
plain '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
plain '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
plain '             `.-:///////:-.`'

# Include lib32 ?
_lib32="true"

# Version selector
if [ ! -e options ]; then
  read -p "  Build the regular version or the git one?`echo $'\n\n  > 1.Regular 1.16.2 (default and recommended)\n\n    2.Git (lib32 will be disabled)\n\nchoice[1-2?]: '`" CONDITION;
    if [ "$CONDITION" == "2" ]; then
      echo '_gitext="-git"' > options
      echo '_lib32="false"' >> options
    else
      echo '_commit="#commit=090cfd40aad49ad645a9bf4bdd62e65b739c95f3"' > options # version 1.16.2^0
    fi
fi

source options

if [ "$_lib32" == "true" ]; then
  _lib32dep='lib32-gst-plugins-base-libs'
fi

where=$PWD # track basedir as different Arch based distros are moving srcdir around
_basename=gst-libav

if [ "$_lib32" == "true" ]; then
  pkgname=("$_basename-tkg$_gitext" "lib32-$_basename-tkg$_gitext")
else
  pkgname=("$_basename-tkg$_gitext")
fi

pkgver=1.16.2
pkgrel=1
pkgdesc="GStreamer open-source multimedia framework FFmpeg plugin"
url="https://gstreamer.freedesktop.org/"
arch=('x86_64')
license=(GPL)

if [ "$_gitext" == "-git" ]; then
  depends=('gstreamer-git' 'gst-plugins-base-git' 'bzip2' 'ffmpeg')
else
  depends=('gst-plugins-base-libs' $_lib32dep 'bzip2' 'ffmpeg')
fi

makedepends=('python' 'gtk-doc' 'git' 'yasm' 'schedtool' 'meson')
optdepends=(
    # 64-bit
    # official repositories:
        'glibc' 'alsa-lib' 'jack' 'libpng'
        'bzip2' 'frei0r-plugins' 'libgcrypt' 'gmp' 'gnutls' 'ladspa' 'libass' 'aom'
        'libbluray' 'libbs2b' 'libcaca' 'celt' 'libcdio-paranoia' 'libdc1394'
        'libavc1394' 'libfdk-aac' 'fontconfig' 'freetype2' 'fribidi' 'libgme' 'gsm'
        'libiec61883' 'libmodplug' 'lame' 'opencore-amr' 'openjpeg2' 'opus' 'pulseaudio'
        'librsvg' 'rubberband' 'rtmpdump' 'smbclient' 'snappy' 'libsoxr' 'speex' 'srt'
        'libssh' 'tesseract' 'libtheora' 'twolame' 'v4l-utils' 'vid.stab' 'libvorbis'
        'libvpx' 'wavpack' 'libwebp' 'libx264.so' 'x265' 'libxcb' 'xvidcore' 'libxml2'
        'zimg' 'zeromq' 'zvbi' 'lv2' 'lilv' 'xz' 'openal' 'ocl-icd' 'libgl' 'sndio'
        'sdl2' 'libxv' 'libx11' 'libxext' 'zlib' 'libomxil-bellagio' 'libva' 'libdrm'
        'libvdpau'
    # AUR:
        'chromaprint-fftw' 'codec2' 'flite1-patched' 'libilbc' 'kvazaar' 'openh264'
        'libopenmpt-svn' 'shine' 'vo-amrwbenc' 'xavs' 'ndi-sdk' 'libmysofa'
        'rockchip-mpp'
    # 32-bit
    # official repositories (some are broken - HALP):
        'lib32-glibc' 'lib32-alsa-lib' 'lib32-jack' 'lib32-libpng'
        'lib32-bzip2' 'lib32-frei0r-plugins' 'lib32-libgcrypt' 'lib32-gmp' 'lib32-gnutls' 'lib32-ladspa' 'lib32-libass' 'lib32-aom'
        'lib32-libbluray' 'lib32-libbs2b' 'lib32-libcaca' 'lib32-celt' 'lib32-libcdio-paranoia' 'lib32-libdc1394'
        'lib32-libavc1394' 'lib32-libfdk-aac' 'lib32-fontconfig' 'lib32-freetype2' 'lib32-fribidi' 'lib32-libgme' 'lib32-gsm'
        'lib32-libiec61883' 'lib32-libmodplug' 'lib32-lame' 'lib32-opencore-amr' 'lib32-openjpeg2' 'lib32-opus' 'lib32-pulseaudio'
        'lib32-librsvg' 'lib32-rubberband' 'lib32-rtmpdump' 'lib32-smbclient' 'lib32-snappy' 'lib32-libsoxr' 'lib32-speex' 'lib32-srt'
        'lib32-libssh' 'lib32-tesseract' 'lib32-libtheora' 'lib32-twolame' 'lib32-v4l-utils' 'lib32-vid.stab' 'lib32-libvorbis'
        'lib32-libvpx' 'lib32-wavpack' 'lib32-libwebp' 'lib32-libx264.so' 'lib32-x265' 'lib32-libxcb' 'lib32-xvidcore' 'lib32-libxml2'
        'lib32-zimg' 'lib32-zeromq' 'lib32-zvbi' 'lib32-lv2' 'lib32-lilv' 'lib32-xz' 'lib32-openal' 'lib32-ocl-icd' 'lib32-libgl' 'lib32-sndio'
        'lib32-sdl2' 'lib32-libxv' 'lib32-libx11' 'lib32-libxext' 'lib32-zlib' 'lib32-libomxil-bellagio' 'lib32-libva' 'lib32-libdrm'
        'lib32-libvdpau'
    # AUR (some are broken - HALP):
        'lib32-chromaprint-fftw' 'lib32-codec2' 'lib32-flite1-patched' 'lib32-libilbc' 'lib32-kvazaar' 'lib32-openh264'
        'lib32-libopenmpt-svn' 'lib32-shine' 'lib32-vo-amrwbenc' 'lib32-xavs' 'lib32-ndi-sdk' 'lib32-libmysofa'
        'lib32-rockchip-mpp'
)

source=("git+https://anongit.freedesktop.org/git/gstreamer/gst-libav#commit=$_commit"
        "gst-common::git+https://anongit.freedesktop.org/git/gstreamer/common"
        "git+https://git.videolan.org/git/ffmpeg" "git://git.libav.org/gas-preprocessor")
sha256sums=('SKIP'
            'SKIP'
            'SKIP'
            'SKIP')

pkgver() {
  cd $_basename
  git describe --tags | sed 's/-/+/g'
}

prepare() {
  cd $_basename

  git submodule init
  git config --local submodule.common.url "$srcdir/gst-common"
  git config --local submodule.gst-libs/ext/libav.url "$srcdir/ffmpeg"
  git config --local submodule.gst-libs/ext/gas-preprocessor.url "$srcdir/gas-preprocessor"
  git submodule update

  NOCONFIGURE=1 ./autogen.sh

  rm -rf "${srcdir}"/"$_basename-tkg$_gitext"
  rm -rf "${srcdir}"/"lib32-$_basename-tkg$_gitext"
  
  mkdir -p "${srcdir}"/"$_basename-tkg$_gitext"
  mkdir -p "${srcdir}"/"lib32-$_basename-tkg$_gitext"
}

build() {
  export CC='gcc -m64'
  export CXX='g++ -m64'
  export PKG_CONFIG_PATH='/usr/lib/pkgconfig'

  cd "${srcdir}"/"$_basename-tkg$_gitext"
  "${srcdir}"/"$_basename"/configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --libexecdir=/usr/lib \
    --libdir=/usr/lib \
    --build=x86_64-pc-linux-gnu \
    --with-package-name="GStreamer libav Plugin (Arch Linux)" \
    --with-package-origin="http://www.archlinux.org/" \
    --without-system-libav \
    --with-libav-extra-configure="--enable-runtime-cpudetect" \
    --enable-experimental \
    --disable-gtk-doc \
    --disable-static

  # https://bugzilla.gnome.org/show_bug.cgi?id=655517
  sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool

  make

if [ "$_lib32" == "true" ]; then
  export CC='gcc -m32'
  export CXX='g++ -m32'
  export PKG_CONFIG_PATH='/usr/lib32/pkgconfig'

  cd "${srcdir}"/"lib32-$_basename-tkg$_gitext"
  "${srcdir}"/"$_basename"/configure \
    --prefix=/usr \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --libexecdir=/usr/lib32 \
    --libdir=/usr/lib32 \
    --build=i686-pc-linux-gnu \
    --with-package-name="GStreamer libav Plugin (Arch Linux)" \
    --with-package-origin="http://www.archlinux.org/" \
    --without-system-libav \
    --with-libav-extra-configure="--enable-runtime-cpudetect" \
    --enable-experimental \
    --disable-gtk-doc \
    --disable-static

  # https://bugzilla.gnome.org/show_bug.cgi?id=655517
  sed -i -e 's/ -shared / -Wl,-O1,--as-needed\0/g' libtool

  make
fi
}

check() {
  cd "${srcdir}"/"$_basename-tkg$_gitext" && make check

if [ "$_lib32" == "true" ]; then
   cd "${srcdir}"/"lib32-$_basename-tkg$_gitext" && make check
fi
}

pack64() {
  provides=("gst-ffmpeg=$pkgver-$pkgrel" 'gst-libav')
  conflicts=('gst-libav')

  msg2 'Packaging gst-ffmpeg...'
  cd "${srcdir}"/"$_basename-tkg$_gitext" && make DESTDIR="$pkgdir" install
}

pack32() {
  provides=("lib32-gst-ffmpeg=$pkgver-$pkgrel" 'lib32-gst-libav')
  conflicts=('lib32-gst-libav')

  msg2 'Packaging lib32-gst-ffmpeg...'
  cd "${srcdir}"/"lib32-$_basename-tkg$_gitext" && make DESTDIR="$pkgdir" install
}

package_gst-libav-tkg() {
pack64
}

package_gst-libav-tkg-git() {
pack64
}

package_lib32-gst-libav-tkg() {
pack32
}

package_lib32-gst-libav-tkg-git() {
pack32
}

function exit_cleanup {
  # Remove the state tracker
  rm -f $where/options

  remove_deps

  msg2 'exit cleanup done'
}

trap exit_cleanup EXIT
