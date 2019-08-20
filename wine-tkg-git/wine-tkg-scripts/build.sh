#!/bin/bash

_build() {
	cd "${srcdir}"

	echo "" >> "$_where"/last_build_config.log

	# compiler flags
	if [ "$_LOCAL_OPTIMIZED" == "true" ]; then
	  export CFLAGS="${_GCC_FLAGS}"
	  export LDFLAGS="${_LD_FLAGS}"
	  export CROSSCFLAGS="${_CROSS_FLAGS}"
	  export CROSSLDFLAGS="${_CROSS_LD_FLAGS}"
	  echo "With predefined optimizations:" >> "$_where"/last_build_config.log
	  echo "CFLAGS = ${CFLAGS}" >> "$_where"/last_build_config.log
	  echo "LDFLAGS = ${LDFLAGS}" >> "$_where"/last_build_config.log
	  echo "CROSSCFLAGS = ${CROSSCFLAGS}" >> "$_where"/last_build_config.log
	  echo "CROSSLDFLAGS = ${CROSSLDFLAGS}" >> "$_where"/last_build_config.log
	else
	  echo "Using /etc/makepkg.conf settings for compiler optimization flags" >> "$_where"/last_build_config.log
	fi

	# workaround for FS#55128
	# https://bugs.archlinux.org/task/55128
	# https://bugs.winehq.org/show_bug.cgi?id=43530
	export CFLAGS="${CFLAGS/-fno-plt/}"
	export LDFLAGS="${LDFLAGS/,-z,now/}"
	export CROSSCFLAGS="${CROSSCFLAGS/-fno-plt/}"
	export CROSSLDFLAGS="${CROSSLDFLAGS/,-z,now/}"

	local _prefix="$_where/${pkgname}-${pkgver}"
	local _lib32name="lib32"
	local _lib64name="lib"

	# configure args
	if [ -n "$_configure_userargs" ]; then
	  _configure_args+=($_configure_userargs)
	fi

	# External install
	if [ "$_EXTERNAL_INSTALL" == "true" ]; then
	  if [ "$_EXTERNAL_INSTALL_TYPE" != "proton" ]; then
	    _prefix="$_DEFAULT_EXTERNAL_PATH/$pkgname-$_realwineversion"
	  elif [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ]; then
	    #_prefix="$_where"
	    _configure_args+=(--without-curses)
	  fi
	#else
	#  _configure_args64+=(--libdir="$_prefix/$_lib64name")
	#  _configure_args32+=(--libdir="$_prefix/$_lib32name")
	fi

	if [ "$_NOLIB64" != "true" ]; then
		# build wine 64-bit
		# (according to the wine wiki, this 64-bit/32-bit building order is mandatory)
	  if [ -e /usr/bin/ccache] && [ "$_NOMINGW" != "true"]; then
	    export CROSSCC="ccache x86_64-w64-mingw32-gcc"
	  fi
	  msg2 'Building Wine-64...'
	  cd  "${srcdir}"/"${pkgname}"-64-build
	  if [ "$_NUKR" != "debug" ] || [ "$_DEBUGANSW3" == "y" ]; then
	    ../${_winesrcdir}/configure \
		    --prefix="$_prefix" \
			--with-x \
			--with-gstreamer \
			--enable-win64 \
			--with-xattr \
			"${_configure_args64[@]}" \
			"${_configure_args[@]}"
	  fi
	  if [ "$_LOCAL_OPTIMIZED" == 'true' ]; then
	    # make using all available threads
	    schedtool -B -n 1 -e ionice -n 1 make -j$(nproc)
	  else
	    # make using makepkg settings
	    schedtool -B -n 1 -e ionice -n 1 make
	  fi
	fi

	if [ "$_NOLIB32" != "true" ]; then
	  if [ -e /usr/bin/ccache] && [ "$_NOMINGW" != "true"]; then
	    export CROSSCC="ccache i686-w64-mingw32-gcc"
	  fi
	  # build wine 32-bit
	  export PKG_CONFIG_PATH='/usr/lib32/pkgconfig'
	  msg2 'Building Wine-32...'
	  cd "${srcdir}/${pkgname}"-32-build
	  if [ "$_NUKR" != "debug" ] || [ "$_DEBUGANSW3" == "y" ]; then
		 if [ "$_NOLIB64" == "true" ]; then
	       ../${_winesrcdir}/configure \
		      --prefix="$_prefix" \
		      --with-x \
		      --with-gstreamer \
		      --with-xattr \
		      "${_configure_args32[@]}" \
		      "${_configure_args[@]}"
		  else
	        ../${_winesrcdir}/configure \
		      --prefix="$_prefix" \
		      --with-x \
		      --with-gstreamer \
		      --with-xattr \
		      "${_configure_args32[@]}" \
		      "${_configure_args[@]}" \
		      --with-wine64="${srcdir}/${pkgname}"-64-build
		 fi
	  fi
	  if [ "$_LOCAL_OPTIMIZED" == 'true' ]; then
	    # make using all available threads
	    schedtool -B -n 1 -e ionice -n 1 make -j$(nproc)
	  else
	    # make using makepkg settings
	    schedtool -B -n 1 -e ionice -n 1 make
	  fi
	fi
}

