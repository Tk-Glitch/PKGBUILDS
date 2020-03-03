# Created by: Tk-Glitch <ti3nou at gmail dot com>

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

pkgname=('vkd3d-tkg-git' 'lib32-vkd3d-tkg-git')
pkgver=1.1.r689.ga59f198
pkgrel=1

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values.\n"
fi

if [ -n "$_vkd3d_source" ] && [ "$_vkd3d_source" != 'git://source.winehq.org/git/vkd3d' ]; then
  _vkd3dsrcdir=$( sed 's|/|-|g' <<< $(sed 's|.*://.[^/]*/||g' <<< $_vkd3d_source))
else
  _vkd3dsrcdir='vkd3d'
  _vkd3d_source='git://source.winehq.org/git/vkd3d'
fi

# custom vkd3d commit to pass to git
if [ -n "$_vkd3d_commit" ]; then
  _vkd3d_commit="#commit=${_vkd3d_commit}"
fi

pkgdesc='Wine d3d12 to vulkan translation lib, git version'
url='https://source.winehq.org/git/vkd3d.git'
arch=('x86_64')
license=('LGPL')
depends=(
    'spirv-tools' 'lib32-spirv-tools'
)

makedepends=('git' 'autoconf' 'ncurses' 'bison' 'perl' 'fontforge' 'flex'
    'gcc>=4.5.0-2' 'spirv-headers-git'
    'vulkan-headers' 'vulkan-icd-loader'
    'lib32-vulkan-icd-loader'
)

optdepends=('schedtool')

source=("$_vkd3dsrcdir"::"git+${_vkd3d_source}.git${_vkd3d_commit}"
)

makedepends=(${makedepends[@]} ${depends[@]})

function exit_cleanup {
  # Remove temporarily copied patches
  rm -rf "$_where"/src/*

  # Community patches removal
  for _p in ${_community_patches[@]}; do
    rm -f "$_where"/$_p
  done

  remove_deps

  msg2 "Cleanup done"
}

user_patcher() {
	# To patch the user because all your base are belong to us
	local _patches=("$_where"/*."${_userpatch_ext}revert")
	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
	  if [ "$_user_patches_no_confirm" != "true" ]; then
	    msg2 "Found ${#_patches[@]} 'to revert' userpatches for ${_userpatch_target}:"
	    printf '%s\n' "${_patches[@]}"
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
	    printf '%s\n' "${_patches[@]}"
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

pkgver() {
	# retrieve current version
	cd "${srcdir}/${_vkd3dsrcdir}"
	local _vkd3dVer="$(git describe --always --long | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^//;s/\.rc/rc/')"

	# version string
	printf '%s' "${_vkd3dVer#vkd3d.}"
}

prepare() {
	# Cleanups
	rm -fv $_where/last_build_config.log
	cd "${srcdir}/${_vkd3dsrcdir}"

	# Community patches
	if [ -n "$_community_patches" ]; then
	  _community_patches=($_community_patches)
	  for _p in ${_community_patches[@]}; do
	    ln -s "$_where"/../community-patches/vkd3d-git/$_p "$_where"/
	  done
	fi

	# vkd3d user patches
	_userpatch_target="vkd3d"
	_userpatch_ext="myvkd3d"
	user_patcher

	# Community patches removal
	for _p in ${_community_patches[@]}; do
	  rm -f "$_where"/$_p
	done

	# create new build dirs
	mkdir -p "${srcdir}"/vkd3d-tkg-git
	mkdir -p "${srcdir}"/lib32-vkd3d-tkg-git
	cd "$_where"
}

build() {
	cd "${srcdir}"/${_vkd3dsrcdir}
	./autogen.sh

	export CC='gcc -m32'
	export CXX='g++ -m32'
	export PKG_CONFIG_PATH='/usr/lib32/pkgconfig'

	cd  "${srcdir}"/lib32-vkd3d-tkg-git
	../${_vkd3dsrcdir}/configure \
	  --prefix=/usr \
	  --libdir=/usr/lib32 \
	  --with-spirv-tools

	# make using all available threads
	schedtool -B -n 1 -e ionice -n 1 make -j$(nproc) -C "${srcdir}"/lib32-vkd3d-tkg-git || make -j$(nproc) -C "${srcdir}"/lib32-vkd3d-tkg-git

	export CC='gcc -m64'
	export CXX='g++ -m64'
	export PKG_CONFIG_PATH='/usr/lib/pkgconfig'

	cd  "${srcdir}"/vkd3d-tkg-git
	../${_vkd3dsrcdir}/configure \
	  --prefix=/usr \
	  --libdir=/usr/lib \
	  --with-spirv-tools

	# make using all available threads
	schedtool -B -n 1 -e ionice -n 1 make -j$(nproc) -C "${srcdir}"/vkd3d-tkg-git || make -j$(nproc) -C "${srcdir}"/vkd3d-tkg-git
}

package_vkd3d-tkg-git() {
  provides=("vkd3d=$pkgver")
  conflicts=("vkd3d")

	msg2 'Packaging vkd3d 64...'
	cd  "${srcdir}"/"${pkgname}"
	make -C "${srcdir}"/"${pkgname}" DESTDIR="${pkgdir}" install
}

package_lib32-vkd3d-tkg-git() {
  provides=("lib32-vkd3d=$pkgver")
  conflicts=("lib32-vkd3d")

	msg2 'Packaging vkd3d 32...'
	cd  "${srcdir}"/"${pkgname}"
	make -C "${srcdir}"/"${pkgname}" DESTDIR="${pkgdir}" install

	rm -rf ${pkgdir}/usr/include
}
md5sums=('SKIP')

trap exit_cleanup EXIT
