#!/bin/bash

# Created by: Tk-Glitch <ti3nou at gmail dot com>

# This script creates Steamplay compatible wine builds based on wine-tkg-git and additional proton patches and libraries.
# It is not standalone and can be considered an addon to wine-tkg-git PKGBUILD and patchsets.

# You can use the uninstall feature by calling the script with "clean" as argument : ./proton-tkg.sh clean

set -e

_nowhere=$PWD
_wine_tkg_git_path="${_nowhere}/../wine-tkg-git" # Change to wine-tkg-git path if needed

# Make sure we're not using proton_3.7 /s
_proton_branch="proton_4.2"

cat <<'EOF'
       .---.`               `.---.
    `/syhhhyso-           -osyhhhys/`
   .syNMdhNNhss/``.---.``/sshNNhdMNys.
   +sdMh.`+MNsssssssssssssssNM+`.hMds+
   :syNNdhNNhssssssssssssssshNNhdNNys:
    /ssyhhhysssssssssssssssssyhhhyss/
    .ossssssssssssssssssssssssssssso.
   :sssssssssssssssssssssssssssssssss:
  /sssssssssssssssssssssssssssssssssss/
 :sssssssssssssoosssssssoosssssssssssss:
 osssssssssssssoosssssssoossssssssssssso
 osssssssssssyyyyhhhhhhhyyyyssssssssssso
 /yyyyyyhhdmmmmNNNNNNNNNNNmmmmdhhyyyyyy/
  smmmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmmms
   /dNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNd/
    `:sdNNNNNNNNNNNNNNNNNNNNNNNNNds:`
       `-+shdNNNNNNNNNNNNNNNdhs+-`
             `.-:///////:-.`
 ______              __                      __   __
|   __ \.----.-----.|  |_.-----.-----.______|  |_|  |--.-----.
|    __/|   _|  _  ||   _|  _  |     |______|   _|    <|  _  |
|___|   |__| |_____||____|_____|__|__|      |____|__|__|___  |
                                                       |_____|

Also known as "Some kind of build wrapper for wine-tkg-git"

EOF

function steam_is_running {
  if pgrep -x steam >/dev/null; then
    echo "###################################################"
    echo ""
    echo " Steam is running. Please full close it to proceed."
    echo ""
    echo "###################################################"
    echo ""
    read -rp "Press enter when ready..."
    steam_is_running
  fi
}

function proton_tkg_uninstaller {
  # Never cross the Proton streams!
  i=0
  for _proton_tkg in "$HOME/.steam/root/compatibilitytools.d"/proton_tkg_*; do
    if [ -d "$_proton_tkg" ]; then
      _GOTCHA="$_proton_tkg" && ((i+=1))
    fi
  done

  if [ -d "$_GOTCHA" ] && [ $i -ge 2 ]; then
    cd "$HOME/.steam/root/compatibilitytools.d"

    _available_builds=( `ls -d proton_tkg_* | sort -V` )
    _strip_builds="${_available_builds[@]//proton_tkg_/}"
    _config_file="$HOME/.local/share/Steam/config/config.vdf"

    cp $_config_file $_config_file.bak && echo "Your config.vdf file was backed up from $_config_file (.bak)" && echo ""

    steam_is_running

    echo "What Proton-tkg build do you want to uninstall?"

    i=1
    for build in ${_strip_builds[@]}; do
      echo "  $i - $build" && ((i+=1))
    done

    read -rp "choice [1-$(($i-1))]: " _to_uninstall;

    i=1
    for build in ${_strip_builds[@]}; do
      if [ "$_to_uninstall" == "$i" ]; then
        rm -rf "proton_tkg_$build" && _available_builds=( `ls -d proton_tkg_* | sort -V` ) && _newest_build="${_available_builds[-1]//proton_tkg_/}" && sed -i "s/\"Proton-tkg $build\"/\"Proton-tkg ${_newest_build[@]}\"/" $_config_file
        echo "###########################################################################################################################"
        echo ""
        echo "Proton-tkg $build was uninstalled and games previously depending on it will now use Proton-tkg ${_newest_build[@]} instead."
        echo ""
        echo "###########################################################################################################################"
      fi
      ((i+=1))
    done

    echo ""
    read -rp "Wanna uninstall more? N/y: " _uninstall_more;
    echo ""
    if [ "$_uninstall_more" == "y" ]; then
      proton_tkg_uninstaller
    fi
  elif [ -d "$_GOTCHA" ] && [ $i -eq 1 ]; then
    echo "This tool requires at least two Proton-tkg builds installed in $HOME/.steam/root/compatibilitytools.d/ and only one was found."
  else
    echo "No Proton-tkg installation found in $HOME/.steam/root/compatibilitytools.d/"
  fi
}

