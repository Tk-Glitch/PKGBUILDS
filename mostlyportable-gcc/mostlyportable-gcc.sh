#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

# This script creates portable x86_64 GCC/MingW builds - You'll need basic development tools installed (base-devel, build-essential or similar for your distro)
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
  /sssssssssssssssssssssssssssssssssss/        GCC/MingW
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

echo -e "What do you want to build?"
read -rp "`echo $'  > 1.GCC\n    2.MinGW-w64-GCC\nchoice[1-2?]: '`" _builtype;
if [ "$_builtype" == "2" ]; then
  source ${_nowhere}/mostlyportable-mingw.cfg && echo -e "\nUsing MinGW config\n"
  _mingwbuild="true"
else
  source ${_nowhere}/mostlyportable-gcc.cfg && echo -e "\nUsing GCC config\n"
fi

# Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
if [ -e "$_EXT_CONFIG_PATH" ]; then
  source "$_EXT_CONFIG_PATH" && echo -e "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values.\n"
fi

echo -e "# Last mostlyportable-gcc configuration - $(date) :\n" > "$_nowhere"/last_build_config.log
echo -e "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values.\n" >> "$_nowhere"/last_build_config.log

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
    rm -f ${_nowhere}/proton_binutils*.binutilspatch
    echo -e "\n## Exit cleanup complete"
  }

  trap _exit_cleanup EXIT

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
      echo -e "\nPlease be patient, it might take a while...\n"
      git fetch --all -p
      rm -rf ${_nowhere}/build/gcc && git clone ${_nowhere}/gcc ${_nowhere}/build/gcc
      cd ${_nowhere}/build/gcc
      git checkout --force --no-track -B safezone origin/HEAD
      if [ -n "${_gcc_version}" ]; then
        git checkout "${_gcc_version}"
      fi
      git reset --hard HEAD
      git clean -xdf
      _gcc_sub="-$(git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//;s/\//-/')"
    else
      cd ${_nowhere}/build
      wget -c ftp://ftp.gnu.org/gnu/gcc/gcc-${_gcc_version}/gcc-${_gcc_version}.tar.xz && chmod a+x gcc-${_gcc_version}.tar.* && tar -xvJf gcc-${_gcc_version}.tar.* >/dev/null 2>&1
      mv gcc-${_gcc_version} gcc
    fi

    # Set/update gcc version from source
    cd ${_nowhere}/build/gcc/gcc
    _gcc_version=$(cat BASE-VER)

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
    if [ ! -e isl-${_isl}.tar.gz ]; then
      wget -c http://isl.gforge.inria.fr/isl-${_isl}.tar.gz
    fi
    if [ ! -e binutils-${_binutils}.tar.gz ]; then
      wget -c https://ftp.gnu.org/gnu/binutils/binutils-${_binutils}.tar.gz
    fi

    # libelf
    if [ "$_enable_libelf" == "true" ]; then
      if [ ! -e elfutils-${_libelf}.tar.bz2 ]; then
        wget -c https://sourceware.org/elfutils/ftp/${_libelf}/elfutils-${_libelf}.tar.bz2
      fi
      _libelf_flag="--with-libelf=${_dstdir}"
      chmod a+x elfutils-${_libelf}.tar.* && tar -xvf elfutils-${_libelf}.tar.* >/dev/null 2>&1
    fi

    chmod a+x gmp-${_gmp}.tar.* && tar -xvJf gmp-${_gmp}.tar.* >/dev/null 2>&1
    chmod a+x mpfr-${_mpfr}.tar.* && tar -xvJf mpfr-${_mpfr}.tar.* >/dev/null 2>&1
    chmod a+x mpc-${_mpc}.tar.* && tar -xvf mpc-${_mpc}.tar.* >/dev/null 2>&1
    chmod a+x isl-${_isl}.tar.* && tar -xvf isl-${_isl}.tar.* >/dev/null 2>&1
    chmod a+x binutils-${_binutils}.tar.* && tar -xvf binutils-${_binutils}.tar.* >/dev/null 2>&1

    if [ "$_mingwbuild" == "true" ]; then
      if [ ! -e osl-${_osl}.tar.gz ]; then
        wget -c https://github.com/periscop/openscop/releases/download/${_osl}/osl-${_osl}.tar.gz
      fi
      if [ ! -e cloog-${_cloog}.tar.gz ]; then
        wget -c https://github.com/periscop/cloog/releases/download/cloog-${_cloog}/cloog-${_cloog}.tar.gz
      fi
      if [ ! -e mingw-w64-v${_mingw}.tar.bz2 ]; then
        wget -c https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v${_mingw}.tar.bz2
      fi

      chmod a+x osl-${_osl}.tar.* && tar -xvf osl-${_osl}.tar.* >/dev/null 2>&1
      chmod a+x cloog-${_cloog}.tar.* && tar -xvf cloog-${_cloog}.tar.* >/dev/null 2>&1
      chmod a+x mingw-w64-v${_mingw}.tar.* && tar -xvf mingw-w64-v${_mingw}.tar.* >/dev/null 2>&1

      if [[ "$_binutils" = 2.33* ]]; then
        wget -c -O proton_binutils1.binutilspatch https://raw.githubusercontent.com/ValveSoftware/Proton/3ad34a0b3f41bac60caea39c742de69cb0e50895/mingw-w64-patches/binutils-0001.patch
        wget -c -O proton_binutils2.binutilspatch https://raw.githubusercontent.com/ValveSoftware/Proton/3ad34a0b3f41bac60caea39c742de69cb0e50895/mingw-w64-patches/binutils-0002.patch
        if [ "$_valve_patches" == "true" ]; then
          mv ${_nowhere}/build/proton_binutils* ${_nowhere}/
        fi
      fi
      _path_hack="${_dstdir}/i686-w64-mingw32:${_dstdir}/x86_64-w64-mingw32:${_dstdir}/libexec:${_dstdir}/bin:${_dstdir}/lib:${_dstdir}/include:${PATH}"
    else
      # Make the process use our tools as they get built
      _path_hack="${_dstdir}/bin:${_dstdir}/lib:${_dstdir}/include:${PATH}"
    fi

    # user patches
    _userpatch_target="gcc"
    _userpatch_ext="gcc"
    cd ${_nowhere}/build/gcc
    user_patcher

    _userpatch_target="binutils"
    _userpatch_ext="binutils"
    cd ${_nowhere}/build/binutils-${_binutils}
    user_patcher

  }

  _makeandinstall() {
    PATH=${_path_hack} schedtool -B -n 1 -e ionice -n 1 make -j$(nproc) || PATH=${_path_hack} make -j$(nproc)
    PATH=${_path_hack} make install
  }

  _build() {
    # Clear dstdir before building
    echo -e "Cleaning up..."
    rm -rf ${_dstdir}/*

    _commonconfig="--disable-shared --enable-static"
    _targets="i686-w64-mingw32 x86_64-w64-mingw32"

    # libelf
    if [ "$_enable_libelf" == "true" ]; then
      cd ${_nowhere}/build/elfutils-${_libelf}
      PATH=${_path_hack} ./configure \
        --prefix=${_dstdir} \
        --program-prefix="eu-" \
        --enable-deterministic-archives \
        ${_commonconfig}
      _makeandinstall || exit 1
    fi

    # gmp
    cd ${_nowhere}/build/gmp-${_gmp}
    PATH=${_path_hack} ./configure \
      --prefix=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    # mpfr
    cd ${_nowhere}/build/mpfr-${_mpfr}
    PATH=${_path_hack} ./configure \
      --with-gmp=${_dstdir} \
      --prefix=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    # mpc
    cd ${_nowhere}/build/mpc-${_mpc}
    PATH=${_path_hack} ./configure \
      --with-gmp=${_dstdir} \
      --with-mpfr=${_dstdir} \
      --prefix=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    # isl
    cd ${_nowhere}/build/isl-${_isl}
    PATH=${_path_hack} ./configure \
      --prefix=${_dstdir} \
      ${_commonconfig}
    _makeandinstall || exit 1

    if [ "$_mingwbuild" == "true" ]; then
      # osl
      cd ${_nowhere}/build/osl-${_osl}
      PATH=${_path_hack} ./configure \
        --with-gmp=${_dstdir} \
        --prefix=${_dstdir} \
        ${_commonconfig}
      _makeandinstall || exit 1

      # cloog
      cd ${_nowhere}/build/cloog-${_cloog}
      PATH=${_path_hack} ./configure \
        --with-isl=${_dstdir} \
        --with-osl=${_dstdir} \
        --prefix=${_dstdir} \
        ${_commonconfig}
      _makeandinstall || exit 1

      # mingw-w64-binutils
      cd ${_nowhere}/build/binutils-${_binutils}
      #do not install libiberty
      sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
      # hack! - libiberty configure tests for header files using "$CPP $CPPFLAGS"
      sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" libiberty/configure
      for _target in $_targets; do
        echo -e "Building ${_target} cross binutils"
        mkdir -p ${_nowhere}/build/binutils-${_target} && cd ${_nowhere}/build/binutils-${_target}
        PATH=${_path_hack} ${_nowhere}/build/binutils-${_binutils}/configure \
          --target=${_target} \
          --enable-lto \
          --enable-plugins \
          --enable-deterministic-archives \
          --disable-multilib \
          --disable-nls \
          --disable-werror \
          --prefix=${_dstdir} \
          ${_commonconfig}
        PATH=${_path_hack} make -j$(nproc) || exit 1
      done
      for _target in ${_targets}; do
        echo -e "Installing ${_target} cross binutils"
        cd ${_nowhere}/build/binutils-${_target}
        PATH=${_path_hack} make install
      done

      # mingw-w64-headers
      for _target in ${_targets}; do
        echo -e "Configuring ${_target} headers"
        mkdir -p ${_nowhere}/build/headers-${_target} && cd ${_nowhere}/build/headers-${_target}
        PATH=${_path_hack} ${_nowhere}/build/mingw-w64-v${_mingw}/mingw-w64-headers/configure \
          --enable-sdk=all \
          --enable-secure-api \
          --host=${_target} \
          --prefix=${_dstdir}/${_target}
        PATH=${_path_hack} make || exit 1
      done
      for _target in ${_targets}; do
        echo -e "Installing ${_target} headers"
        cd ${_nowhere}/build/headers-${_target}
        PATH=${_path_hack} make install
        rm ${_dstdir}/${_target}/include/pthread_signal.h
        rm ${_dstdir}/${_target}/include/pthread_time.h
        rm ${_dstdir}/${_target}/include/pthread_unistd.h
      done

      # mingw-w64-headers-bootstrap
      _dummystring="/* Dummy header, which gets overriden, if winpthread library gets installed.  */"
      mkdir -p ${_nowhere}/build/dummy/ && cd ${_nowhere}/build/dummy
      echo "${_dummystring}" > pthread_signal.h
      echo "${_dummystring}" > pthread_time.h
      echo "${_dummystring}" > pthread_unistd.h
      for _target in ${_targets}; do
        install -Dm644 ${_nowhere}/build/dummy/pthread_signal.h ${_dstdir}/${_target}/include/pthread_signal.h
        install -Dm644 ${_nowhere}/build/dummy/pthread_time.h ${_dstdir}/${_target}/include/pthread_time.h
        install -Dm644 ${_nowhere}/build/dummy/pthread_unistd.h ${_dstdir}/${_target}/include/pthread_unistd.h
      done

      # Use a separate src dir for mingw-w64-gcc-base
      cp -r ${_nowhere}/build/gcc ${_nowhere}/build/gcc.base
      # glibc-2.31 workaround
      #sed -e '1161 s|^|//|' -i ${_nowhere}/build/gcc/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
      #sed -e '1161 s|^|//|' -i ${_nowhere}/build/gcc.base/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc

      # mingw-w64-gcc-base
      if [ $_dwarf2 == "true" ]; then
        _exceptions_args="--disable-sjlj-exceptions --with-dwarf2"
      else
        _exceptions_args="--disable-dw2-exceptions"
      fi
      #do not install libiberty
      sed -i 's/install_to_$(INSTALL_DEST) //' ${_nowhere}/build/gcc.base/libiberty/Makefile.in
      # hack! - some configure tests for header files using "$CPP $CPPFLAGS"
      sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" ${_nowhere}/build/gcc.base/{libiberty,gcc}/configure
      for _target in ${_targets}; do
        echo -e "Building ${_target} GCC C compiler"
        mkdir -p ${_nowhere}/build/gcc-base-${_target} && cd ${_nowhere}/build/gcc-base-${_target}
        PATH=${_path_hack} ${_nowhere}/build/gcc.base/configure \
          --target=${_target} \
          --enable-languages=c,lto \
          --with-system-zlib \
          --enable-lto \
          --disable-nls \
          --enable-version-specific-runtime-libs \
          --disable-multilib \
          --enable-checking=release \
          --with-isl=${_dstdir} \
          --with-gmp=${_dstdir} \
          --with-mpfr=${_dstdir} \
          --with-mpc=${_dstdir} \
          --prefix=${_dstdir} \
          ${_exceptions_args} \
          ${_commonconfig} \
          ${_libelf_flag}
        PATH=${_path_hack} make -j$(nproc) all-gcc || exit 1
      done
      for _target in ${_targets}; do
        echo -e "Installing ${_target} GCC C compiler"
        cd ${_nowhere}/build/gcc-base-${_target}
        PATH=${_path_hack} make install-gcc
        strip ${_dstdir}/bin/${_target}-* || true
        strip ${_dstdir}/libexec/gcc.base/${_target}/${_gcc_version}/{cc1,collect2,lto*} || true
      done

      # mingw-w64-crt
      for _target in ${_targets}; do
        echo -e "Building ${_target} CRT"
        if [ ${_target} == "i686-w64-mingw32" ]; then
          _crt_configure_args="--disable-lib64 --enable-lib32"
        elif [ ${_target} == "x86_64-w64-mingw32" ]; then
          _crt_configure_args="--disable-lib32 --enable-lib64"
        fi
        mkdir -p ${_nowhere}/build/crt-${_target} && cd ${_nowhere}/build/crt-${_target}
        PATH=${_path_hack} ${_nowhere}/build/mingw-w64-v${_mingw}/mingw-w64-crt/configure \
          --host=${_target} \
          --enable-wildcard \
          ${_crt_configure_args} \
          --prefix=${_dstdir}/${_target}
        PATH=${_path_hack} make -j$(nproc) || exit 1
      done
      for _target in ${_targets}; do
        echo -e "Installing ${_target} crt"
        cd ${_nowhere}/build/crt-${_target}
        PATH=${_path_hack} make install
      done

      # mingw-w64-winpthreads
      for _target in ${_targets}; do
        echo -e "Building ${_target} winpthreads..."
        mkdir -p ${_nowhere}/build/winpthreads-build-${_target} && cd ${_nowhere}/build/winpthreads-build-${_target}
        PATH=${_path_hack} ${_nowhere}/build/mingw-w64-v${_mingw}/mingw-w64-libraries/winpthreads/configure \
          --host=${_target} \
          --prefix=${_dstdir}/${_target} \
          ${_commonconfig}
        PATH=${_path_hack} make -j$(nproc) || exit 1
      done
      for _target in ${_targets}; do
        cd  ${_nowhere}/build/winpthreads-build-${_target}
        PATH=${_path_hack} make install
        ${_target}-strip --strip-unneeded ${_dstdir}/${_target}/bin/*.dll  || true
      done

      # mingw-w64-gcc
      if [ "$_dwarf2" == "true" ]; then
        _exceptions_args="--disable-sjlj-exceptions --with-dwarf2"
      else
        _exceptions_args="--disable-dw2-exceptions"
      fi
      if [ "$_fortran" == "true" ]; then
        _fortran_args="--enable-languages=c,lto,c++,objc,obj-c++,fortran,ada"
      else
        _fortran_args="--enable-languages=c,lto,c++,objc,obj-c++,ada"
      fi
      if [ "$_win32threads" == "true" ]; then
        _win32threads_args="--enable-threads=win32"
      else
        _win32threads_args="--enable-threads=posix"
      fi
      for _target in ${_targets}; do
        mkdir -p ${_nowhere}/build/gcc-build-${_target} && cd ${_nowhere}/build/gcc-build-${_target}
        PATH=${_path_hack} ${_nowhere}/build/gcc/configure \
          --with-pkgversion='TkG-mostlyportable' \
          --target=${_target} \
          --libexecdir=${_dstdir}/lib \
          --disable-shared \
          --enable-fully-dynamic-string \
          --enable-libstdcxx-time=yes \
          --enable-libstdcxx-filesystem-ts=yes \
          --with-system-zlib \
          --enable-cloog-backend=isl \
          --enable-lto \
          --enable-libgomp \
          --disable-multilib \
          --enable-checking=release \
          --with-isl=${_dstdir} \
          --with-gmp=${_dstdir} \
          --with-mpfr=${_dstdir} \
          --with-mpc=${_dstdir} \
          --prefix=${_dstdir} \
          ${_exceptions_args} \
          ${_fortran_args} \
          ${_win32threads_args} \
          ${_libelf_flag}
        make -j$(nproc) || exit 1
      done
      for _target in ${_targets}; do
        cd ${_nowhere}/build/gcc-build-${_target}
        PATH=${_path_hack} make install
        ${_target}-strip ${_dstdir}/${_target}/lib/*.dll || true
        strip ${_dstdir}/bin/${_target}-*
        if [ $_fortran == "false" ]; then
          strip ${_dstdir}/lib/gcc/${_target}/${_gcc_version}/{cc1*,collect2,gnat1,lto*} || true
        else
          strip ${_dstdir}/lib/gcc/${_target}/${_gcc_version}/{cc1*,collect2,gnat1,f951,lto*} || true
        fi
        ln -s ${_target}-gcc ${_dstdir}/bin/${_target}-cc
        # mv dlls
        mkdir -p ${_dstdir}/${_target}/bin/
        mv ${_dstdir}/${_target}/lib/*.dll ${_dstdir}/${_target}/bin/ || true
      done
      for _binaries in ${_dstdir}/bin/*; do
        if [[ "$_binaries" != *"eu"* ]]; then
          strip $_binaries
        fi
      done
      # remove unnecessary files
      rm -rf ${_dstdir}/share
      rm -f ${_dstdir}/lib/libcc1.*
      # create lto plugin link
      mkdir -p ${_dstdir}/lib/bfd-plugins
      ln -sf "../gcc/x86_64-w64-mingw32/${_gcc_version}/liblto_plugin.so" ${_dstdir}/lib/bfd-plugins/liblto_plugin.so
    else
      export PATH=${_path_hack}

      # binutils
      cd ${_nowhere}/build/binutils-${_binutils}
      # hack! - libiberty configure tests for header files using "$CPP $CPPFLAGS"
      sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/" libiberty/configure
      mkdir -p ${_nowhere}/build/binutils-build && cd ${_nowhere}/build/binutils-build
      ${_nowhere}/build/binutils-${_binutils}/configure \
        --prefix=${_dstdir} \
        --with-lib-path=${_dstdir}/lib \
        --enable-deterministic-archives \
        --enable-gold \
        --enable-ld=default \
        --enable-lto \
        --enable-plugins \
        --enable-relro \
        --enable-targets=x86_64-pep \
        --enable-threads \
        --disable-gdb \
        --disable-werror \
        --with-pic \
        --with-system-zlib \
        ${_commonconfig}
        make -j$(nproc) configure-host || exit 1
        make -j$(nproc) tooldir=${_dstdir} || exit 1
        make -j$(nproc) prefix=${_dstdir} tooldir=${_dstdir} install
        # Remove unwanted files
        rm -f ${_dstdir}/share/man/man1/{dlltool,nlmconv,windres,windmc}*

      # gcc
      mkdir -p ${_nowhere}/build/gcc_build && cd ${_nowhere}/build/gcc_build
      # hack! - libiberty configure tests for header files using "$CPP $CPPFLAGS"
      sed -i "/ac_cpp=/s/\$CPPFLAGS/\$CPPFLAGS -O2/"  ${_nowhere}/build/gcc/{libiberty,gcc}/configure
      # glibc-2.31 workaround
      #sed -e '1161 s|^|//|' -i ${_nowhere}/build/gcc/libsanitizer/sanitizer_common/sanitizer_platform_limits_posix.cc
      ${_nowhere}/build/gcc/configure \
        --with-pkgversion='TkG-mostlyportable' \
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
        --with-isl=${_dstdir} \
        --with-gmp=${_dstdir} \
        --with-mpfr=${_dstdir} \
        --with-mpc=${_dstdir} \
        --enable-offload-targets=nvptx-none,hsa \
        --build=x86_64-linux-gnu \
        --host=x86_64-linux-gnu \
        --target=x86_64-linux-gnu \
        ${_libelf_flag}
        #--enable-libstdcxx-debug
      make -j$(nproc) || exit 1
      make install
      ln -s gcc ${_dstdir}/bin/cc

      #libgcc
      cd ${_nowhere}/build/gcc_build
      make -C x86_64-linux-gnu/libgcc install
      make -C x86_64-linux-gnu/32/libgcc install
      make -C libcpp install
      make -C gcc install-po
      make -C x86_64-linux-gnu/libgcc install-shared
      make -C x86_64-linux-gnu/32/libgcc install-shared
      rm -f ${_dstdir}/lib/gcc/x86_64-linux-gnu/${_gcc_version}/libgcc_eh.a
      rm -f ${_dstdir}/lib/gcc/x86_64-linux-gnu/${_gcc_version}/32/libgcc_eh.a
      for lib in libatomic \
           libgomp \
           libitm \
           libquadmath \
           libsanitizer/{a,l,ub,t}san \
           libstdc++-v3/src \
           libvtv; do
        make -C x86_64-linux-gnu/$lib install-toolexeclibLTLIBRARIES
      done
      for lib in libatomic \
           libgomp \
           libitm \
           libquadmath \
           libsanitizer/{a,l,ub}san \
           libstdc++-v3/src \
           libvtv; do
        make -C x86_64-linux-gnu/32/$lib install-toolexeclibLTLIBRARIES
      done
      make -C x86_64-linux-gnu/libstdc++-v3/po install
    fi

    if [ "$_mingwbuild" == "true" ]; then
      _tgtname="mingw-mostlyportable"
    else
      _tgtname="gcc-mostlyportable"
    fi

    # Remove previous build based on the same version if present
    if [ -d ${_nowhere}/${_tgtname}-${_gcc_version}${_gcc_sub} ]; then
      rm -rf ${_nowhere}/${_tgtname}-${_gcc_version}${_gcc_sub}
    fi

    mv ${_dstdir} ${_nowhere}/${_tgtname}-${_gcc_version}${_gcc_sub} && echo -e "\n\n## Your portable ${_tgtname} build can be found at ${_nowhere}/${_tgtname}-${_gcc_version}${_gcc_sub} and can be moved anywhere.\n\n"
    echo -e "## Depending on your needs, either add bin/lib/include dirs of your build to PATH or\nset CC to the bin/*tool* path to use to build your program\n(example: CC=${_nowhere}/${_tgtname}-${_gcc_version}${_gcc_sub}/bin/gcc)\n"
  }

  set -e

  _init && _build
