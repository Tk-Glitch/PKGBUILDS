# Maintainer:  Tk-Glitch <ti3nou@gmail.com>

_pkgbase=gamescope
pkgname=${_pkgbase}-git
pkgver=3.5.1.r13.gbeb29e2
pkgrel=1
_where=$PWD # track basedir as different Arch based distros are moving srcdir around
source "$_where"/customization.cfg

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values.\n"
fi

arch=('x86_64')
url="https://github.com/Plagman/gamescope"
license=('BSD 2-Clause "Simplified" License')
makedepends=('git' 'meson' 'ninja' 'cmake' 'pixman' 'pkgconf' 'vulkan-headers')
pkgdesc="gamescope: the micro-compositor formerly known as steamcompmgr"
_depends_array="wayland opengl-driver xorg-server-xwayland libdrm libinput libxkbcommon libcap libxcb libpng glslang"
if [ "$_local_wlroots" != "true" ]; then
  _depends_array="${_depends_array} wlroots"
fi
depends=(${_depends_array})
conflicts=('gamescope')

# custom commit to pass to git
if [ -n "$_gamescope_commit" ]; then
  _gamescope_commit="#commit=${_gamescope_commit}"
fi

source=("git+https://github.com/Plagman/gamescope.git${_gamescope_commit}")
md5sums=('SKIP')
sha512sums=('SKIP')
options=('staticlibs')

pkgver() {
    cd ${_pkgbase}
    git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'
}

prepare() {
    if [  -d _build ]; then
        rm -rf _build
    fi
    mkdir _build
}

build() {
    cd ${_pkgbase}

    meson \
      --buildtype release \
      --prefix /usr \
      ${srcdir}/_build
}

package() {
     DESTDIR="$pkgdir" ninja -C _build install
     if [ "$_local_wlroots" != "true" ]; then
       provides=(gamescope=$pkgver)
       rm -rf "${pkgdir}"/usr/include
       rm -rf "${pkgdir}"/usr/lib/libwlroots*
       rm -f "${pkgdir}"/usr/lib/pkgconfig/wlroots.pc
     else
       provides=("gamescope=$pkgver" "wlroots")
       conflicts=("wlroots")
       warning "This configuration will conflict with wlroots package. If that's not what you want, please check your customization.cfg or external config"
     fi

     install -Dt "${pkgdir}/usr/share/licenses/${pkgname}" -m644 "${srcdir}/${_pkgbase}/LICENSE"
}
