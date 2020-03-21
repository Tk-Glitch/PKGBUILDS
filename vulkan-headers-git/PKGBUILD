# Based on Arch's PKGBUILD by Laurent Carlier <lordheavym@gmail.com>
# Modified by Tk-Glitch <ti3nou at gmail dot com> to target git instead of tagged releases

pkgname=vulkan-headers-tkg-git
pkgver=1.2.135.r0.gfb7f9c9
pkgrel=1
pkgdesc="Vulkan header files"
arch=(any)
url="https://www.khronos.org/vulkan/"
license=('APACHE')
makedepends=(cmake git)
provides=("vulkan-hpp=${pkgver}" "vulkan-headers=${pkgver}")
conflicts=("vulkan-headers")
groups=(vulkan-devel)
source=("${pkgname}::git+https://github.com/KhronosGroup/Vulkan-Headers.git")
sha256sums=('SKIP')

pkgver() {
  cd "${pkgname}"

  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//;s/\.rc/rc/;s/^wine\.//'
}

build() {
  cd "${pkgname}"

  rm -rf build ; mkdir build ; cd build
  cmake -DCMAKE_INSTALL_PREFIX=/usr \
    -DCMAKE_BUILD_TYPE=Release \
    ..
  make
}

package() {
  cd "${pkgname}"/build

  make DESTDIR="${pkgdir}" install
}
