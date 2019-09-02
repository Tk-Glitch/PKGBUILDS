#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

# This script creates portable x86_64 GCC builds - You'll need basic development tools installed (base-devel, build-essential or similar for your distro as well as schedtool)
# It is bound to the libc/binutils version of the host system, so cross-distro portability only works for a given libc/binutils version combo

cat << 'EOM'
       .---.`               `.---.
    `/syhhhyso-           -osyhhhys/`
   .syNMdhNNhss/``.---.``/sshNNhdMNys.
   +sdMh.`+MNsssssssssssssssNM+`.hMds+
   :syNNdhNNhssssssssssssssshNNhdNNys:
    /ssyhhhysssssssssssssssssyhhhyss/
    .ossssssssssssssssssssssssssssso.     (Mostly)
   :sssssssssssssssssssssssssssssssss:    Portable
  /sssssssssssssssssssssssssssssssssss/        GCC
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

  _nowhere=$PWD

  source ${_nowhere}/mostlyportable-gcc.cfg

  user_patcher() {
  	# To patch the user because all your base are belong to us
  	local _patches=("$_nowhere"/*."${_userpatch_ext}revert")
  	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
  	  if [ "$_user_patches_no_confirm" != "true" ]; then
  	    echo -e "Found ${#_patches[@]} 'to revert' userpatches for ${_userpatch_target}:"
  	    printf '%s\n' "${_patches[@]}"
  	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
  	  fi
  	  if [ "$_CONDITION" == "y" ] || [ "$_user_patches_no_confirm" == "true" ]; then
  	    for _f in "${_patches[@]}"; do
  	      if [ -e "${_f}" ]; then
  	        echo -e "######################################################"
  	        echo -e ""
  	        echo -e "Reverting your own ${_userpatch_target} patch ${_f}"
  	        echo -e ""
  	        echo -e "######################################################"
  	        patch -Np1 -R < "${_f}"
  	        echo "Reverted your own patch ${_f}" >> "$_nowhere"/last_build_config.log
  	      fi
  	    done
  	  fi
  	fi

  	_patches=("$_nowhere"/*."${_userpatch_ext}patch")
  	if [ ${#_patches[@]} -ge 2 ] || [ -e "${_patches}" ]; then
  	  if [ "$_user_patches_no_confirm" != "true" ]; then
  	    echo -e "Found ${#_patches[@]} userpatches for ${_userpatch_target}:"
  	    printf '%s\n' "${_patches[@]}"
  	    read -rp "Do you want to install it/them? - Be careful with that ;)"$'\n> N/y : ' _CONDITION;
  	  fi
  	  if [ "$_CONDITION" == "y" ] || [ "$_user_patches_no_confirm" == "true" ]; then
  	    for _f in "${_patches[@]}"; do
  	      if [ -e "${_f}" ]; then
  	        echo -e "######################################################"
  	        echo -e ""
  	        echo -e "Applying your own ${_userpatch_target} patch ${_f}"
  	        echo -e ""
  	        echo -e "######################################################"
  	        patch -Np1 < "${_f}"
  	        echo "Applied your own patch ${_f}" >> "$_nowhere"/last_build_config.log
  	      fi
  	    done
  	  fi
  	fi
  }

  _exit_cleanup() {
    cd ${_nowhere}/build && find . -maxdepth 1 -mindepth 1 -type d -exec rm -rf '{}' \;
    echo -e "\n## Exit cleanup complete"
  }

  trap _exit_cleanup EXIT

  _makeandinstall() {
    schedtool -B -n 1 -e ionice -n 1 make -j$(nproc) && make install
  }

  _init() {
    mkdir -p ${_nowhere}/build

    # gcc repo
    if [ "$_use_gcc_git" == "true" ]; then
      git clone --mirror ${_gcc_git} gcc || true
      cd ${_nowhere}/gcc
      if [[ "${_gcc_git}" != "$(git config --get remote.origin.url)" ]] ; then
        echo "gcc is not a clone of ${_gcc_git}. Please delete gcc dir and try again."
        exit 1
      fi
      git fetch --all -p
      rm -rf ${_nowhere}/build/gcc && git clone ${_nowhere}/gcc ${_nowhere}/build/gcc
      cd ${_nowhere}/build/gcc
      git checkout --force --no-track -B safezone origin/HEAD
      if [ -n "${_gcc_version}" ]; then
        git checkout "${_gcc_version}"
      else
        _gcc_version=$(git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//')
      fi
      git reset --hard HEAD
      git clean -xdf
      _gcc_version="git-${_gcc_version}"
    else
      cd ${_nowhere}/build
      wget -c ftp://ftp.gnu.org/gnu/gcc/gcc-${_gcc_version}/gcc-${_gcc_version}.tar.xz && chmod a+x gcc-${_gcc_version}.tar.* && tar -xvJf gcc-${_gcc_version}.tar.* >/dev/null 2>&1
      mv gcc-${_gcc_version} gcc
    fi

    cd ${_nowhere}/build

    # Download needed toolset
    if [ ! -e gmp-${_gmp}.tar.xz ]; then
      wget -c ftp://ftp.gnu.org/gnu/gmp/gmp-${_gmp}.tar.xz
    fi
    if [ ! -e mpfr-${_mpfr}.tar.xz ]; then
      wget -c ftp://ftp.gnu.org/gnu/mpfr/mpfr-${_mpfr}.tar.xz
    fi
    if [ ! -e mpc-${_mpc}.tar.gz ]; then
      wget -c ftp://ftp.gnu.org/gnu/mpc/mpc-${_mpc}.tar.gz
    fi
    if [ ! -e libelf-${_libelf}.tar.gz ]; then
      wget -c https://fossies.org/linux/misc/old/libelf-${_libelf}.tar.gz
    fi
    if [ ! -e isl-${_isl}.tar.gz ]; then
      wget -c http://isl.gforge.inria.fr/isl-${_isl}.tar.gz
    fi

    chmod a+x gmp-${_gmp}.tar.* && tar -xvJf gmp-${_gmp}.tar.* >/dev/null 2>&1
    chmod a+x mpfr-${_mpfr}.tar.* && tar -xvJf mpfr-${_mpfr}.tar.* >/dev/null 2>&1
    chmod a+x mpc-${_mpc}.tar.* && tar -xvf mpc-${_mpc}.tar.* >/dev/null 2>&1
    chmod a+x libelf-${_libelf}.tar.* && tar -xvf libelf-${_libelf}.tar.* >/dev/null 2>&1
    chmod a+x isl-${_isl}.tar.* && tar -xvf isl-${_isl}.tar.* >/dev/null 2>&1

    # user patches
    _userpatch_target="gcc"
    _userpatch_ext="gcc"
    cd ${_nowhere}/build/gcc
    user_patcher
  }

  _build() {
    _commonconfig="--disable-shared --enable-static --prefix=${_dstdir}"

    # gmp
    cd ${_nowhere}/build/gmp-${_gmp}
    ./configure \
      ${_commonconfig}
    _makeandinstall || exit 1

    # mpfr
    cd ${_nowhere}/build/mpfr-${_mpfr}
    ./configure \
      --with-gmp=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    # mpc
    cd ${_nowhere}/build/mpc-${_mpc}
    ./configure \
      --with-gmp=${_dstdir} \
      --with-mpfr=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    # libelf
    cd ${_nowhere}/build/libelf-${_libelf}
    ./configure \
      ${_commonconfig}
    _makeandinstall || exit 1

    # isl
    cd ${_nowhere}/build/isl-${_isl}
    ./configure \
      ${_commonconfig}
    _makeandinstall || exit 1

    # gcc
    mkdir -p ${_nowhere}/build/gcc_build && cd ${_nowhere}/build/gcc_build
    ../gcc/configure \
      --with-pkgversion='TkG-mostlyportable' \
      --disable-shared \
      --disable-bootstrap \
      --enable-languages=c,c++,lto \
      --with-gcc-major-version-only \
      --enable-linker-build-id \
      --disable-libstdcxx-pch \
      --without-included-gettext \
      --enable-libgomp \
      --enable-lto \
      --enable-threads=posix \
      --enable-tls \
      --enable-nls \
      --enable-clocale=gnu \
      --enable-libstdcxx-time=yes \
      --with-default-libstdcxx-abi=new \
      --enable-gnu-unique-object \
      --disable-vtable-verify \
      --enable-plugin \
      --enable-default-pie \
      --with-target-system-zlib=auto \
      --with-system-zlib \
      --enable-multiarch \
      --with-arch-32=i686 \
      --with-abi=m64 \
      --with-multilib-list=m32,m64 \
      --enable-multilib \
      --disable-werror \
      --enable-checking=release \
      --with-fpmath=sse \
      --prefix=${_dstdir} \
      --with-tune=generic \
      --without-cuda-driver \
      --with-isl \
      --with-gmp=${_dstdir} \
      --with-mpfr=${_dstdir} \
      --with-mpc=${_dstdir} \
      --with-libelf=${_dstdir} \
      --enable-offload-targets=nvptx-none,hsa \
      --build=x86_64-linux-gnu \
      --host=x86_64-linux-gnu \
      --target=x86_64-linux-gnu
      #--enable-libstdcxx-debug
    _makeandinstall || exit 1

    mv ${_dstdir} ${_nowhere}/gcc-mostlyportable-${_gcc_version} && echo -e "\n##\n## Your portable gcc build can be found at ${_nowhere}/gcc-mostlyportable-${_gcc_version} and can be moved anywhere.\n## Set CC to the bin/tool path to use to build your program (example: CC=${_nowhere}/gcc-mostlyportable-${_gcc_version}/bin/gcc).\n##"
  }

  set -e

  _init && _build