_package() {

	local _prefix="$_where/${pkgname}-${pkgver}"
	local _lib32name="lib32"
	local _lib64name="lib"

	# External install
	if [ "$_EXTERNAL_INSTALL" == "true" ]; then
	  _lib32name="lib" && _lib64name="lib64"
	  if [ "$_EXTERNAL_INSTALL_TYPE" != "proton" ]; then
	    if [ "$_EXTERNAL_NOVER" == "true" ]; then
	      _prefix="$_DEFAULT_EXTERNAL_PATH/$pkgname"
	    else
	      # $_realwineversion doesn't carry over into the fakeroot environment
	      if [ "$_use_staging" == "true" ]; then
	        cd "$srcdir/$_stgsrcdir"
	      else
	        cd "$srcdir/$_winesrcdir"
	      fi
	      _realwineversion=$(_describe_wine)
	      _prefix="$_DEFAULT_EXTERNAL_PATH/$pkgname-$_realwineversion"
	    fi
	  fi
	fi

	if [ "$_NOLIB32" != "true" ]; then
	  # package wine 32-bit
	  # (according to the wine wiki, this reverse 32-bit/64-bit packaging order is important)
	  msg2 'Packaging Wine-32...'
	  cd "${srcdir}/${pkgname}"-32-build
	  make install
	fi

	if [ "$_NOLIB64" != "true" ]; then
	  # package wine 64-bit
	  msg2 'Packaging Wine-64...'
	  cd "${srcdir}/${pkgname}"-64-build
	  make install
	fi

	if [ "$_MIME_NOPE" == "true" ]; then
	    sed 's/winemenubuilder.exe -a -r/winemenubuilder.exe -r/g' "$_prefix"/share/wine/wine.inf -i
	    msg2 'winemenubuilder.exe disabled'
	fi
	if [ "$_FOAS_NOPE" == "true" ]; then
	    sed 's|    LicenseInformation|    LicenseInformation,\\\n    FileOpenAssociations|g;$a \\n[FileOpenAssociations]\nHKCU,Software\\Wine\\FileOpenAssociations,"Enable",,"N"' "$_prefix"/share/wine/wine.inf -i
	    msg2 'FileOpenAssociations disabled'
	fi

	# wine-tkg path scripts - Might be useful for external builds when using weird env vars - Also workarounds wrong paths issues on non-Arch distros
	cp -v "$_where"/wine-tkg-patches/wine-tkg "$_prefix"/bin/wine-tkg
	cp -v "$_where"/wine-tkg-patches/wine-tkg-interactive "$_prefix"/bin/wine-tkg-interactive

	cp -v "$_where"/last_build_config.log "$_prefix"/share/wine/wine-tkg-config.txt

	# move our build to some subfolder
	mkdir -p "$_where"/non-makepkg-builds
	mv "$_where/${pkgname}-${pkgver}" "$_where"/non-makepkg-builds/
	pkgdir="$_where/non-makepkg-builds/${pkgname}-${pkgver}"

	if [ "$_use_esync" == "true" ] || [ "$_staging_esync" == "true" ]; then
	  msg2 '##########################################################################################################################'
	  msg2 ''
	  msg2 'To enable esync, export WINEESYNC=1 and increase file descriptors limits in /etc/security/limits.conf to use ESYNC goodness ;)'
	  msg2 ''
	  msg2 'https://raw.githubusercontent.com/zfigura/wine/esync/README.esync'
	  msg2 ''
	  msg2 '##########################################################################################################################'
	  if [ "$_use_fsync" == "true" ]; then
	    msg2 '##########################################################################################################################'
	    msg2 ''
	    msg2 'To enable fsync, export WINEFSYNC=1 and use a Fsync patched kernel (such as linux52-tkg or newer). If no compatible kernel'
	    msg2 'is found and Esync is enabled, it will fallback to it. You can enable both to get a dynamic "failsafe" mechanism.'
	    msg2 ''
	    msg2 'https://steamcommunity.com/app/221410/discussions/0/3158631000006906163/'
	    msg2 ''
	    msg2 '##########################################################################################################################'
	  fi
	fi

	# External install
	if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" != "proton" ]; then
	  msg2 "### This wine will be installed to: $_prefix"
	  msg2 "### Remember to use $_prefix/bin/wine instead of just wine (same for winecfg etc.)"
	elif [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ]; then
	  touch "${pkgdir}"/../HL3_confirmed
	fi
}

# Workaround
trap _exit_cleanup EXIT