if [ "$1" == "clean" ]; then
  proton_tkg_uninstaller
else
  rm -rf "$_nowhere"/proton_dist_tmp

  cd "$_nowhere"

  if [ ! -d "$_nowhere"/dxvk ]; then
    echo "##########################################################################################"
    echo ""
    echo " DXVK is missing in your proton-tkg dir. Downloading latest release from github for you..."
    echo " If you have asked for a winelib build, don't worry, you'll get a winelib build."
    echo ""
    echo "##########################################################################################"
    echo ""
    curl -s https://api.github.com/repos/doitsujin/dxvk/releases/latest \
    | grep "browser_download_url.*tar.gz" \
    | cut -d : -f 2,3 \
    | tr -d \" \
    | wget -qi -
    #mkdir dxvk
    tar -xvf dxvk-*.tar.gz >/dev/null 2>&1
    rm dxvk-*.tar.gz
    mv "$_nowhere"/dxvk-* "$_nowhere"/dxvk
  fi

  # We'll need a token to register to wine-tkg-git - keep one for us to steal wine-tkg-git options later
  echo "_proton_tkg_path='${_nowhere}'" > proton_tkg_token && cp proton_tkg_token "$_wine_tkg_git_path"/

  # Now let's build
  cd "$_wine_tkg_git_path"
  makepkg -s || true

  # Wine-tkg-git has injected versioning and settings in the token for us, so get the values back
  source "$_nowhere/proton_tkg_token"

  # Copy the resulting package in here to begin our work
  if [ -e "$_proton_pkgdest"/../HL3_confirmed ]; then

    cd $_nowhere

    # Create required dirs and clean
    mkdir -p "$HOME/.steam/root/compatibilitytools.d"
    rm -rf "proton_tkg_$_protontkg_version" && mkdir "proton_tkg_$_protontkg_version"
    mkdir -p proton_template/share/fonts

    mv "$_proton_pkgdest" proton_dist_tmp

    # Liberation Fonts
    rm -f proton_template/share/fonts/*
    git clone https://github.com/liberationfonts/liberation-fonts.git || true # It'll complain the path already exists on subsequent builds
    cd liberation-fonts
    git reset --hard 9510ebd
    git clean -xdf
    #git pull
    patch -Np1 < "$_nowhere/proton_template/LiberationMono-Regular.patch"
    make
    cp -rv liberation-fonts-ttf*/Liberation{Sans-Regular,Sans-Bold,Serif-Regular,Mono-Regular}.ttf "$_nowhere/proton_template/share/fonts"/
    cd "$_nowhere"

    # Clone Proton tree as we need to build some tools from it
    git clone https://github.com/ValveSoftware/Proton || true # It'll complain the path already exists on subsequent builds
    cd Proton
    git checkout "$_proton_branch"
    git reset --hard HEAD
    git clean -xdf
    git pull

    # Embed fake data to spoof desired fonts
    fontforge -script "$_nowhere/Proton/fonts/scripts/generatefont.pe" "$_nowhere/proton_template/share/fonts/LiberationSans-Regular" "Arial" "Arial" "Arial"
    fontforge -script "$_nowhere/Proton/fonts/scripts/generatefont.pe" "$_nowhere/proton_template/share/fonts/LiberationSans-Bold" "Arial-Bold" "Arial" "Arial Bold"
    fontforge -script "$_nowhere/Proton/fonts/scripts/generatefont.pe" "$_nowhere/proton_template/share/fonts/LiberationSerif-Regular" "TimesNewRoman" "Times New Roman" "Times New Roman"
    fontforge -script "$_nowhere/Proton/fonts/scripts/generatefont.pe" "$_nowhere/proton_template/share/fonts/LiberationMono-Regular" "CourierNew" "Courier New" "Courier New"

    # Grab share template and inject version
    echo "1552061114 proton-tkg-$_protontkg_version" > "$_nowhere/proton_dist_tmp/version" && cp -r "$_nowhere/proton_template/share"/* "$_nowhere/proton_dist_tmp/share"/

    # Build lsteamclient libs
    export WINEMAKERFLAGS="--nosource-fix --nolower-include --nodlls --nomsvcrt --dll -I$_nowhere/proton_dist_tmp/include/wine/windows/ -I$_nowhere/proton_dist_tmp/include/"
    export CFLAGS="-O2 -g"
    export CXXFLAGS="-fpermissive -Wno-attributes -O2 -g"
    export PATH="$_nowhere"/proton_dist_tmp/bin:$PATH

    mkdir -p build/lsteamclient.win64
    mkdir -p build/lsteamclient.win32

    cp -a lsteamclient/* build/lsteamclient.win64
    cp -a lsteamclient/* build/lsteamclient.win32

    cd build/lsteamclient.win64
    winemaker $WINEMAKERFLAGS -DSTEAM_API_EXPORTS -L"$_nowhere/proton_dist_tmp/lib64/" -L"$_nowhere/proton_dist_tmp/lib64/wine/" .
    make -C "$_nowhere/Proton/build/lsteamclient.win64" && strip lsteamclient.dll.so
    cd ../..

    cd build/lsteamclient.win32
    winemaker $WINEMAKERFLAGS --wine32 -DSTEAM_API_EXPORTS -L"$_nowhere/proton_dist_tmp/lib/" -L"$_nowhere/proton_dist_tmp/lib/wine/" .
    make -e CC="winegcc -m32" CXX="wineg++ -m32" -C "$_nowhere/Proton/build/lsteamclient.win32" && strip lsteamclient.dll.so
    cd $_nowhere

    # Inject lsteamclient libs in our wine-tkg-git build
    cp -v Proton/build/lsteamclient.win64/lsteamclient.dll.so proton_dist_tmp/lib64/wine/
    cp -v Proton/build/lsteamclient.win32/lsteamclient.dll.so proton_dist_tmp/lib/wine/

    # Build steam helper
    if [[ $_proton_branch == proton_4.* ]]; then
      mkdir -p Proton/build/steam.win32
      cp -a Proton/steam_helper/* Proton/build/steam.win32
      cd Proton/build/steam.win32

      export WINEMAKERFLAGS="--nosource-fix --nolower-include --nodlls --nomsvcrt --wine32 -I$_nowhere/proton_dist_tmp/include/wine/windows/ -I$_nowhere/proton_dist_tmp/include/ -L$_nowhere/proton_dist_tmp/lib/ -L$_nowhere/proton_dist_tmp/lib/wine/"

      winemaker $WINEMAKERFLAGS --guiexe -lsteam_api -I"$_nowhere/Proton/build/lsteamclient.win32/steamworks_sdk_142/" -L"$_nowhere/Proton/steam_helper" .
      make -e CC="winegcc -m32" CXX="wineg++ -m32" -C "$_nowhere/Proton/build/steam.win32" && strip steam.exe.so
      cd $_nowhere

      # Inject steam helper winelib and libsteam_api lib in our wine-tkg-git build
      cp -v Proton/build/steam.win32/steam.exe.so proton_dist_tmp/lib/wine/
      cp -v Proton/build/steam.win32/libsteam_api.so proton_dist_tmp/lib/
    fi

    # If the token gave us _prebuilt_dxvk, try to build with it - See dir hierarchy below(or in readme) if you aren't building using dxvk-tools
    if [ "$_use_dxvk" == "prebuilt" ] || [ "$_use_dxvk" == "release" ]; then
      if [ -d "$_nowhere"/dxvk ]; then
        mkdir -p proton_dist_tmp/lib64/wine/dxvk && cp -v dxvk/x64/* proton_dist_tmp/lib64/wine/dxvk/
        mkdir -p proton_dist_tmp/lib/wine/dxvk && cp -v dxvk/x32/* proton_dist_tmp/lib/wine/dxvk/
      else
        echo "##################################################################################"
        echo ""
        echo " Your config file is set up to include prebuilt DXVK, but it seems to be missing !"
        echo " Please verify that your DXVK dlls are present in the ./dxvk dir"
        echo " See the readme for more details on how to setup DXVK for proton-tkg"
        echo ""
        echo "##################################################################################" && exit 1
      fi
    fi

    # If user asked for DXVK release, clean for next time
    if [ "$_use_dxvk" == "release" ]; then
      rm -rf "$_nowhere"/dxvk
    fi

    # If the token gave us prebuilt d9vk, try to build with it - See dir hierarchy below(or in readme) if you aren't building using dxvk-tools
    if [ "$_use_d9vk" == "prebuilt" ]; then
      if [ -d "$_nowhere"/d9vk ]; then
        mkdir -p proton_dist_tmp/lib64/wine/d9vk && cp -v d9vk/x64/d3d9.dll proton_dist_tmp/lib64/wine/d9vk/
        mkdir -p proton_dist_tmp/lib/wine/d9vk && cp -v d9vk/x32/d3d9.dll proton_dist_tmp/lib/wine/d9vk/
      else
        echo "##################################################################################"
        echo ""
        echo " Your config file is set up to include prebuilt D9VK, but it seems to be missing !"
        echo " Please verify that your D9VK dlls are present in the ./d9vk dir"
        echo " See the readme for more details on how to setup D9VK for proton-tkg"
        echo ""
        echo "##################################################################################" && exit 1
      fi
    fi

    echo ''
    echo "Packaging..."

    # Package
    cd proton_dist_tmp && tar -zcf proton_dist.tar.gz bin/ include/ lib64/ lib/ share/ version && mv proton_dist.tar.gz ../"proton_tkg_$_protontkg_version"
    cd "$_nowhere" && rm -rf proton_dist_tmp

    # Grab conf template and inject version
    echo "1552061114 proton-tkg-$_protontkg_version" > "proton_tkg_$_protontkg_version/version" && cp "proton_template/conf"/* "proton_tkg_$_protontkg_version"/ && sed -i -e "s|TKGVERSION|$_protontkg_version|" "proton_tkg_$_protontkg_version/compatibilitytool.vdf"

    # Patch our proton script to make use of the steam helper on 4.0+
    if [[ $_proton_branch == proton_4.* ]] && [ "$_proton_use_steamhelper" == "true" ]; then
      cd "$_nowhere/proton_tkg_$_protontkg_version"
      patch -Np1 < "$_nowhere/proton_template/steam.exe.patch" && rm -f proton.orig
      cd "$_nowhere"
    fi

    # Set Proton-tkg user_settings.py defaults
    if [ "$_proton_nvapi_disable" == "true" ]; then
      sed -i 's/.*PROTON_NVAPI_DISABLE.*/     "PROTON_NVAPI_DISABLE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_NVAPI_DISABLE.*/#     "PROTON_NVAPI_DISABLE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_proton_winedbg_disable" == "true" ]; then
      sed -i 's/.*PROTON_WINEDBG_DISABLE.*/     "PROTON_WINEDBG_DISABLE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_WINEDBG_DISABLE.*/#     "PROTON_WINEDBG_DISABLE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_proton_force_LAA" == "true" ]; then
      sed -i 's/.*PROTON_FORCE_LARGE_ADDRESS_AWARE.*/     "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_FORCE_LARGE_ADDRESS_AWARE.*/#     "PROTON_FORCE_LARGE_ADDRESS_AWARE": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_proton_pulse_lowlat" == "true" ]; then
      sed -i 's/.*PROTON_PULSE_LOWLATENCY.*/     "PROTON_PULSE_LOWLATENCY": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_PULSE_LOWLATENCY.*/#     "PROTON_PULSE_LOWLATENCY": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_proton_dxvk_async" == "true" ]; then
      sed -i 's/.*PROTON_DXVK_ASYNC.*/     "PROTON_DXVK_ASYNC": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_DXVK_ASYNC.*/#     "PROTON_DXVK_ASYNC": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_proton_winetricks" == "true" ]; then
      sed -i 's/.*PROTON_WINETRICKS.*/     "PROTON_WINETRICKS": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    else
      sed -i 's/.*PROTON_WINETRICKS.*/#     "PROTON_WINETRICKS": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ -n "$_proton_dxvk_configfile" ]; then
      sed -i "s|.*DXVK_CONFIG_FILE.*|     \"DXVK_CONFIG_FILE\": \"${_proton_dxvk_configfile}\",|g" "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ -n "$_proton_dxvk_hud" ]; then
      sed -i "s|.*DXVK_HUD.*|     \"DXVK_HUD\": \"${_proton_dxvk_hud}\",|g" "proton_tkg_$_protontkg_version/user_settings.py"
    fi
    if [ "$_use_dxvk" == "true" ] && [ "$_dxvk_dxgi" != "true" ]; then
      sed -i 's/.*PROTON_USE_WINE_DXGI.*/     "PROTON_USE_WINE_DXGI": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi

    # Use the corresponding DXVK/D9VK combo options - Default is DXVK prebuilt +no d9vk or d9vk winelib, so let's create rules for the other combinations only
    # ("true" = "winelib")
    if [ "$_use_dxvk" == "true" ] && [ "$_use_d9vk" == "true" ]; then
      sed -i 's/.*PROTON_USE_WINED3D9.*/     "PROTON_USE_WINED3D9": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
      sed -i 's/.*PROTON_USE_WINED3D11.*/     "PROTON_USE_WINED3D11": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    elif [ "$_use_dxvk" == "true" ] && [ "$_use_d9vk" == "prebuilt" ]; then
      sed -i 's/.*PROTON_USE_WINED3D9.*/#     "PROTON_USE_WINED3D9": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
      sed -i 's/.*PROTON_USE_WINED3D11.*/     "PROTON_USE_WINED3D11": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    elif [ "$_use_dxvk" == "prebuilt" ] && [ "$_use_d9vk" == "prebuilt" ]; then
      sed -i 's/.*PROTON_USE_WINED3D9.*/#     "PROTON_USE_WINED3D9": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
      sed -i 's/.*PROTON_USE_WINED3D11.*/#     "PROTON_USE_WINED3D11": "1",/g' "proton_tkg_$_protontkg_version/user_settings.py"
    fi

    cd $_nowhere

    # Nuke same version if exists before copying new build
    if [ -e "$HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version" ]; then
      rm -rf "$HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version"
    fi

    # Get rid of the token
    rm proton_tkg_token

    mv "proton_tkg_$_protontkg_version" "$HOME/.steam/root/compatibilitytools.d"/ && echo "" &&
    echo "####################################################################################################"
    echo ""
    echo " Proton-tkg build installed to $HOME/.steam/root/compatibilitytools.d/proton_tkg_$_protontkg_version"
    echo ""
    echo "####################################################################################################"
    echo ""
    read -rp "Do you want to run the uninstaller to remove previous/superfluous builds? N/y: " _ask_uninstall;
    if [ "$_ask_uninstall" == "y" ]; then
      proton_tkg_uninstaller
    fi
  else
    rm $_nowhere/proton_tkg_token
    echo "The required initial proton_dist build is missing! Wine-tkg-git compilation may have failed."
  fi

fi
