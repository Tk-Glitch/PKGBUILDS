#!/bin/bash

_exit_cleanup() {
  # Proton-tkg specifics to send to token
  if [ -e "$_where"/BIG_UGLY_FROGMINER ] && [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ] && [ -n "$_proton_tkg_path" ]; then
    if [ -n "$_PROTON_NAME_ADDON" ]; then
      echo "_protontkg_version=${pkgver}.${_PROTON_NAME_ADDON}" >> "$_proton_tkg_path"/proton_tkg_token
    else
      echo "_protontkg_version=${pkgver}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    if [[ $pkgver = 3.* ]]; then
      echo '_proton_branch="proton_3.16"' >> "$_proton_tkg_path"/proton_tkg_token
    else
      echo "_proton_branch=${_proton_branch}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    if [ -n "$_proton_dxvk_configfile" ]; then
      echo "_proton_dxvk_configfile=${_proton_dxvk_configfile}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    if [ -n "$_proton_dxvk_hud" ]; then
      echo "_proton_dxvk_hud=${_proton_dxvk_hud}" >> "$_proton_tkg_path"/proton_tkg_token
    fi
    echo "_skip_uninstaller=${_skip_uninstaller}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_nvapi_disable=${_proton_nvapi_disable}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_winedbg_disable=${_proton_winedbg_disable}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_pulse_lowlat=${_proton_pulse_lowlat}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_force_LAA=${_proton_force_LAA}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_winetricks=${_proton_winetricks}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_dxvk_async=${_proton_dxvk_async}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_use_steamhelper=${_proton_use_steamhelper}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_dxvk_dxgi=${_dxvk_dxgi}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_use_dxvk=${_use_dxvk}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_use_d9vk=${_use_d9vk}" >> "$_proton_tkg_path"/proton_tkg_token
    echo "_proton_pkgdest='${pkgdir}'" >> "$_proton_tkg_path"/proton_tkg_token
  fi

  rm -f "$_where"/BIG_UGLY_FROGMINER && msg2 'Removed BIG_UGLY_FROGMINER - Ribbit' # state tracker end
  rm -f "$_where"/proton_tkg_token && msg2 'Removed Proton-tkg token - Valve Ribbit' # state tracker end

  if [ "$_NUKR" == "true" ]; then
    # Sanitization
    rm -rf "$srcdir"/"$_esyncsrcdir"
    rm -rf "$srcdir"/*.patch
    rm -rf "$srcdir"/*.tgz
    rm -rf "$srcdir"/*.conf
    rm -f "$srcdir"/wine-tkg
    rm -f "$srcdir"/wine-tkg-interactive
    msg2 'exit cleanup done'
  fi

  # Remove temporarily copied patches & other potential fluff
  rm -f "$_where"/wine-tkg
  rm -f "$_where"/wine-tkg-interactive
  rm -rf "$_where"/*.patch
  rm -rf "$_where"/*.my*
  rm -rf "$_where"/*.conf
  rm -rf "$_where"/*.orig
  rm -rf "$_where"/*.rej

  if [ -n "$_buildtime64" ]; then
    msg2 "Compilation time for 64-bit wine: \n$_buildtime64\n"
  fi
  if [ -n "$_buildtime32" ]; then
    msg2 "Compilation time for 32-bit wine: \n$_buildtime32\n"
  fi
}

_init() {
msg2 '       .---.`               `.---.'
msg2 '    `/syhhhyso-           -osyhhhys/`'
msg2 '   .syNMdhNNhss/``.---.``/sshNNhdMNys.'
msg2 '   +sdMh.`+MNsssssssssssssssNM+`.hMds+'
msg2 '   :syNNdhNNhssssssssssssssshNNhdNNys:'
msg2 '    /ssyhhhysssssssssssssssssyhhhyss/'
msg2 '    .ossssssssssssssssssssssssssssso.'
msg2 '   :sssssssssssssssssssssssssssssssss:'
msg2 '  /sssssssssssssssssssssssssssssssssss/'
msg2 ' :sssssssssssssoosssssssoosssssssssssss:'
msg2 ' osssssssssssssoosssssssoossssssssssssso'
msg2 ' osssssssssssyyyyhhhhhhhyyyyssssssssssso'
msg2 ' /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/'
msg2 '  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms'
msg2 '   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/'
msg2 '    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`'
msg2 '       `-+shdNNNNNNNNNNNNNNNdhs+-`'
msg2 '             `.-:///////:-.`'
msg2 ''

  # load default configuration from files
  if [ -e "$_where"/proton_tkg_token ]; then
    source "$_where"/proton_tkg_token
    source "$_proton_tkg_path"/proton-tkg.cfg
  else
    source "$_where"/customization.cfg
    _EXTERNAL_INSTALL_TYPE="opt"
  fi

  # Load external configuration file if present. Available variable values will overwrite customization.cfg ones.
  if [ -e "$_EXT_CONFIG_PATH" ]; then
    source "$_EXT_CONFIG_PATH" && msg2 "External configuration file $_EXT_CONFIG_PATH will be used to override customization.cfg values." && msg2 ""
  fi

  # Load preset configuration files if present and selected. All values will overwrite customization.cfg ones.
  if [ -n "$_LOCAL_PRESET" ] && [ -e "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg ]; then
    source "$_where"/wine-tkg-profiles/wine-tkg.cfg && source "$_where"/wine-tkg-profiles/wine-tkg-"$_LOCAL_PRESET".cfg && msg2 "Preset configuration $_LOCAL_PRESET will be used to override customization.cfg values." && msg2 ""
  fi

  if [ "$_NOINITIALPROMPT" == "true" ] || [ -n "$_LOCAL_PRESET" ] || [ -n "$_DEPSHELPER" ]; then
    msg2 'Initial prompt skipped. Do you remember what it said? 8)'
  else
    # If the state tracker isn't found, prompt the user with useful stuff.
    # This is to prevent the prompt to come back until packaging is done
    if [ ! -e "$_where"/BIG_UGLY_FROGMINER ]; then
      msg2 '#################################################################'
      msg2 ''
      msg2 'You can configure your wine build flavour (right now for example)'
      if [ -e "$_EXT_CONFIG_PATH" ]; then
        msg2 "by editing the $_EXT_CONFIG_PATH file."
        msg2 ''
        msg2 'In case you are only using a partial config file, remaining'
        msg2 'values will be loaded from the .cfg file next to this script !'
      elif [ -e "$_proton_tkg_path"/proton_tkg_token ]; then
        msg2 'by editing the proton-tkg.cfg file in the proton-tkg dir,'
        msg2 'or by creating a custom config, for example'
        msg2 '~/.config/frogminer/proton-tkg.cfg (path set in config file)'
        msg2 'to override some or all of its values.'
      else
        msg2 'by editing the customization.cfg file next to this PKGBUILD,'
        msg2 'or by creating a custom config, for example'
        msg2 '~/.config/frogminer/wine-tkg.cfg (path set in config file)'
        msg2 'to override some or all of its values.'
      fi
      msg2 ''
      msg2 "Current path is '$_where'"
      msg2 ''
      msg2 'If you are rebuilding using the same configuration, you may want'
      msg2 'to delete/move previously built package if in the same dir.'
      msg2 ''
      msg2 '###################################TkG##########was##########here'
      read -rp "When you are ready, press enter to continue."

      if [ -e "$_EXT_CONFIG_PATH" ]; then
        source "$_EXT_CONFIG_PATH" && msg2 "External config loaded" # load external configuration from file again, in case of changes.
      else
        # load default configuration from file again, in case of change
        if [ -e "$_proton_tkg_path"/proton_tkg_token ]; then
          source "$_proton_tkg_path"/proton-tkg.cfg
        else
          source "$_where"/customization.cfg
        fi
      fi
    fi
  fi

  # Check for proton-tkg token to prevent broken state as we need to enforce some defaults
  if [ -e "$_proton_tkg_path"/proton_tkg_token ] && [ -n "$_proton_tkg_path" ]; then
    _LOCAL_PRESET=""
    _EXTERNAL_INSTALL="true"
    _EXTERNAL_INSTALL_TYPE="proton"
    _EXTERNAL_NOVER="false"
    _NOLIB32="false"
    _NOLIB64="false"
    _NUKR="true"
    _esync_version=""
    _use_faudio="true"
    _highcorecount_fix="true"
    _update_winevulkan="true"
    _use_mono="true"
    if [ "$_use_dxvk" == "true" ]; then
      _use_dxvk="release"
    fi
    if [ "$_use_d9vk" == "true" ]; then
      _use_d9vk="release"
    fi
  elif [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ]; then
    error "It looks like you're attempting to build a Proton version of wine-tkg-git."
    error "This special option doesn't use pacman and requires you to run 'proton-tkg.sh' script from proton-tkg dir."
    _exit_cleanup
    exit
  fi
}

_pkgnaming() {
  if [ -n "$_PKGNAME_OVERRIDE" ]; then
    if [ "$_PKGNAME_OVERRIDE" == "none" ]; then
      pkgname="${pkgname}"
    else
      pkgname="${pkgname}-${_PKGNAME_OVERRIDE}"
    fi
    msg2 "Overriding default pkgname. New pkgname: ${pkgname}"
  else
    if [ "$_use_staging" == "true" ]; then
      pkgname="${pkgname/%-git/-staging-git}"
      msg2 "Using staging patchset"
    fi

    if [ "$_use_esync" == "true" ]; then
      if [ "$_use_fsync" == "true" ]; then
        pkgname="${pkgname/%-git/-fsync-git}"
        msg2 "Using fsync patchset"
      else
        pkgname="${pkgname/%-git/-esync-git}"
        msg2 "Using esync patchset"
      fi
    fi

    if [ "$_use_pba" == "true" ]; then
#      pkgname="${pkgname/%-git/-pba-git}"
      msg2 "Using pba patchset"
    fi

    if [ "$_use_legacy_gallium_nine" == "true" ]; then
      pkgname="${pkgname/%-git/-nine-git}"
      msg2 "Using gallium nine patchset (legacy)"
    fi

    if [ "$_use_vkd3d" == "true" ]; then
      pkgname="${pkgname/%-git/-vkd3d-git}"
      msg2 "Using VKD3D for d3d12 translation"
    fi

    if [ "$_use_faudio" == "true" ]; then
      pkgname="${pkgname/%-git/-faudio-git}"
      msg2 "Using Faudio for xaudio2"
    fi
  fi

  # External install
  if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" != "proton" ]; then
    pkgname="${pkgname/%-git/-$_EXTERNAL_INSTALL_TYPE-git}"
    msg2 "Installing to $_DEFAULT_EXTERNAL_PATH/$pkgname"
  elif [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ]; then
    pkgname="proton_dist"
    _DEFAULT_EXTERNAL_PATH="$HOME/.steam/root/compatibilitytools.d"
    msg2 "Installing to $_DEFAULT_EXTERNAL_PATH/proton_tkg"
  fi
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

_describe_wine() {
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//;s/\.rc/rc/;s/^wine\.//'
}

_describe_other() {
  git describe --long --tags --always | sed 's/\([^-]*-g\)/r\1/;s/-/./g;s/^v//'
}

_source_cleanup() {
	if [ "$_NUKR" != "debug" ]; then
	  if [ "$_use_staging" == "true" ]; then
	    cd "${srcdir}"/"${_stgsrcdir}"

	    # restore the targetted trees to their git origin state
	    # for the patches not to fail on subsequent aborted builds
	    msg2 'Cleaning wine-staging source code tree...'
	    git reset --hard HEAD 	# restore tracked files
	    git clean -xdf 			# delete untracked files
	  fi

	  cd "${srcdir}"/"${_winesrcdir}"

	  msg2 'Cleaning wine source code tree...'
	  git reset --hard HEAD 	# restore tracked files
	  git clean -xdf 			# delete untracked files
	fi
}

_prepare() {
	# holds extra arguments to staging's patcher script, if applicable
	local _staging_args=()
	# grabs userdefined staging args if any
	_staging_args+=($_staging_userargs)

	source "$_where"/wine-tkg-patches/hotfixes/hotfixer

	# wine-staging user patches
	if [ "$_user_patches" == "true" ] && [ "$_use_staging" == "true" ]; then
	  _userpatch_target="wine-staging"
	  _userpatch_ext="mystaging"
	  cd "${srcdir}"/"${_stgsrcdir}"
	  hotfixer
	  user_patcher
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	if [ "$_use_staging" == "true" ] && [ "$_staging_upstreamignore" != "true" ]; then
	  cd "${srcdir}"/"${_winesrcdir}"
	  # change back to the wine upstream commit that this version of wine-staging is based in
	  msg2 'Changing wine HEAD to the wine-staging base commit...'
	  git checkout "$(../"$_stgsrcdir"/patches/patchinstall.sh --upstream-commit)"
	fi

	# output config to logfile
	echo "# Last $pkgname configuration - $(date) :" > "$_where"/last_build_config.log
	echo "" >> "$_where"/last_build_config.log

	_realwineversion=$(_describe_wine)
	echo "Wine (plain) version: $_realwineversion" >> "$_where"/last_build_config.log

	if [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  _realwineversion=$(_describe_wine)
	  echo "Using wine-staging patchset (version $_realwineversion)" >> "$_where"/last_build_config.log
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Disable local Esync on 553986f
	if [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 553986fdfb111914f793ff1487d53af022e4be19 HEAD; then # eventfd_synchronization: Add patch set.
	    _use_esync="false"
	    _staging_esync="true"
	    echo "Disabled the local Esync patchset to use Staging impl instead." >> "$_where"/last_build_config.log
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	if [ "$_use_esync" == "true" ]; then
	  if [ -z "$_esync_version" ]; then
	    if git merge-base --is-ancestor 2600ecd4edfdb71097105c74312f83845305a4f2 HEAD; then # 3.20+
	      _esync_version="ce79346"
	    elif git merge-base --is-ancestor aec7befb5115d866724149bbc5576c7259fef820 HEAD; then # 3.19-3.17
	      _esync_version="b4478b7"
	    else
	      _esync_version="5898a69" # 3.16 and lower
	    fi
	  fi
	  echo "Using esync patchset (version ${_esync_version})" >> "$_where"/last_build_config.log
	  wget -O "$_where"/esync${_esync_version}.tgz https://github.com/zfigura/wine/releases/download/esync${_esync_version}/esync.tgz && tar zxf "$_where"/esync${_esync_version}.tgz -C "${srcdir}"
	fi

	if [ "$_use_pba" == "true" ]; then
	  # If using a wine version that includes 944e92b, disable PBA
	  if git merge-base --is-ancestor 944e92ba06ecadeb933d95e30035323483dfe7c7 HEAD; then # wined3d: Pass the wined3d_buffer_desc structure directly to buffer_init()
	    _pba_version="none"
	  # If using a wine version that includes 580ea44, apply 3.17+ fixes
	  elif git merge-base --is-ancestor 580ea44bc65472c0304d74b7e873acfb7f680b85 HEAD; then # wined3d: Use query buffer objects for occlusion queries
	    _pba_version="317+"
	  # If using a wine version that includes cf9536b, apply 3.14+ fixes
	  elif git merge-base --is-ancestor cf9536b6bfbefbf5003c7633446a91f6e399c4de HEAD; then # wined3d: Move OpenGL initialisation code to adapter_gl.c
	    _pba_version="314+"
	  else
	    _pba_version="313-"
	  fi
	fi

	if [ "$_use_legacy_gallium_nine" == "true" ]; then
	  echo "Using gallium nine patchset (legacy)" >> "$_where"/last_build_config.log
	fi

	if [ "$_use_vkd3d" == "true" ]; then
	  _configure_args+=(--with-vkd3d)
	  echo "Using VKD3D for d3d12 translation" >> "$_where"/last_build_config.log
	fi

	echo "" >> "$_where"/last_build_config.log

	if [ "$_NUKR" == "debug" ]; then
	  msg2 "You are currently in debug/dev mode. By default, patches aren't applied in this mode as the source won't be cleaned up/reset between compilations. You can however choose to patch your tree to get your initial source as you desire:"
	  read -rp "Do you want to patch the current wine source with the builtin patches (respecting your .cfg settings)? Do it only once or patches will fail!"$'\n> N/y : ' _DEBUGANSW1;
	  if [ "$_use_staging" == "true" ]; then
	    read -rp "Do you want to patch the current wine source with staging patches (respecting your .cfg settings)? Do it only once or patches will fail!"$'\n> N/y : ' _DEBUGANSW2;
	  fi
	  read -rp "Do you want to run configure? You need to run it at least once to populate your build dirs!"$'\n> N/y : ' _DEBUGANSW3;
	fi

	# Update winevulkan
	if [ "$_update_winevulkan" == "true" ] && ! git merge-base --is-ancestor 3e4189e3ada939ff3873c6d76b17fb4b858330a8 HEAD && git merge-base --is-ancestor eb39d3dbcac7a8d9c17211ab358cda4b7e07708a HEAD; then
	  _patchname='winevulkan-1.1.103.patch' && _patchmsg="Applied winevulkan 1.1.103 patch" && nonuser_patcher
	fi

	# use CLOCK_MONOTONIC instead of CLOCK_MONOTONIC_RAW in ntdll/server - lowers overhead
	if [ "$_clock_monotonic" == "true" ]; then
	  _patchname='use_clock_monotonic.patch' && _patchmsg="Applied clock_monotonic patch" && nonuser_patcher
	  if git merge-base --is-ancestor 13e11d3fcbcf8790e031c4bc52f5f550b1377b3b HEAD; then
	    _patchname='use_clock_monotonic-2.patch' && _patchmsg="Applied clock_monotonic addon patch for 13e11d3" && nonuser_patcher
	  fi
	fi

	# Fixes (partially) systray on plasma 5 - https://bugs.winehq.org/show_bug.cgi?id=38409
	if [ "$_plasma_systray_fix" == "true" ]; then
	  _patchname='plasma_systray_fix.patch' && _patchmsg="Applied plasma 5 systray fix" && nonuser_patcher
	fi

	# Bypass compositor in fullscreen mode - Reduces stuttering and improves performance
	if [ "$_FS_bypass_compositor" == "true" ]; then
	  _patchname='FS_bypass_compositor.patch' && _patchmsg="Applied Fullscreen compositor bypass patch" && nonuser_patcher
	fi

	# Use faudio for xaudio2
	if git merge-base --is-ancestor d5a372abbba2e174de78855bdd4a004b56cdc006 HEAD; then # include: Move inline assembly definitions to a new wine/asm.h header.
	  _use_faudio="true"
	fi
	if [ "$_use_faudio" == "true" ] && [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if ! git merge-base --is-ancestor b95b9109b824d21d98329c76387c3983d6e27cc2 HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}"
	    if git merge-base --is-ancestor 9422b844b59282db04af533451f50661de56b9ca HEAD; then
	      _staging_args+=(-W xaudio2-revert -W xaudio2_7-CreateFX-FXEcho -W xaudio2_7-WMA_support -W xaudio2_CommitChanges) # Disable xaudio2 staging patchsets for faudio
	      if [ "$_faudio_ignorecheck" != "true" ]; then
	        _configure_args+=(--with-faudio)
	      fi
	    elif git merge-base --is-ancestor 47fbcece36cad190c4d18f7636df67d1382b7545 HEAD && ! git merge-base --is-ancestor 3e390b1aafff47df63376a8ca4293c515d74f4ba HEAD; then
	      _patchname='faudio-exp.patch' && _patchmsg="Applied faudio for xaudio2 patch" && nonuser_patcher
	      _staging_args+=(-W xaudio2_7-CreateFX-FXEcho -W xaudio2_7-WMA_support -W xaudio2_CommitChanges) # Disable xaudio2 staging patchsets for faudio
	      if [ "$_faudio_ignorecheck" != "true" ]; then
	        _configure_args+=(--with-faudio)
	      fi
	    fi
	  else
	    if [ "$_faudio_ignorecheck" != "true" ]; then
	      _configure_args+=(--with-faudio)
	    fi
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Disable winex11.drv-mouse-coorrds patchset on staging for proton FS hack
	if [ "$_proton_fs_hack" == "true" ] && [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 7cc69d770780b8fb60fb249e007f1a777a03e51a HEAD; then
	    _staging_args+=(-W winex11.drv-mouse-coorrds)
	  fi
	  if git merge-base --is-ancestor fd3bb06a4c1102cf424bc78ead25ee440db1b0fa HEAD && [ "$_rawinput_fix" != "true" ]; then
	    #_staging_args+=(-W winex11-mouse-movements)
	    for _f in "$_where"/valve_proton_fullscreen_hack-staging-*.patch ; do
	      patch ${_f} << 'EOM'
@@ -2577,7 +2577,7 @@ index 1209a250b0..077c18ac10 100644
 +    input.u.mi.dx = pt.x;
 +    input.u.mi.dy = pt.y;
 +
-     TRACE( "pos %d,%d (event %f,%f, accum %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy, x_rel->accum, y_rel->accum );
+     TRACE( "pos %d,%d (event %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy );
  
      input.type = INPUT_MOUSE;
 diff --git a/dlls/winex11.drv/opengl.c b/dlls/winex11.drv/opengl.c
EOM
        done
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# Disable some staging patchsets to prevent bad interactions with proton gamepad additions
	if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ] && [ "$_use_staging" == "true" ] && [ "$_gamepad_additions" == "true" ]; then
	  _staging_args+=(-W dinput-SetActionMap-genre -W dinput-axis-recalc -W dinput-joy-mappings -W dinput-reconnect-joystick -W dinput-remap-joystick)
	fi

	if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ] && [ "$_use_staging" == "true" ] && [ "$_proton_use_steamhelper" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 4e7071e4f14f6ce85b0eb4b88accfb0267d6545b HEAD; then
	    _staging_args+=(-W server-Desktop_Refcount -W ws2_32-TransmitFile)
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	# raw input fix by Guy1524 - part one
	if [ "$_rawinput_fix" == "true" ] && [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if ! git merge-base --is-ancestor 938dddf7df920396ac3b30a44768c1582d0c144f HEAD; then
	    _staging_args+=(-W winex11-mouse-movements)
	  fi
	  cd "${srcdir}"/"${_winesrcdir}"
	  for _f in "$_where"/valve_proton_fullscreen_hack-staging-*.patch ; do
	    patch ${_f} << 'EOM'
@@ -2577,7 +2577,7 @@ index 1209a250b0..077c18ac10 100644
 +    input.u.mi.dx = pt.x;
 +    input.u.mi.dy = pt.y;
 +
-     TRACE( "pos %d,%d (event %f,%f, accum %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy, x_rel->accum, y_rel->accum );
+     TRACE( "pos %d,%d (event %f,%f)\n", input.u.mi.dx, input.u.mi.dy, dx, dy );
  
      input.type = INPUT_MOUSE;
 diff --git a/dlls/winex11.drv/opengl.c b/dlls/winex11.drv/opengl.c
EOM
      done
    fi

	# Patch to allow Path of Exile to run with DirectX11
	# https://bugs.winehq.org/show_bug.cgi?id=42695
	if [ "$_poe_fix" == "true" ]; then
	  _patchname='poe-fix.patch' && _patchmsg="Applied Path of Exile DX11 fix" && nonuser_patcher
	fi

	# Fix for Warframe Launcher failing to update itself - https://bugs.winehq.org/show_bug.cgi?id=33845 https://bugs.winehq.org/show_bug.cgi?id=45701 - Merged in staging 8b930ae and mainline 04ccd99
	if [ "$_warframelauncher_fix" == "true" ]; then
	  if [ "$_use_staging" == "true" ] && ! git merge-base --is-ancestor 33c35baa6761b00c8cef236c06cb1655f3f228d9 HEAD || [ "$_use_staging" != "true" ] && ! git merge-base --is-ancestor 04ccd995b1aec5eac5874454a320b37676b69c42 HEAD; then
	    _patchname='warframe-launcher.patch' && _patchmsg="Applied Warframe Launcher fix" && nonuser_patcher
	  fi
	fi

	# Workaround for F4SE/SkyrimSE Script Extender
	# https://github.com/hdmap/wine-hackery/tree/master/f4se
	if [ "$_f4skyrimse_fix" == "true" ]; then
	  if ! git merge-base --is-ancestor 12be24af8cab0e5f78795b164ec8847bafc30852 HEAD; then
	    _patchname='f4skyrimse-fix-1.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (1)" && nonuser_patcher
	  fi
	  if ! git merge-base --is-ancestor 1aa963efd7c7c7f91423f5edb9811f6ff95c06c0 HEAD; then
	    if git merge-base --is-ancestor 4c750a35c3c087d1fa9b0882fb0bdd6804296473 HEAD; then
	      _patchname='f4skyrimse-fix-2.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    elif git merge-base --is-ancestor be48a56e700d47f2221d983a37ef70228508c11b HEAD; then
	      _patchname='f4skyrimse-fix-2-4c750a3.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    elif git merge-base --is-ancestor 00451d5edf9a13fd8f414a0d06869e38cf66b754 HEAD; then
	      _patchname='f4skyrimse-fix-2-be48a56.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    else
	      _patchname='f4skyrimse-fix-2-00451d5.patch' && _patchmsg="Applied F4/SkyrimSE Script Extender fix (2)" && nonuser_patcher
	    fi
	  fi
	fi

	# Magic The Gathering: Arena crash fix
	if [ "$_mtga_fix" == "true" ]; then
	  _patchname='mtga.patch' && _patchmsg="Applied MTGA crashfix" && nonuser_patcher
	fi

	# The Sims 2 fix - disable wined3d-WINED3D_RS_COLORWRITEENABLE and wined3d-Indexed_Vertex_Blending staging patchsets for 4.2+devel and lower - The actual patch is applied after staging
	if [ "$_sims2_fix" == "true" ] && ! git merge-base --is-ancestor d88f12950761e9ff8d125a579de6e743979f4945 HEAD; then
	  _staging_args+=(-W wined3d-WINED3D_RS_COLORWRITEENABLE -W wined3d-Indexed_Vertex_Blending)
	fi

	# The Sims 3 fix - reverts 6823abd521c0c12d20d9171fb5ae8b300009d082 to fix Sims 3 on older than 415.xx nvidia drivers - https://bugs.winehq.org/show_bug.cgi?id=45361
	if [ "$_sims3_fix" == "true" ] && git merge-base --is-ancestor 6823abd521c0c12d20d9171fb5ae8b300009d082 HEAD; then
	  _patchname='sims_3-oldnvidia.patch' && _patchmsg="Applied The Sims 3 Debian&co nvidia fix" && nonuser_patcher
	fi

	# Python fix for <=3.18 (backported from zzhiyi's patches) - fix for python and needed for "The Sims 4" to work - replaces staging partial implementation - https://bugs.winehq.org/show_bug.cgi?id=44999 - The actual patch is applied after staging
	if [ "$_318python_fix" == "true" ] && ! git merge-base --is-ancestor 3ebd2f0be30611e6cf00468c2980c5092f91b5b5 HEAD; then
	  _staging_args+=(-W kernelbase-PathCchCombineEx)
	fi

	# Mechwarrior Online fix - https://mwomercs.com/forums/topic/268847-running-the-game-on-ubuntu-steam-play/page__st__20__p__6195387#entry6195387
	if [ "$_mwo_fix" == "true" ]; then
	  _patchname='mwo.patch' && _patchmsg="Applied Mechwarrior Online fix" && nonuser_patcher
	fi

	# Resident Evil 4 hack - https://bugs.winehq.org/show_bug.cgi?id=46336
	if [ "$_re4_fix" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if [ "$_use_staging" == "true" ] && git merge-base --is-ancestor 2e4d0f472736529f59bd92dd3863731cd6bab875 HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}" && echo "RE4 fix disabled for the selected Wine-staging version" >> "$_where"/last_build_config.log
	  else
	    cd "${srcdir}"/"${_winesrcdir}" && _patchname='resident_evil_4_hack.patch' && _patchmsg="Applied Resident Evil 4 hack" && nonuser_patcher
	  fi
	fi

	# Child window support for vk - Fixes World of Final Fantasy and others - https://bugs.winehq.org/show_bug.cgi?id=45277
	if [ "$_childwindow_fix" == "true" ]; then
	  _patchname='childwindow.patch' && _patchmsg="Applied child window for vk patch" && nonuser_patcher
	fi

	# Workaround for https://bugs.winehq.org/show_bug.cgi?id=47633
	if [ "$_nativedotnet_fix" == "true" ] && git merge-base --is-ancestor 0116660dd80b38da8201e2156adade67fc2ae823 HEAD && ! git merge-base --is-ancestor 505be3a0a2afeae3cebeaad48fc5f32e0b0336b7 HEAD; then
	  _patchname='0001-kernelbase-Remove-DECLSPEC_HOTPATCH-from-SetThreadSt.patch' && _patchmsg="Applied native dotnet workaround (https://bugs.winehq.org/show_bug.cgi?id=47633)" && nonuser_patcher
	fi

	# USVFS (Mod Organizer 2's virtual filesystem) patch
	if [ "$_usvfs_fix" == "true" ]; then
	  _patchname='usvfs.patch' && _patchmsg="Applied USVFS (Mod Organizer 2's virtual filesystem) patch" && nonuser_patcher
	fi

	# Reverts c6b6935 due to https://bugs.winehq.org/show_bug.cgi?id=47752
	if [ "$_c6b6935_revert" == "true" ] && ! git merge-base --is-ancestor cb703739e5c138e3beffab321b84edb129156000 HEAD; then
	  _patchname='revert-c6b6935.patch' && _patchmsg="Reverted c6b6935 to fix regression affecting performance negatively" && nonuser_patcher
	fi

	# steam crossover hack for store/web functionality
	# https://bugs.winehq.org/show_bug.cgi?id=39403
	if [ "$_steam_fix" == "true" ]; then
	  _patchname='steam.patch' && _patchmsg="Applied steam crossover hack" && nonuser_patcher
	fi

	# Disable server-send_hardware_message staging patchset if found - Fixes FFXIV/Warframe/Crysis 3 (...) mouse jittering issues on 3.19 staging and lower.
	if [ "$_server_send_hwmsg_disable" == "true" ] && [ "$_use_staging" == "true" ]; then
	  if [ -d "${srcdir}"/"${_stgsrcdir}"/patches/server-send_hardware_message ]; then # ghetto check for server-send_hardware_message staging patchset presence
	    _staging_args+=(-W server-send_hardware_message)
	    echo "server-send_hardware_message staging patchset disabled (mouse jittering fix)" >> "$_where"/last_build_config.log
	  else
	    echo "server-send_hardware_message staging patchset wasn't found, so _server_send_hwmsg_disable setting was ignored" >> "$_where"/last_build_config.log
	  fi
	fi

	# Disable winepulse pulseaudio patchset
	if [ "$_staging_pulse_disable" == "true" ] && [ "$_use_staging" == "true" ]; then
	  _staging_args+=(-W winepulse-PulseAudio_Support)
	  echo "Disabled the staging winepulse patchset" >> "$_where"/last_build_config.log
	fi

	# CSMT toggle patch - Corrects the CSMT toggle to be more logical
	if [ "$_CSMT_toggle" == "true" ] && [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}"/"${_stgsrcdir}"
	  _patchname='CSMT-toggle.patch' && _patchmsg="Applied CSMT toggle logic patch" && nonuser_patcher
	  cd "${srcdir}"/"${_winesrcdir}"
	fi

	if [ "$_use_staging" == "true" ] && [ "$_NUKR" != "debug" ] || [ "$_DEBUGANSW2" == "y" ]; then
	  msg2 "Applying wine-staging patches..." && echo "Staging overrides, if any: ${_staging_args[@]}" >> "$_where"/last_build_config.log
	  "${srcdir}"/"${_stgsrcdir}"/patches/patchinstall.sh DESTDIR="${srcdir}/${_winesrcdir}" --all "${_staging_args[@]}"

	  # Remove staging version tag
	  sed -i "s/  (Staging)//g" "${srcdir}"/"${_winesrcdir}"/libs/wine/Makefile.in
	fi

	# esync
	if [ "$_use_esync" == "true" ]; then
	  if git merge-base --is-ancestor 2600ecd4edfdb71097105c74312f83845305a4f2 HEAD; then # Esync ce79346
	    if [ "$_use_staging" == "true" ]; then
	      # fixes for esync patches to apply to staging
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r3.patch' && _patchmsg="Using esync staging 3.20+ compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r3.patch' && _patchmsg="Using esync 3.20+ compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"

	    # if using a wine version that includes 7ba361b, apply 4.4+ additional fixes
	    if git merge-base --is-ancestor 7ba361b47bc95df624eac83c170d6c1a4041d8f8 HEAD; then # ntdll: Add support for returning previous state argument in event functions
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.1.patch' && _patchmsg="Using esync 4.4+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b2a546c, apply 4.5+ additional fixes
	    if git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD; then # server: Introduce kernel_object struct for generic association between server and kernel objects.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.2.patch' && _patchmsg="Using esync 4.5+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes b3c8d5d, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor b3c8d5d36850e484b5cc84ab818a75db567a06a3 HEAD; then # ntdll: Use static debug info before initialization is done. 
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.3.patch' && _patchmsg="Using esync 4.6+(b3c8d5d) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 4c0e817, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor 4c0e81728f6db575d9cbd8feb8a5374f1adec9bb HEAD; then # ntdll: Use static debug info before initialization is done. 
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.4.patch' && _patchmsg="Using esync 4.6+(4c0e817) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes f534fbd, apply 4.6+ additional fixes
	    if git merge-base --is-ancestor f534fbd3e3c83df49c7c6b8e608a99f2af65adc0 HEAD; then # server: Allow creating process kernel objects.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.5.patch' && _patchmsg="Using esync 4.6+(f534fbd) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    # if using a wine version that includes 29914d5, apply 4.8+ additional fixes
	    if git merge-base --is-ancestor 29914d583fe098521472332687b8da69fc692690 HEAD; then # server: Pass file object handle in IRP_CALL_CREATE request.
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r3.6.patch' && _patchmsg="Using esync 4.8+(29914d5) additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi
	  # if using a wine version that includes aec7bef, use 3.17+ fixes
	  elif git merge-base --is-ancestor aec7befb5115d866724149bbc5576c7259fef820 HEAD; then # server: Avoid potential size overflow for empty object attributes
	    if [ "$_use_staging" == "true" ]; then
	      # fixes for esync patches to apply to staging
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r2.patch' && _patchmsg="Using esync staging 3.17+ compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    # if using a wine version that includes c099655, use 3.19+ addon fixes
	    elif git merge-base --is-ancestor c0996553a1d9056e1b89871fc8c3fb0bfb5a4f0c HEAD; then #  server: Support FILE_SKIP_COMPLETION_PORT_ON_SUCCESS on server-side asyncs
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r2.1.patch' && _patchmsg="Using esync 3.19+ compat addon fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r2.patch' && _patchmsg="Using esync 3.17+ compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"
	  else
	    # 3.10 - 3.16
	    if [ "$_use_staging" == "true" ]; then
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-staging-fixes-r1.patch' && _patchmsg="Using esync staging 3.16- compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi

	    cd "${srcdir}"/"${_esyncsrcdir}"
	    _patchname='esync-compat-fixes-r1.patch' && _patchmsg="Using esync 3.16- compat fixes" && nonuser_patcher
	    cd "${srcdir}"/"${_winesrcdir}"

	    # if using a wine version that includes 57212f6, apply 3.14+ additional fixes
	    if git merge-base --is-ancestor 57212f64f8e4fef0c63c633940e13d407c0f2069 HEAD; then # kernel32: Add AttachConsole implementation
	      cd "${srcdir}"/"${_esyncsrcdir}"
	      _patchname='esync-compat-fixes-r1.1.patch' && _patchmsg="Using esync 3.14+ additional compat fixes" && nonuser_patcher
	      cd "${srcdir}"/"${_winesrcdir}"
	    fi
	  fi

	  # apply esync patches
	  for _f in "${srcdir}"/"${_esyncsrcdir}"/*.patch; do
	    msg2 "Applying ${_f}"
	    git apply -C1 --verbose < "${_f}"
	  done

	  if git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD; then #  server: Introduce kernel_object struct for generic association between server and kernel objects.
	    _patchname='esync-no_kernel_obj_list.patch' && _patchmsg="Add no_kernel_obj_list object method to esync. (4.5+)" && nonuser_patcher
	  fi

	  # Fix for server-Desktop_Refcount and patchsets depending on it (ws2_32-WSACleanup, ws2_32-TransmitFile, server-Pipe_ObjectName)
	  if [ "$_use_staging" == "true" ]; then
	    if ! git merge-base --is-ancestor b2a546c92dabee8ab1c3d5b9fecc84d99caf0e76 HEAD; then #  server: Introduce kernel_object struct for generic association between server and kernel objects.
	      _patchname='esync-no_alloc_handle.patch' && _patchmsg="Using esync-no_alloc_handle patch to fix server-Desktop_Refcount ws2_32-WSACleanup ws2_32-TransmitFile server-Pipe_ObjectName with Esync enabled" && nonuser_patcher
	    fi
	  fi
	fi
	# /esync

	# Launch with dedicated gpu desktop entry patch
	if [ "$_launch_with_dedicated_gpu" == "true" ]; then
	  _patchname='launch-with-dedicated-gpu-desktop-entry.patch' && _patchmsg="Applied launch with dedicated gpu desktop entry patch" && nonuser_patcher
	fi

	# Low latency alsa audio - https://blog.thepoon.fr/osuLinuxAudioLatency/
	if [ "$_lowlatency_audio" == "true" ] && [ "$_use_staging" == "true" ]; then
	  _patchname='lowlatency_audio.patch' && _patchmsg="Applied low latency alsa audio patch" && nonuser_patcher
	fi

	# Fortnite Fix - Currently not working anymore
	if [ "$_fortnite_fix" == "true" ]; then
	  _patchname='fortnite.patch' && _patchmsg="Applied Fortnite crashfix" && nonuser_patcher
	fi

	# The Sims 2 fix - https://bugs.winehq.org/show_bug.cgi?id=8051
	if [ "$_sims2_fix" == "true" ]; then
	  if git merge-base --is-ancestor d88f12950761e9ff8d125a579de6e743979f4945 HEAD; then
	    _patchname='sims_2-fix.patch' && _patchmsg="Applied The Sims 2 fix" && nonuser_patcher
	  elif git merge-base --is-ancestor 4de2da1d146248ed872ae45c30b8d485832f4ac8 HEAD; then
	    _patchname='sims_2-fix-4.2-.patch' && _patchmsg="Applied The Sims 2 fix (4.2 and lower)" && nonuser_patcher
	  else
	    _patchname='sims_2-fix-legacy.patch' && _patchmsg="Applied The Sims 2 fix (legacy)" && nonuser_patcher
	  fi
	fi

	# Python fix for <=3.18 (backported from zzhiyi's patches) - fix for python and needed for "The Sims 4" to work - replaces staging partial implementation - https://bugs.winehq.org/show_bug.cgi?id=44999
	if [ "$_318python_fix" == "true" ] && ! git merge-base --is-ancestor 3ebd2f0be30611e6cf00468c2980c5092f91b5b5 HEAD; then
	  _patchname='pythonfix.patch' && _patchmsg="Applied Python/The Sims 4 fix" && nonuser_patcher
	fi

	# Fix crashes or perf issues related to high core count setups - Fixed in 4.0 - https://bugs.winehq.org/show_bug.cgi?id=45453
	if [ "$_highcorecount_fix" == "true" ] && ! git merge-base --is-ancestor ed75a7b3443e79f9d63e97eeebcce2d2f40c507b HEAD; then
	  _patchname='high-core-count-fix.patch' && _patchmsg="Applied high core count fix" && nonuser_patcher
	fi

	# Workaround for Final Fantasy XIV Launcher 404 error - Thanks @varris1 !
	if [ "$_ffxivlauncher_fix" == "true" ] && ! git merge-base --is-ancestor d535df42f665a097ec721b10fb49d7b18f899be9 HEAD; then
	  _patchname='ffxiv-launcher-workaround.patch' && _patchmsg="Applied Final Fantasy XIV Launcher fix" && nonuser_patcher
	fi

	# Fix for LoL 9.10+ crashing - https://bugs.winehq.org/show_bug.cgi?id=47198
	if [ "$_lol910_fix" == "true" ]; then
	  if git merge-base --is-ancestor 944c4e8f760460ca6a260573d87c454052caad2c HEAD; then
	    _patchname='leagueoflolfix.patch' && _patchmsg="Applied LoL 9.10+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  else
	    _patchname='leagueoflolfix-944c4e8.patch' && _patchmsg="Applied LoL 9.10+ fix - Requires vdso32 disabled (echo 0 > /proc/sys/abi/vsyscall32)" && nonuser_patcher
	  fi
	fi

	# Fix for Assetto Corsa performance drop when HUD elements are displayed - https://bugs.winehq.org/show_bug.cgi?id=46955
	if [ "$_assettocorsa_hudperf_fix" == "true" ] && git merge-base --is-ancestor d19e34d8f072514cb903bda89767996ba078bae4 HEAD; then
	  _patchname='assettocorsa_hud_perf.patch' && _patchmsg="Applied Assetto Corsa HUD performance fix" && nonuser_patcher
	fi

	# apply wine-pba patchset
	if [ "$_use_pba" == "true" ]; then
	  if [ "$_pba_version" == "none" ]; then
	    echo "PBA disabled due to known issues with selected Wine version" >> "$_where"/last_build_config.log
	  else
	    _patchname="PBA${_pba_version}.patch" && _patchmsg="Using pba (${_pba_version}) patchset" && nonuser_patcher
	  fi
	fi

	# d3d9 patches
	if [ "$_use_legacy_gallium_nine" == "true" ] && [ "$_use_staging" == "true" ] && ! git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  wget -O "$_where"/wine-d3d9.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/wine-d3d9.patch
	  wget -O "$_where"/staging-helper.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/staging-helper.patch
	  patch -Np1 < "$_where"/staging-helper.patch
	  patch -Np1 < "$_where"/wine-d3d9.patch
	  autoreconf -f
	  _configure_args+=(--with-d3d9-nine)
	elif [ "$_use_legacy_gallium_nine" == "true" ] && [ "$_use_staging" != "true" ] && ! git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  wget -O "$_where"/wine-d3d9.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/wine-d3d9.patch
	  wget -O "$_where"/d3d9-helper.patch https://raw.githubusercontent.com/sarnex/wine-d3d9-patches/master/d3d9-helper.patch
	  patch -Np1 < "$_where"/d3d9-helper.patch
	  patch -Np1 < "$_where"/wine-d3d9.patch
	  autoreconf -f
	  _configure_args+=(--with-d3d9-nine)
	elif [ "$_use_legacy_gallium_nine" == "true" ] && git merge-base --is-ancestor e24b16247d156542b209ae1d08e2c366eee3071a HEAD; then
	  echo "Legacy Gallium Nine disabled due to known issues with selected Wine version" >> "$_where"/last_build_config.log
	fi

	# GLSL toggle patch - Allows for use of ARB instead of GLSL
	if [ "$_GLSL_toggle" == "true" ] && [ "$_use_staging" == "true" ] && [ "$_use_legacy_gallium_nine" != "true" ]; then
	  _patchname='GLSL-toggle.patch' && _patchmsg="Applied GLSL toggle patch" && nonuser_patcher
	fi

	# Set a custom fake refresh rate for virtual desktop and proton FS hack
	if [ -n "$_fake_refresh_rate" ]; then
	  sed -i "s/999999/$_fake_refresh_rate/g" "${_where}/virtual_desktop_refreshrate.patch"
	  sed -i "s/999999/$_fake_refresh_rate/g" "${_where}/proton_FS_hack_refreshrate.patch"
	  _patchname='virtual_desktop_refreshrate.patch' && _patchmsg="Applied custom fake virtual desktop refresh rate ($_fake_refresh_rate Hz) patch" && nonuser_patcher
	fi

	# fsync - experimental replacement for esync introduced with Proton 4.11-1
	if [ "$_use_fsync" == "true" ]; then
	  if [ "$_staging_esync" == "true" ] && git merge-base --is-ancestor 1d9a3f6d12322891a2af4aadd66a92ea66479233 HEAD; then
	    _patchname='fsync-staging.patch' && _patchmsg="Applied fsync, an experimental replacement for esync (staging)" && nonuser_patcher
	    if [ "$_proton_use_steamhelper" != "true" ]; then
	      _patchname='fsync-staging-no_alloc_handle.patch' && _patchmsg="Added no_alloc_handle object method to fsync" && nonuser_patcher
	    fi
	  elif [ "$_use_esync" == "true" ] && git merge-base --is-ancestor 29914d583fe098521472332687b8da69fc692690 HEAD; then
	    _patchname='fsync-mainline.patch' && _patchmsg="Applied fsync, an experimental replacement for esync" && nonuser_patcher
	  else
	    echo "Fsync forcefully disabled due to incompatible tree" >> "$_where"/last_build_config.log
	  fi
	fi

	# Proton Fullscreen patch - Allows resolution changes for fullscreen games without changing desktop resolution
	if [ "$_proton_fs_hack" == "true" ] && [ "$_use_staging" == "true" ]; then
	  if [ "$_FS_bypass_compositor" != "true" ]; then
	    _FS_bypass_compositor="true"
	    _patchname='FS_bypass_compositor.patch' && _patchmsg="Applied Fullscreen compositor bypass patch (force enabled because Proton fullscreen hack is enabled and needs it)" && nonuser_patcher
	  fi
	  cd "${srcdir}"/"${_stgsrcdir}"
	  if git merge-base --is-ancestor 734918298c4a6eb1cb23f31e21481f2ef58a0970 HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}" && _patchname='valve_proton_fullscreen_hack-staging.patch' && _patchmsg="Applied Proton fullscreen hack patch" && nonuser_patcher
	  elif git merge-base --is-ancestor 938dddf7df920396ac3b30a44768c1582d0c144f HEAD && [ "$_rawinput_fix" == "true" ] || ! git merge-base --is-ancestor fd3bb06a4c1102cf424bc78ead25ee440db1b0fa HEAD; then
	    cd "${srcdir}"/"${_winesrcdir}" && _patchname='raw-valve_proton_fullscreen_hack-staging.patch' && _patchmsg="Applied Proton fullscreen hack patch" && nonuser_patcher
	  else
	    cd "${srcdir}"/"${_winesrcdir}"
	    if git merge-base --is-ancestor de6450135de419ac7e64aee0c0efa27b60bea3e8 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-staging-938dddf.patch' && _patchmsg="Applied Proton fullscreen hack patch (<938dddf)" && nonuser_patcher
	    elif git merge-base --is-ancestor 82c6ec3a32f44e8b3e0cc88b7f10e0c0d7fa1b89 HEAD; then
	      _patchname='valve_proton_fullscreen_hack-staging-de64501.patch' && _patchmsg="Applied Proton fullscreen hack patch (<de64501)" && nonuser_patcher
	    else
	      cd "${srcdir}"/"${_stgsrcdir}"
	      if git merge-base --is-ancestor 7cc69d770780b8fb60fb249e007f1a777a03e51a HEAD; then
	        cd "${srcdir}"/"${_winesrcdir}" && _patchname='valve_proton_fullscreen_hack-staging-82c6ec3.patch' && _patchmsg="Applied Proton fullscreen hack patch (<82c6ec3)" && nonuser_patcher
	      else
	        cd "${srcdir}"/"${_winesrcdir}"
	        if git merge-base --is-ancestor 0cb79db12ac7c48477518dcff269ccc5d6b745e0 HEAD; then
	          _patchname='valve_proton_fullscreen_hack-staging-4.6.patch' && _patchmsg="Applied Proton fullscreen hack patch (for <=4.6)" && nonuser_patcher
	        elif git merge-base --is-ancestor a4b9460ad68bad6675f9e50b390503db9ef94d6b HEAD; then
	          _patchname='valve_proton_fullscreen_hack-staging-4.5-a4b9460.patch' && _patchmsg="Applied Proton fullscreen hack patch (for <=4.5-a4b9460)" && nonuser_patcher
	        elif git merge-base --is-ancestor 57bb5cce75aed1cb06172cc0b6b696dfb008e7c1 HEAD; then
	          _patchname='valve_proton_fullscreen_hack-staging-4.5.patch' && _patchmsg="Applied Proton fullscreen hack patch (for <=4.5)" && nonuser_patcher
	        elif git merge-base --is-ancestor 6e87235523f48d523285409dcbbd7885df9948d0 HEAD; then
	          _patchname='valve_proton_fullscreen_hack-staging-4.4.patch' && _patchmsg="Applied Proton fullscreen hack patch (for <=4.4)" && nonuser_patcher
	        else
	          _patchname='valve_proton_fullscreen_hack-staging-legacy.patch' && _patchmsg="Applied Proton fullscreen hack patch (legacy)" && nonuser_patcher
	        fi
	      fi
	    fi
	  fi
	  if [ -n "$_fake_refresh_rate" ]; then
	    _patchname='proton_FS_hack_refreshrate.patch' && _patchmsg="Applied custom fake proton FS hack refresh rate ($_fake_refresh_rate Hz) patch" && nonuser_patcher
	  else
	    _patchname='valve_proton_fullscreen_hack_realmodes.patch' && _patchmsg="Using real modes in FS hack" && nonuser_patcher
	  fi
	fi

	# Update winevulkan
	if [ "$_update_winevulkan" == "true" ] && git merge-base --is-ancestor ad82739dda15b44510f6003302f0ad17848a35a7 HEAD; then
	  if [ "$_proton_fs_hack" == "true" ] && [ "$_use_staging" == "true" ]; then
	    _patchname='winevulkan-1.1.113-proton.patch' && _patchmsg="Applied winevulkan 1.1.113 patch (proton edition)" && nonuser_patcher
	  else
	    _patchname='winevulkan-1.1.113.patch' && _patchmsg="Applied winevulkan 1.1.113 patch" && nonuser_patcher
	  fi
	fi

	# raw input fix by Guy1524 - part two
	if [ "$_rawinput_fix" == "true" ] && git merge-base --is-ancestor 4da1c4370be6515bf64c185e6b55a305247c754b HEAD; then
	  if [ "$_use_staging" == "true" ]; then
	    if [ "$_proton_fs_hack" == "true" ]; then
	      cd "${srcdir}"/"${_stgsrcdir}"
	      if git merge-base --is-ancestor 734918298c4a6eb1cb23f31e21481f2ef58a0970 HEAD; then
	        cd "${srcdir}"/"${_winesrcdir}" && _patchname='raw-input-proton.patch' && _patchmsg="Applied raw input fix" && nonuser_patcher
	      elif git merge-base --is-ancestor 7cc69d770780b8fb60fb249e007f1a777a03e51a HEAD && ! git merge-base --is-ancestor 938dddf7df920396ac3b30a44768c1582d0c144f HEAD; then
	        cd "${srcdir}"/"${_winesrcdir}" && _patchname='raw-input-proton-7349182.patch' && _patchmsg="Applied raw input fix" && nonuser_patcher
	      fi
	    fi
	    cd "${srcdir}"/"${_winesrcdir}"
	  else
	    _patchname='raw-input.patch' && _patchmsg="Applied raw input fix" && nonuser_patcher
	  fi
	fi

	# Overwatch mf crash fix from Guy1524 - https://bugs.winehq.org/show_bug.cgi?id=47385 - Fixed in b182ba88
	if [ "$_OW_fix" == "true" ] && git merge-base --is-ancestor 9bf4db1325d303a876bf282543289e15f9c698ad HEAD && ! git merge-base --is-ancestor b182ba882cfcce7b8769470f49f0fba216095c45 HEAD; then
	   _patchname='overwatch-mfstub.patch' && _patchmsg="Applied Overwatch mf crash fix" && nonuser_patcher
	fi

	# IMAGE_FILE_LARGE_ADDRESS_AWARE override - Enable with WINE_LARGE_ADDRESS_AWARE=1
	if [ "$_large_address_aware" == "true" ] && git merge-base --is-ancestor c998667bf0983ef99cc48847d3d6fc6ca6ff4a2d HEAD && ! git merge-base --is-ancestor 9f0d66923933d82ae0b09fe5d84f977c1a657cc1 HEAD; then
	  if [ "$_use_staging" == "true" ]; then
	    _patchname='LAA-staging-legacy.patch' && _patchmsg="Applied large address aware override support (legacy)" && nonuser_patcher
	  else
	    _patchname='LAA-legacy.patch' && _patchmsg="Applied large address aware override support (legacy)" && nonuser_patcher
	  fi
	elif [ "$_large_address_aware" == "true" ] && git merge-base --is-ancestor 9f0d66923933d82ae0b09fe5d84f977c1a657cc1 HEAD; then
	  if [ "$_use_staging" == "true" ]; then
	    _patchname='LAA-staging.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	  else
	    _patchname='LAA.patch' && _patchmsg="Applied large address aware override support" && nonuser_patcher
	  fi
	fi

	# Workarounds to prevent crashes on some mf functions
	if [ "$_use_staging" == "true" ] && [ "$_proton_mf_hacks" == "true" ] && git merge-base --is-ancestor b182ba882cfcce7b8769470f49f0fba216095c45 HEAD; then
	  _patchname='proton_mf_hacks.patch' && _patchmsg="Applied proton mf hacks patch" && nonuser_patcher
	fi

	# Enable STAGING_SHARED_MEMORY by default - https://wiki.winehq.org/Wine-Staging_Environment_Variables#Shared_Memory
	if [ "$_stg_shared_mem_default" == "true" ] && [ "$_use_staging" == "true" ]; then
	  _patchname='enable_stg_shared_mem_def.patch' && _patchmsg="Enable STAGING_SHARED_MEMORY by default" && nonuser_patcher
	fi

	# Nvidia hate - Prevents building of nvapi/nvapi64, nvcuda, nvcuvid and nvencodeapi/nvencodeapi64 libs
	if [ "$_nvidia_hate" == "true" ]; then
	  _patchname='nvidia-hate.patch' && _patchmsg="Hatin' on novideo" && nonuser_patcher
	fi

	if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" == "proton" ]; then
	  if git merge-base --is-ancestor 0bebbbaa51c7647389ef9ac886169f6037356460 HEAD; then
	    if [ "$_use_staging" == "true" ]; then
	      _patchname='proton-tkg-staging.patch' && _patchmsg="Using Steam-specific Proton-tkg patches (staging)" && nonuser_patcher
	    else
	      _patchname='proton-tkg.patch' && _patchmsg="Using Steam-specific Proton-tkg patches" && nonuser_patcher
	    fi
	  else
	    if git merge-base --is-ancestor 05d00276c627753487c571c30fddfc56c02ad37e HEAD; then
	      _lastcommit="0bebbba"
	    elif git merge-base --is-ancestor 09f588ee6909369b541398dd392d3ff77231e6a6 HEAD; then
	      _lastcommit="05d0027"
	    elif git merge-base --is-ancestor 0116660dd80b38da8201e2156adade67fc2ae823 HEAD; then
	      _lastcommit="09f588e"
	    elif git merge-base --is-ancestor eafb4aff5a2c322f4f156fdfada5743834996be4 HEAD; then
	      _lastcommit="0116660"
	    else
	      _lastcommit="eafb4af"
        fi
	    if [ "$_use_staging" == "true" ]; then
	      _patchname="proton-tkg-staging-$_lastcommit.patch" && _patchmsg="Using Steam-specific Proton-tkg patches (staging-$_lastcommit)" && nonuser_patcher
	    else
	      _patchname="proton-tkg-$_lastcommit.patch" && _patchmsg="Using Steam-specific Proton-tkg patches ($_lastcommit)" && nonuser_patcher
	    fi
	  fi
	  # Enforce mscvrt Dlls to native then builtin - from Proton
	  if [ "$_msvcrt_nativebuiltin" == "true" ]; then
	    if git merge-base --is-ancestor eafb4aff5a2c322f4f156fdfada5743834996be4 HEAD; then
	      _patchname='msvcrt_nativebuiltin.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    else
	      _patchname='msvcrt_nativebuiltin-eafb4aff.patch' && _patchmsg="Enforce msvcrt Dlls to native then builtin (from Proton)" && nonuser_patcher
	    fi
	  fi
	  # SDL Joystick support - from Proton
	  if [ "$_sdl_joy_support" == "true" ]; then
	    _patchname='proton-sdl-joy.patch' && _patchmsg="Enable SDL Joystick support (from Proton)" && nonuser_patcher
	    if git merge-base --is-ancestor 1daeef73325e9d35073231baf874600050126c7f HEAD; then
	      _patchname='proton-sdl-joy-2.patch' && _patchmsg="Enable SDL Joystick support additions (from Proton)" && nonuser_patcher
	    fi
	    # Gamepad additions - from Proton
	    if [ "$_gamepad_additions" == "true" ] && [ "$_use_staging" == "true" ]; then
	      cd "${srcdir}"/"${_stgsrcdir}"
	      if git merge-base --is-ancestor fcfeaf092cf9e8060223744f507395946554fe09 HEAD; then
	        cd "${srcdir}"/"${_winesrcdir}"
	        _patchname='proton-gamepad-additions.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	      else
	        cd "${srcdir}"/"${_winesrcdir}"
	        if git merge-base --is-ancestor d2d3959d3d29b3da334b53283b34cafde653b3e8 HEAD; then
	          _patchname='proton-gamepad-additions-fcfeaf0.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	        else
	          cd "${srcdir}"/"${_stgsrcdir}"
	          if git merge-base --is-ancestor 4413770af102ed80f9c5c19a9148ab32d3dc1a0f HEAD; then
	            cd "${srcdir}"/"${_winesrcdir}"
	            _patchname='proton-gamepad-additions-d2d3959.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	          else
	            cd "${srcdir}"/"${_winesrcdir}"
	            if git merge-base --is-ancestor 9c6ea019358eadcf86159872e2890ffc94960965 HEAD; then
	              _patchname='proton-gamepad-additions-4413770.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	            elif git merge-base --is-ancestor f8a04c7f2e2c77eef663c5bb2109e3dbd51b22e0 HEAD; then
	              _patchname='proton-gamepad-additions-9c6ea01.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	            elif git merge-base --is-ancestor 3d011fcdffe39ae856cbb0915938fe158b60742a HEAD; then
	              _patchname='proton-gamepad-additions-f8a04c7.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	            elif git merge-base --is-ancestor 50b9456e878f57d8c850282d77e74534c57a181e HEAD; then
	              _patchname='proton-gamepad-additions-3d011fc.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
	            elif git merge-base --is-ancestor 6a610a325809d47f48bc72f3a757e1a62b193ea8 HEAD; then
	              _patchname='proton-gamepad-additions-50b9456.patch' && _patchmsg="Enable xinput hacks and other gamepad additions (from Proton)" && nonuser_patcher
                fi
              fi
            fi
          fi
        fi
	  fi
	  if git merge-base --is-ancestor 0ffb1535517301d28c7c004eac639a9a0cc26c00 HEAD; then
	    _patchname='proton-restore-unicode.patch' && _patchmsg="Restore installing wine/unicode.h to please Proton" && nonuser_patcher
	  fi
	  if git merge-base --is-ancestor 3e4189e3ada939ff3873c6d76b17fb4b858330a8 HEAD && [ "$_proton_fs_hack" == "true" ] && [ "$_use_staging" == "true" ]; then
	    _patchname='proton-vk-bits-4.5.patch' && _patchmsg="Enable Proton vulkan bits for 4.5+" && nonuser_patcher
	  fi
	  if [ "$_wined3d_additions" == "true" ] && [ "$_use_staging" == "false" ]; then
	    _patchname='proton-wined3d-additions.patch' && _patchmsg="Enable Proton non-vr-related wined3d additions" && nonuser_patcher
	  fi
	fi

	# wine user patches
	if [ "$_user_patches" == "true" ]; then
	  _userpatch_target="plain-wine"
	  _userpatch_ext="my"
	  hotfixer
	  user_patcher
	fi

	echo "" >> "$_where"/last_build_config.log

	if [ "$_use_staging" == "true" ] && [ "$_LOCAL_PRESET" != "staging" ]; then
	  _patchname='wine-tkg-staging.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Tk-Glitch/PKGBUILDS/issues instead." && nonuser_patcher
	elif [ "$_use_staging" != "true" ] && [ "$_LOCAL_PRESET" != "mainline" ]; then
	  _patchname='wine-tkg.patch' && _patchmsg="Please don't report bugs about this wine build on winehq.org and use https://github.com/Tk-Glitch/PKGBUILDS/issues instead." && nonuser_patcher
	fi

	tools/make_requests

	# Disable tests by default, enable back with _enable_tests="true"
	if [ "$_ENABLE_TESTS" != "true" ]; then
	  _configure_args+=(--disable-tests)
	fi

	# Set custom version so that it reports the same as pkgver
	sed -i "s/GIT_DIR=\$(top_srcdir)\\/.git git describe HEAD 2>\\/dev\\/null || echo \"wine-\$(PACKAGE_VERSION)\"/echo \"wine-$_realwineversion\"/g" "${srcdir}"/"${_winesrcdir}"/libs/wine/Makefile.in

	# Set custom version tags
	local _version_tags=()
	_version_tags+=(TkG) # watermark to keep track of TkG builds independently of the settings
	if [ "$_use_staging" == "true" ]; then
	  _version_tags+=(Staging)
	else
	  _version_tags+=(Plain)
	fi
	if [ "$_use_esync" == "true" ] || [ "$_staging_esync" == "true" ]; then
	  _version_tags+=(Esync)
	fi
	if [ "$_use_fsync" == "true" ] && [ "$_staging_esync" == "true" ]; then
	  _version_tags+=(Fsync)
	fi
	if [ "$_use_pba" == "true" ] && [ "$_pba_version" != "none" ]; then
	  _version_tags+=(PBA)
	fi
	if [ "$_use_legacy_gallium_nine" == "true" ]; then
	  _version_tags+=(Nine)
	fi
	if [ "$_use_vkd3d" == "true" ]; then
	  _version_tags+=(Vkd3d)
	fi
	sed -i "s/\\\1/\\\1  ( ${_version_tags[*]} )/g" "${srcdir}"/"${_winesrcdir}"/libs/wine/Makefile.in

	# fix path of opencl headers
	sed 's|OpenCL/opencl.h|CL/opencl.h|g' -i configure*

	if [ "$_NUKR" != "debug" ]; then
	  # delete old build dirs (from previous builds)
	  rm -rf "${srcdir}"/wine-tkg-*-{32,64}-build
	elif [ $(git log -1 --pretty=%B | grep -c "wine-tkg patches") = 0 ]; then
	  git add .
	  git commit -m "wine-tkg patches"
	fi

	# no compilation
	if [ "$_NOCOMPILE" == "true" ]; then
	  cp "$_where"/last_build_config.log "${srcdir}"/"${_winesrcdir}"/wine-tkg-config.txt
	  msg2 'make prepare function fail by using Gandalf'
	  YOU_SHALL_NOT_PASS
	fi

	# Nuke if present then create new build dirs
	if [ "$_NUKR" == "true" ]; then
	  rm -rf "${srcdir}"/"${pkgname}"-64-build
	  rm -rf "${srcdir}"/"${pkgname}"-32-build
	fi
	mkdir -p "${srcdir}"/"${pkgname}"-64-build
	mkdir -p "${srcdir}"/"${pkgname}"-32-build

	cd "$_where" # this is needed on version update not to get lost in srcdir
}

# Workaround
trap _exit_cleanup EXIT
