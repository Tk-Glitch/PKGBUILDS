# Based on Archlinux pkgbuild from Laurent Carlier <lordheavym@gmail.com>
# Modified for multilib by: Tk-Glitch <ti3nou at gmail dot com>

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

_NUKR="true"

pkgname=('vulkan-icd-loader-git' 'lib32-vulkan-icd-loader-git')
pkgver=1.2.135.r3.gacbf31604
pkgrel=1
arch=(x86_64)
pkgdesc="Vulkan Installable Client Driver (ICD) Loader"
url="https://www.khronos.org/vulkan/"
license=('custom')
makedepends=(cmake python-lxml libx11 libxrandr wayland vulkan-headers git python lib32-libx11 lib32-libxrandr lib32-wayland)
depends=(glibc)
optdepends=('vulkan-driver: packaged vulkan driver') # vulkan-driver: vulkan-intel/vulkan-radeon/nvidia-utils/....
source=("git+https://github.com/KhronosGroup/Vulkan-Loader.git")
sha256sums=('SKIP')

pkgver() {
  cd "${srcdir}"/Vulkan-Loader*
  git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'
}

build() {
  cd "${srcdir}"/Vulkan-Loader*

  msg "Cleaning source code tree..."
  git reset --hard HEAD
  git clean -xdf

  mkdir build64
  mkdir build32

  cd "${srcdir}"/Vulkan-Loader*/build64
  cmake -DCMAKE_INSTALL_PREFIX=/usr \
    -DVULKAN_HEADERS_INSTALL_DIR=/usr \
    -DCMAKE_INSTALL_LIBDIR=lib \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DCMAKE_INSTALL_DATADIR=/share \
    -DCMAKE_SKIP_RPATH=True \
    -DBUILD_TESTS=Off \
    -DBUILD_WSI_XCB_SUPPORT=On \
    -DBUILD_WSI_XLIB_SUPPORT=On \
    -DBUILD_WSI_WAYLAND_SUPPORT=On \
    -DCMAKE_BUILD_TYPE=Release \
    ..
  make

  export ASFLAGS=--32
  export CFLAGS=-m32
  export CXXFLAGS=-m32
  export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"

  cd "${srcdir}"/Vulkan-Loader*/build32
  cmake -DCMAKE_INSTALL_PREFIX=/usr \
    -DVULKAN_HEADERS_INSTALL_DIR=/usr \
    -DCMAKE_INSTALL_SYSCONFDIR=/etc \
    -DCMAKE_INSTALL_LIBDIR=lib32 \
    -DCMAKE_INSTALL_DATADIR=/share \
    -DCMAKE_SKIP_RPATH=True \
    -DBUILD_TESTS=Off \
    -DBUILD_WSI_XCB_SUPPORT=On \
    -DBUILD_WSI_XLIB_SUPPORT=On \
    -DBUILD_WSI_WAYLAND_SUPPORT=On \
    -DCMAKE_BUILD_TYPE=Release \
    ..
  make
}

package_vulkan-icd-loader-git() {
  provides=("vulkan-icd-loader=$pkgver-$pkgrel")
  conflicts=('vulkan-icd-loader')
  cd "${srcdir}"/Vulkan-Loader*/build64

  make DESTDIR="${pkgdir}" install

  install -dm755 ${pkgdir}/usr/share/licenses/${pkgname}
  install -m644 ../LICENSE.txt "${pkgdir}"/usr/share/licenses/${pkgname}/
}

package_lib32-vulkan-icd-loader-git() {
  provides=("lib32-vulkan-icd-loader=$pkgver-$pkgrel")
  conflicts=('lib32-vulkan-icd-loader')
  cd "${srcdir}"/Vulkan-Loader*/build32

  make DESTDIR="${pkgdir}" install

  install -dm755 ${pkgdir}/usr/share/licenses/${pkgname}
  install -m644 ../LICENSE.txt "${pkgdir}"/usr/share/licenses/${pkgname}/
}

function exit_cleanup {

if [ "$_NUKR" == "true" ]; then
  # Sanitization
  rm -rf "$srcdir"/Vulkan-*
  msg2 'exit cleanup done'
fi

  remove_deps
}

trap exit_cleanup EXIT
