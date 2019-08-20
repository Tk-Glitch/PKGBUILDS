#!/bin/bash

# This script replaces the wine-tkg PKGBUILD's function for use outside of makepkg or on non-pacman distros

# Created by: Tk-Glitch <ti3nou at gmail dot com>

pkgname=wine-tkg-git

_stgsrcdir='wine-staging-git'
_esyncsrcdir='esync'
_where=$PWD # track basedir as different Arch based distros are moving srcdir around

# set srcdir, Arch style
mkdir -p "$_where"/src
srcdir="$_where"/src

# use msg2, error and pkgver funcs for compat
msg2() {
 echo -e " \033[1;34m->\033[1;0m \033[1;1m$1\033[1;0m" >&2
}
error() {
 echo -e " \033[1;31m->\033[1;0m \033[1;1m$1\033[1;0m" >&2
}
pkgver() {
	if [ "$_use_staging" == "true" ]; then
	  cd "${srcdir}/${_stgsrcdir}"
	else
	  cd "${srcdir}/${_winesrcdir}"
	fi

	# retrieve current wine version - if staging is enabled, staging version will be used instead
	_describe_wine
}

  # load functions
  source "$_where"/wine-tkg-scripts/prepare.sh
  source "$_where"/wine-tkg-scripts/build.sh

# init step
  _init

  # this script makes external builds already and we don't want the specific pacman-related stuff to interfere, so enforce _EXTERNAL_INSTALL="false" when not building proton-tkg
  if [ "$_EXTERNAL_INSTALL" == "true" ] && [ "$_EXTERNAL_INSTALL_TYPE" != "proton" ]; then
    _EXTERNAL_INSTALL="false"
  fi

  _pkgnaming
# init step end

  # Wine source
  if [ "$_plain_mirrorsrc" == "true" ]; then
    _winesrcdir="wine-mirror-git"
    _winesrctarget="https://github.com/wine-mirror/wine.git"
  else
    _winesrcdir="wine-git"
    _winesrctarget="git://source.winehq.org/git/wine.git"
  fi

  find "$_where"/wine-tkg-patches -type f -not -path "*hotfixes*" -exec cp -n {} "$_where" \; # copy patches inside the PKGBUILD's dir to preserve makepkg sourcing and md5sum checking
  cp "$_where"/wine-tkg-userpatches/*.my* "$_where" 2>/dev/null # copy userpatches inside the PKGBUILD's dir

  # Wine source
  cd "$srcdir"
  git clone "${_winesrctarget}" $_winesrcdir

  if [ -n "$_plain_version" ]; then
    cd $_winesrcdir && git checkout ${_plain_version}
    cd "$srcdir"
  fi

  # Wine staging source
  if [ "$_use_staging" == "true" ]; then
    git clone https://github.com/wine-staging/wine-staging.git $_stgsrcdir

    if [ -n "$_staging_version" ]; then
      cd $_stgsrcdir && git checkout ${_staging_version}
      cd "$srcdir"
    fi
  fi

nonuser_patcher() {
  if [ "$_NUKR" != "debug" ] || [ "$_DEBUGANSW1" == "y" ]; then
    msg2 "Applying ${_patchname}" && patch -Np1 < "$_where"/"$_patchname" && echo "${_patchmsg}" >> "$_where"/last_build_config.log
  fi
}

build_wine_tkg() {

  pkgver=$(pkgver)

  ## prepare step
  cd "$srcdir"
  # state tracker start - FEAR THE MIGHTY FROG MINER
  touch "${_where}"/BIG_UGLY_FROGMINER

  # mingw-w64-gcc
  if [ "$_NOMINGW" == "true" ]; then
    _configure_args+=(--without-mingw)
  fi

  _prepare
  ## prepare step end

  _build

  _package
}

build_wine_tkg

trap _exit_cleanup EXIT
