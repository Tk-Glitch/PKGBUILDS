# Originally based on AUR pkgbuilds from Lone_Wolf <lonewolf at xs4all dot nl> - https://aur.archlinux.org/packages/mesa-git/ - https://aur.archlinux.org/packages/lib32-mesa-git/
# Glitched by: Tk-Glitch <ti3nou at gmail dot com>

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

_where=$PWD # track basedir as different Arch based distros are moving srcdir around
source "$_where"/customization.cfg

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values.\n"
fi

pkgname=('mesa-tkg-git')
if [ "$_lib32" == "true" ]; then
  pkgname+=('lib32-mesa-tkg-git')
fi

# custom mesa commit to pass to git
if [ -n "$_mesa_commit" ]; then
  _mesa_commit="#commit=${_mesa_commit}"
fi

pkgdesc="an open-source implementation of the OpenGL specification, git version"
pkgver=20.1.0_devel.121640.e6097375269
pkgrel=1
arch=('x86_64')
makedepends=('git' 'python-mako' 'xorgproto' 'libxml2' 'libx11' 'libvdpau' 'libva' 'elfutils'
             'libomxil-bellagio' 'libxrandr' 'ocl-icd' 'vulkan-icd-loader' 'libgcrypt'  'wayland'
             'wayland-protocols' 'meson' 'ninja' 'libdrm' 'xorgproto' 'libdrm' 'libxshmfence' 
             'libxxf86vm' 'libxdamage' 'libclc' 'libglvnd' 'libunwind' 'lm_sensors' 'libxrandr'
             'valgrind' 'glslang')

if [ "$_lib32" == "true" ]; then
  makedepends+=('lib32-libxml2' 'lib32-libx11' 'lib32-libdrm' 'lib32-libxshmfence' 'lib32-libxxf86vm'
                'lib32-gcc-libs' 'lib32-libvdpau' 'lib32-libelf' 'lib32-libgcrypt' 'lib32-systemd'
                'lib32-lm_sensors' 'lib32-libxdamage' 'gcc-multilib' 'lib32-libunwind' 'lib32-libglvnd'
                'lib32-libva' 'lib32-wayland' 'lib32-libvdpau' 'lib32-libxrandr' 'lib32-expat'
                'lib32-vulkan-icd-loader')
fi

depends=('libdrm' 'libxxf86vm' 'libxdamage' 'libxshmfence' 'libelf' 'libomxil-bellagio' 'libunwind'
         'libglvnd' 'wayland' 'lm_sensors' 'libclc' 'glslang')
optdepends=('opengl-man-pages: for the OpenGL API man pages')

# Use ccache if available
if pacman -Qq ccache &> /dev/null; then
  msg2 "ccache was found and will be used\n"
  _makepkg_options+=('ccache')
else
  msg2 "ccache was not found and will not be used\n"
fi

options=(${_makepkg_options[@]})

url="https://www.mesa3d.org"
license=('custom')

_sourceurl="mesa::git://anongit.freedesktop.org/mesa/mesa${_mesa_commit}"
_mesa_srcdir="mesa"

source=("$_sourceurl"
        'LICENSE'
        'llvm32.native'
)
md5sums=('SKIP'
         '5c65a0fe315dd347e09b1f2826a1df5a'
         '6b4a19068a323d7f90a3d3cd315ed1f9')
sha512sums=('SKIP'
            '25da77914dded10c1f432ebcbf29941124138824ceecaf1367b3deedafaecabc082d463abcfa3d15abff59f177491472b505bcb5ba0c4a51bb6b93b4721a23c2'
            'c7dbb390ebde291c517a854fcbe5166c24e95206f768cc9458ca896b2253aabd6df12a7becf831998721b2d622d0c02afdd8d519e77dea8e1d6807b35f0166fe')

function exit_cleanup {
  # Remove temporarily copied patches
  sleep 1 # Workarounds a race condition with ninja
  rm -rf "$_where"/*.mymesa*
  rm -f "$_where"/frogminer

  remove_deps
  
  msg2 "Cleanup done"
}

user_patcher() {
	# To patch the user because all your base are belong to us
	local _patches=("$_where"/*."${_userpatch_ext}revert")
	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
	  if [ "$_user_patches_no_confirm" != "true" ]; then
	    msg2 "Found ${#_patches[@]} 'to revert' userpatches for ${_userpatch_target}:"
	    printf '%s\n' "${_patches[@]//*\//}"
	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
	  fi
	  if [ "$_CONDITION" == "y" ] || [ "$_user_patches_no_confirm" == "true" ]; then
	    for _f in "${_patches[@]}"; do
	      if [ -e "${_f}" ]; then
	        msg2 "######################################################"
	        msg2 ""
	        msg2 "Reverting your own ${_userpatch_target} patch ${_f}"
	        msg2 ""
	        msg2 "######################################################"
	        patch -Np1 -R < "${_f}"
	        echo "Reverted your own patch ${_f}" >> "$_where"/last_build_config.log
	      fi
	    done
	  fi
	fi

	_patches=("$_where"/*."${_userpatch_ext}patch")
	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
	  if [ "$_user_patches_no_confirm" != "true" ]; then
	    msg2 "Found ${#_patches[@]} userpatches for ${_userpatch_target}:"
	    printf '%s\n' "${_patches[@]//*\//}"
	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
	  fi
	  if [ "$_CONDITION" == "y" ] || [ "$_user_patches_no_confirm" == "true" ]; then
	    for _f in "${_patches[@]}"; do
	      if [ -e "${_f}" ]; then
	        msg2 "######################################################"
	        msg2 ""
	        msg2 "Applying your own ${_userpatch_target} patch ${_f}"
	        msg2 ""
	        msg2 "######################################################"
	        patch -Np1 < "${_f}"
	        echo "Applied your own patch ${_f}" >> "$_where"/last_build_config.log
	      fi
	    done
	  fi
	fi
}

# NINJAFLAGS is an env var used to pass commandline options to ninja
# NOTE: It's your responbility to validate the value of $NINJAFLAGS. If unsure, don't set it.

# MESA_WHICH_LLVM is an environment variable used to determine which llvm package tree is used to build mesa-git against.
# Adding a line to ~/.bashrc  that sets this value is the simplest way to ensure a specific choice.
#
# 1: llvm-minimal-git (aur) preferred value
# 2: AUR llvm-git
# 3: llvm-git from LordHeavy unofficial repo 
# 4  llvm (stable from extra) Default value
# 

if [[ ! $MESA_WHICH_LLVM ]] && [ ! -e "$_where"/frogminer ]; then
  plain "Which llvm package tree do you want to use to build mesa-tkg-git against ?"
  read -rp "`echo $'     1.llvm-minimal-git (AUR)\n     2.llvm-git (AUR)\n     3.llvm-git from LordHeavy unofficial repo\n   > 4.llvm (default)\n    choice[1-4?]: '`" MESA_WHICH_LLVM;
  touch "$_where"/frogminer
fi
# double dip
if [ -z "$MESA_WHICH_LLVM" ] || [[ $MESA_WHICH_LLVM -le 0 ]] || [[ $MESA_WHICH_LLVM -ge 5 ]]; then
  MESA_WHICH_LLVM=4
fi

case $MESA_WHICH_LLVM in
    1)
        # aur llvm-minimal-git
        makedepends+=('llvm-minimal-git')
        depends+=('llvm-libs-minimal-git')
        if [ "$_lib32" == "true" ]; then
          makedepends+=('lib32-llvm-minimal-git')
          depends+=('lib32-llvm-libs-minimal-git')
        fi
        msg2 "Using llvm-minimal-git (AUR)"
        echo "Using llvm-minimal-git (AUR)" >> "$_where"/last_build_config.log
        ;;
    2)
        # aur llvm-git
        # depending on aur-llvm-* to avoid mixup with LH llvm-git
        makedepends+=('aur-llvm-git')
        depends+=('aur-llvm-libs-git')
        if [ "$_lib32" == "true" ]; then
          makedepends+=('aur-lib32-llvm-git')
          depends+=('aur-lib32-llvm-libs-git')
        fi
        msg2 "Using llvm-git (AUR)"
        echo "Using llvm-git (AUR)" >> "$_where"/last_build_config.log
        ;;
    3)
        # mesa-git/llvm-git (lordheavy unofficial repo)
        makedepends+=('llvm-git' 'clang-git')
        depends+=('llvm-libs-git')
        if [ "$_lib32" == "true" ]; then
          makedepends+=('lib32-llvm-git')
          depends+=('lib32-llvm-libs-git')
        fi
        msg2 "Using llvm-git from LordHeavy unofficial repo"
        echo "Using llvm-git from LordHeavy unofficial repo" >> "$_where"/last_build_config.log
        ;;
    4)
        # extra/llvm
        makedepends+=('llvm>=8.0.0' 'clang>=8.0.0')
        depends+=('llvm-libs>=8.0.0')
        if [ "$_lib32" == "true" ]; then
          makedepends+=('lib32-llvm>=8.0.0')
          depends+=('lib32-llvm-libs>=8.0.0')
        fi
        msg2 "Using llvm (default)"
        echo "Using llvm (default)" >> "$_where"/last_build_config.log
        ;;
    *)
esac

pkgver() {
    cd $_mesa_srcdir
    read -r _ver <VERSION
    echo ${_ver/-/_}.$(git rev-list --count HEAD).$(git rev-parse --short HEAD)
}

prepare() {
    # cleanups
    cd "$srcdir"/$_mesa_srcdir
    git reset --hard HEAD
    git clean -xdf
    msg2 "Tree cleaned"

    cp "$_where"/mesa-userpatches/*.mymesa* "$_where" || true # copy userpatches inside the PKGBUILD's dir

    if [ -n "$_mesa_prs" ]; then
      for _pr in ${_mesa_prs[@]}; do
        wget -O "$_where"/"$_pr".mymesapatch https://gitlab.freedesktop.org/mesa/mesa/merge_requests/"$_pr".diff
      done
    fi

    # Community patches
    if [ -n "$_community_patches" ]; then
      _community_patches=($_community_patches)
      for _p in ${_community_patches[@]}; do
        ln -s "$_where"/../community-patches/mesa-git/$_p "$_where"/
      done
    fi

    # mesa user patches
    if [ "$_user_patches" == "true" ]; then
      _userpatch_target="mesa"
      _userpatch_ext="mymesa"
      echo -e "# Last ${pkgname} ${pkgver} configuration - $(date) :\n" > "$_where"/last_build_config.log
      echo -e "DRI drivers: ${_dri_drivers}" >> "$_where"/last_build_config.log
      echo -e "Gallium drivers: ${_gallium_drivers}" >> "$_where"/last_build_config.log
      echo -e "Vulkan drivers: ${_vulkan_drivers}\n" >> "$_where"/last_build_config.log
      user_patcher
    fi

    # Community/prs patches removal
    for _p in ${_community_patches[@]}; do
      rm -f "$_where"/$_p
    done
    for _pr in ${_mesa_prs[@]}; do
      rm -f "$_where"/$_pr.mymesapatch
    done

    cd "$srcdir"

    # although removing _build folder in build() function feels more natural,
    # that interferes with the spirit of makepkg --noextract
    if [  -d _build64 ]; then
        rm -rf _build64
    fi
    if [  -d _build32 ]; then
        rm -rf _build32
    fi
    cd "$_where"
}

build () {
    if [ -n "$_custom_opt_flags" ]; then
      export CFLAGS="${CFLAGS} ${_custom_opt_flags}"
      export CPPFLAGS="${CPPFLAGS} ${_custom_opt_flags}"
      export CXXFLAGS="${CXXFLAGS} ${_custom_opt_flags}"
    fi
    if [ "$_no_lto" == "true" ]; then
      export _no_lto="-D b_lto=false"
    else
      export _no_lto=""
    fi

    export CC="gcc"
    export CXX="g++"

    arch-meson $_mesa_srcdir _build64 \
       -D b_ndebug=true \
       -D platforms=x11,wayland,drm,surfaceless \
       -D dri-drivers=${_dri_drivers} \
       -D gallium-drivers=${_gallium_drivers} \
       -D vulkan-drivers=${_vulkan_drivers} \
       -D vulkan-overlay-layer=true \
       -D swr-arches=avx,avx2 \
       -D dri3=true \
       -D egl=true \
       -D gallium-extra-hud=true \
       -D gallium-nine=true \
       -D gallium-omx=bellagio \
       -D gallium-opencl=icd \
       -D gallium-va=true \
       -D gallium-vdpau=true \
       -D gallium-xa=true \
       -D gallium-xvmc=false \
       -D gbm=true \
       -D gles1=false \
       -D gles2=true \
       -D glvnd=true \
       -D glx=dri \
       -D libunwind=true \
       -D llvm=true \
       -D lmsensors=true \
       -D osmesa=gallium \
       -D shared-glapi=true \
       -D opengl=true \
       -D valgrind=true $_no_lto
       
    meson configure _build64
    ninja  $NINJAFLAGS -C _build64

    if [ "$_localglesv2pc" == "true" ]; then
      echo -e "prefix=/usr\nlibdir=\${prefix}/lib\nincludedir=\${prefix}/include\n\nName: glesv2\nDescription: Mesa OpenGL ES 2.0 library\nVersion: ${pkgver}\nLibs: -L\${libdir} -lGLESv2\nLibs.private: -lpthread -pthread -lm -ldl\nCflags: -I\${includedir}" > "$srcdir"/_build64/glesv2.pc
    fi
    if [ "$_localeglpc" == "true" ]; then
      echo -e "prefix=/usr\nlibdir=\${prefix}/lib\nincludedir=\${prefix}/include\n\nName: egl\nDescription: Mesa EGL Library\nVersion: ${pkgver}\nRequires.private: x11, xext, xdamage >=  1.1, xfixes, x11-xcb, xcb, xcb-glx >=  1.8.1, xcb-dri2 >=  1.8, xxf86vm, libdrm >=  2.4.75\nLibs: -L\${libdir} -lEGL\nLibs.private: -lpthread -pthread -lm -ldl\nCflags: -I\${includedir}" > "$srcdir"/_build64/egl.pc
    fi

    if [ "$_lib32" == "true" ]; then
      cd "$srcdir"
      export CC="gcc -m32"
      export CXX="g++ -m32"
      export PKG_CONFIG=/usr/bin/i686-pc-linux-gnu-pkg-config

      arch-meson $_mesa_srcdir _build32 \
          --native-file llvm32.native \
          --libdir=/usr/lib32 \
          -D b_ndebug=true \
          -D platforms=x11,wayland,drm,surfaceless \
          -D dri-drivers=${_dri_drivers} \
          -D gallium-drivers=${_gallium_drivers} \
          -D vulkan-drivers=${_vulkan_drivers} \
          -D swr-arches=avx,avx2 \
          -D dri3=true \
          -D egl=true \
          -D gallium-extra-hud=true \
          -D gallium-nine=true \
          -D gallium-omx=disabled \
          -D gallium-opencl=disabled \
          -D gallium-va=true \
          -D gallium-vdpau=true \
          -D gallium-xa=true \
          -D gallium-xvmc=false \
          -D gbm=true \
          -D gles1=false \
          -D gles2=true \
          -D glvnd=true \
          -D glx=dri \
          -D libunwind=false \
          -D llvm=true \
          -D lmsensors=true \
          -D osmesa=gallium \
          -D shared-glapi=true \
          -D valgrind=false $_no_lto
       
      meson configure _build32
      ninja $NINJAFLAGS -C _build32

      if [ "$_localglesv2pc" == "true" ]; then
        echo -e "prefix=/usr\nlibdir=\${prefix}/lib32\nincludedir=\${prefix}/include\n\nName: glesv2\nDescription: Mesa OpenGL ES 2.0 library\nVersion: ${pkgver}\nLibs: -L\${libdir} -lGLESv2\nLibs.private: -lpthread -pthread -lm -ldl\nCflags: -I\${includedir}" > "$srcdir"/_build32/glesv2.pc
      fi
      if [ "$_localeglpc" == "true" ]; then
        echo -e "prefix=/usr\nlibdir=\${prefix}/lib32\nincludedir=\${prefix}/include\n\nName: egl\nDescription: Mesa EGL Library\nVersion: ${pkgver}\nRequires.private: x11, xext, xdamage >=  1.1, xfixes, x11-xcb, xcb, xcb-glx >=  1.8.1, xcb-dri2 >=  1.8, xxf86vm, libdrm >=  2.4.75\nLibs: -L\${libdir} -lEGL\nLibs.private: -lpthread -pthread -lm -ldl\nCflags: -I\${includedir}" > "$srcdir"/_build32/egl.pc
      fi
    fi
}

package_mesa-tkg-git() {
  depends=('libdrm' 'wayland' 'libxxf86vm' 'libxdamage' 'libxshmfence' 'libelf'
           'libomxil-bellagio' 'libunwind' 'llvm-libs' 'lm_sensors' 'libglvnd'
           'expat' 'libclc' 'libx11')
  provides=(mesa=$pkgver-$pkgrel vulkan-intel=$pkgver-$pkgrel vulkan-radeon=$pkgver-$pkgrel vulkan-mesa-layer=$pkgver-$pkgrel mesa-vulkan-layer=$pkgver-$pkgrel libva-mesa-driver=$pkgver-$pkgrel mesa-vdpau=$pkgver-$pkgrel vulkan-driver opencl-mesa=$pkgver-$pkgrel opengl-driver opencl-driver ati-dri intel-dri nouveau-dri svga-dri mesa-dri mesa-libgl)
  conflicts=('mesa' 'opencl-mesa' 'vulkan-intel' 'vulkan-radeon' 'vulkan-mesa-layer' 'mesa-vulkan-layer' 'libva-mesa-driver' 'mesa-vdpau')

  DESTDIR="$pkgdir" ninja $NINJAFLAGS -C _build64 install

  # remove script file from /usr/bin
  # https://gitlab.freedesktop.org/mesa/mesa/issues/2230
  rm "${pkgdir}/usr/bin/mesa-overlay-control.py"

  # indirect rendering
  ln -s /usr/lib/libGLX_mesa.so.0 "${pkgdir}/usr/lib/libGLX_indirect.so.0"

  if [ "$_localglesv2pc" == "true" ]; then
    # bring back glesv2.pc
    install -m644 -Dt "$pkgdir"/usr/lib/pkgconfig "$srcdir"/_build64/glesv2.pc
  fi
  if [ "$_localeglpc" == "true" ]; then
    # bring back egl.pc
    install -m644 -Dt "$pkgdir"/usr/lib/pkgconfig "$srcdir"/_build64/egl.pc
  fi

  install -Dt "$pkgdir"/usr/share/licenses/$pkgname "$srcdir"/LICENSE
}

package_lib32-mesa-tkg-git() {
  depends=('lib32-libdrm' 'lib32-libxxf86vm' 'lib32-libxdamage' 'lib32-libxshmfence'
           'lib32-lm_sensors' 'lib32-libelf' 'lib32-llvm-libs' 'lib32-wayland'
           'lib32-libglvnd' 'lib32-libx11' 'mesa')
  provides=(lib32-mesa=$pkgver-$pkgrel lib32-vulkan-intel=$pkgver-$pkgrel lib32-vulkan-radeon=$pkgver-$pkgrel lib32-vulkan-mesa-layer=$pkgver-$pkgrel lib32-mesa-vulkan-layer=$pkgver-$pkgrel lib32-libva-mesa-driver=$pkgver-$pkgrel lib32-mesa-vdpau=$pkgver-$pkgrel lib32-opengl-driver lib32-ati-dri lib32-intel-dri lib32-nouveau-dri lib32-mesa-dri lib32-mesa-libgl)
  conflicts=('lib32-mesa' 'lib32-vulkan-intel' 'lib32-vulkan-radeon' 'lib32-vulkan-mesa-layer' 'lib32-mesa-vulkan-layer' 'lib32-libva-mesa-driver' 'lib32-mesa-vdpau')

  DESTDIR="$pkgdir" ninja $NINJAFLAGS -C _build32 install

  # remove files provided by mesa-git
  rm -rf "$pkgdir"/etc
  rm -rf "$pkgdir"/usr/include
  rm -rf "$pkgdir"/usr/share/glvnd/
  rm -rf "$pkgdir"/usr/share/drirc.d/
  rm -rf "$pkgdir"/usr/share/vulkan/explicit_layer.d/

  # indirect rendering
  ln -s /usr/lib32/libGLX_mesa.so.0 "${pkgdir}/usr/lib32/libGLX_indirect.so.0"

  if [ "$_localglesv2pc" == "true" ]; then
    # bring back glesv2.pc
    install -m644 -Dt "$pkgdir"/usr/lib32/pkgconfig "$srcdir"/_build32/glesv2.pc
  fi
  if [ "$_localeglpc" == "true" ]; then
    # bring back egl.pc
    install -m644 -Dt "$pkgdir"/usr/lib32/pkgconfig "$srcdir"/_build32/egl.pc
  fi

  install -Dt "$pkgdir"/usr/share/licenses/$pkgname "$srcdir"/LICENSE

  msg2 '#############################################################################################'
  msg2 ''
  msg2 '   Reminder: You can enable ACO at runtime with the `RADV_PERFTEST=aco` environment variable.'
  msg2 ''
  msg2 '#############################################################################################'
}
 
trap exit_cleanup EXIT
