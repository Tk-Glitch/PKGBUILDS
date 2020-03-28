# Based on AUR's llvm-git:
# Maintainer: Lone_Wolf <lonewolf@xs4all.nl>
# Contributor: yurikoles <root@yurikoles.com>
# Contributor: bearoso <bearoso@gmail.com>
# Contributor: Luchesar V. ILIEV <luchesar%2eiliev%40gmail%2ecom>
# Contributor: Anders Bergh <anders@archlinuxppc.org>
# Contributor: Armin K. <krejzi at email dot com>
# Contributor: Christian Babeux <christian.babeux@0x80.ca>
# Contributor: Jan "heftig" Steffens <jan.steffens@gmail.com>
# Contributor: Evangelos Foutras <evangelos@foutrelis.com>
# Contributor: Hesiod (https://github.com/hesiod)
# Contributor: Roberto Alsina <ralsina@kde.org>
# Contributor: Thomas Dziedzic < gostrc at gmail >
# Contributor: Tomas Lindquist Olsen <tomas@famolsen.dk>
# Contributor: Tomas Wilhelmsson <tomas.wilhelmsson@gmail.com>

# Contributor: Tk-Glitch <ti3nou@gmail.com>
# Multilib and provides llvm - Initially made for chaotic-aur

# Set to true to disable checks
_nocheck="false"

pkgname=('llvm-git' 'llvm-libs-git' 'llvm-ocaml-git' 'lib32-llvm-git' 'lib32-llvm-libs-git')
pkgver=11.0.0_r346458.190df4a5bc2
pkgrel=1
arch=('x86_64')
url="https://llvm.org/"
license=('custom:Apache 2.0 with LLVM Exception')
makedepends=('git' 'cmake' 'ninja' 'libffi' 'libedit' 'ncurses' 'libxml2' 'python-sphinx'
             'ocaml' 'ocaml-ctypes' 'ocaml-findlib' 'python-sphinx' 'python-recommonmark'
             'swig' 'python' 'lib32-gcc-libs' 'lib32-libffi' 'lib32-libxml2' 'lib32-zlib')

source=("llvm-project::git+https://github.com/llvm/llvm-project.git"
              'llvm-config.h'
              'enable-SSP-and-PIE-by-default.patch')

md5sums=('SKIP'
         '295c343dcd457dc534662f011d7cff1a'
         '94e558db946aba91ce9789087a35ae1b')
sha512sums=('SKIP'
            '75e743dea28b280943b3cc7f8bbb871b57d110a7f2b9da2e6845c1c36bf170dd883fca54e463f5f49e0c3effe07fbd0db0f8cf5a12a2469d3f792af21a73fcdd'
            '3fe75bfacdf7eabe18fefe3724fff1e8d8271870bd21374f7bba5949037648eb5b0a73e372545850190fca0d09a2bdc6eafaa86c68d34fb6dd00957f70da2b1c')
options=('staticlibs' 'ccache')

# NINJAFLAGS is an env var used to pass commandline options to ninja
# NOTE: It's your responbility to validate the value of $NINJAFLAGS. If unsure, don't set it.

_python_optimize() {
  python -m compileall "$@"
  python -O -m compileall "$@"
  python -OO -m compileall "$@"
}

 _ocamlver() {
    { pacman -Q ocaml 2>/dev/null || pacman -Sp --print-format '%n %v' ocaml ;} \
     | awk '{ print $2 }' | cut -d - -f 1 | cut -d . -f 1,2,3
}
    
pkgver() {
    cd llvm-project/llvm

    # This will almost match the output of `llvm-config --version` when the
    # LLVM_APPEND_VC_REV cmake flag is turned on. The only difference is
    # dash being replaced with underscore because of Pacman requirements.
    local _pkgver=$(awk -F 'MAJOR |MINOR |PATCH |)' \
            'BEGIN { ORS="." ; i=0 } \
             /set\(LLVM_VERSION_/ { print $2 ; i++ ; if (i==2) ORS="" } \
             END { print "\n" }' \
             CMakeLists.txt)_r$(git rev-list --count HEAD).$(git rev-parse --short HEAD)
    echo "$_pkgver"
}

prepare() {
    if [  -d _build64 ]; then
        rm -rf _build64
    fi
    if [  -d _build32 ]; then
        rm -rf _build32
    fi
    mkdir _build64
    mkdir _build32
    
    cd llvm-project
    # llvm-project contains a lot of stuff, remove parts that aren't used by this package
    rm -rf debuginfo-tests libclc libcxx libcxxabi libunwind llgo openmp parallel-libs pstl libc
    
    cd clang
    patch --forward --strip=1 --input="$srcdir"/enable-SSP-and-PIE-by-default.patch
}

build() {

    cd _build64
    cmake "$srcdir"/llvm-project/llvm  -G Ninja \
        -D CMAKE_C_FLAGS="${CFLAGS}" \
        -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
        -D CMAKE_BUILD_TYPE=Release \
        -D CMAKE_INSTALL_PREFIX=/usr \
        -D PYTHON_EXECUTABLE=/usr/bin/python \
        -D LLVM_APPEND_VC_REV=ON \
        -D LLVM_HOST_TRIPLE=$CHOST \
        -D LLVM_ENABLE_RTTI=ON \
        -D LLVM_ENABLE_FFI=ON \
        -D FFI_INCLUDE_DIR:PATH="$(pkg-config --variable=includedir libffi)" \
        -D LLVM_BUILD_LLVM_DYLIB=ON \
        -D LLVM_LINK_LLVM_DYLIB=ON \
        -D LLVM_INSTALL_UTILS=ON \
        -D LLVM_BUILD_TESTS=ON \
        -D LLVM_BUILD_DOCS=ON \
        -D LLVM_ENABLE_DOXYGEN=OFF \
        -D LLVM_ENABLE_SPHINX=ON \
        -D SPHINX_OUTPUT_HTML:BOOL=OFF \
        -D SPHINX_WARNINGS_AS_ERRORS=OFF \
        -D LLVM_BINUTILS_INCDIR=/usr/include \
        -D LLVM_VERSION_SUFFIX="" \
        -D POLLY_ENABLE_GPGPU_CODEGEN=ON \
        -D LINK_POLLY_INTO_TOOLS=ON \
        -D CMAKE_POLICY_DEFAULT_CMP0075=NEW \
        -D LLVM_ENABLE_PROJECTS="polly;lldb;lld;compiler-rt;clang-tools-extra;clang"

    ninja $NINJAFLAGS all ocaml_doc

    cd ../_build32
    export PKG_CONFIG_PATH="/usr/lib32/pkgconfig"
    
    LIB32_CFLAGS="$CFLAGS"" -m32"
    LIB32_CXXFLAGS="$CXXFLAGS"" -m32"

    cmake "$srcdir"/llvm-project/llvm  -G Ninja \
        -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;compiler-rt" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_INSTALL_PREFIX=/usr \
        -DLLVM_LIBDIR_SUFFIX=32 \
        -D CMAKE_C_FLAGS="$LIB32_CFLAGS" \
        -D CMAKE_CXX_FLAGS="$LIB32_CXXFLAGS" \
        -DLLVM_TARGET_ARCH:STRING=i686 \
        -DLLVM_HOST_TRIPLE=$CHOST \
        -DLLVM_DEFAULT_TARGET_TRIPLE="i686-pc-linux-gnu" \
        -DLLVM_BUILD_LLVM_DYLIB=ON \
        -DLLVM_LINK_LLVM_DYLIB=ON \
        -DLLVM_ENABLE_BINDINGS=OFF \
        -DLLVM_ENABLE_RTTI=ON \
        -DLLVM_ENABLE_FFI=ON \
        -DLLVM_BUILD_TESTS=ON \
        -DLLVM_BUILD_DOCS=OFF \
        -DLLVM_ENABLE_SPHINX=OFF \
        -DLLVM_ENABLE_DOXYGEN=OFF \
        -DFFI_INCLUDE_DIR=$(pkg-config --variable=includedir libffi) \
        -DLLVM_BINUTILS_INCDIR=/usr/include \
        -DLLVM_APPEND_VC_REV=ON

    ninja $NINJAFLAGS all
}

check() {
    cd _build64
    if [ "$_nocheck" != "true" ]; then
      ninja $NINJAFLAGS check
      ninja $NINJAFLAGS check-polly
      ninja $NINJAFLAGS check-lld
      # check-lldb causes ninja to hang at 99%, disabled those tests for now
      #ninja $NINJAFLAGS check-lldb
      ninja $NINJAFLAGS check-clang
      ninja $NINJAFLAGS check-clang-tools
    fi
}

package_llvm-git() {
    pkgdesc="LLVM development version. includes clang and many other tools"
    depends=("llvm-libs-git=$pkgver-$pkgrel" 'perl')
    optdepends=('python: for scripts'
                           'python-setuptools: for using lit = LLVM Integrated Tester'
    )
    # yes, I know polly is not in official repos. It just feels cleaner to list it
    provides=(aur-llvm-git llvm=$pkgver-$pkgrel
                        compiler-rt-git=$pkgver-$pkgrel clang-git=$pkgver-$pkgrel lld-git=$pkgver-$pkgrel lldb-git=$pkgver-$pkgrel polly-git=$pkgver-$pkgrel
                        compiler-rt=$pkgver-$pkgrel clang=$pkgver-$pkgrel lld=$pkgver-$pkgrel lldb=$pkgver-$pkgrel polly=$pkgver-$pkgrel
    )
    # A package always provides itself, so there's no need to provide llvm-git
    conflicts=('llvm' 'compiler-rt' 'clang' 'lld' 'lldb' 'polly')
    
    pushd _build64
        DESTDIR="$pkgdir" ninja $NINJAFLAGS install
    popd

    _py="3.8"
    # Clean up conflicting files
    # TODO: This should probably be discussed with upstream.
    rm -rf "${pkgdir}/usr/lib/python$_py/site-packages/six.py"

    # Include lit for running lit-based tests in other projects
    pushd llvm-project/llvm/utils/lit
    python setup.py install --root="$pkgdir" -O1
    popd
    
    # Move analyzer scripts out of /usr/libexec
    mv "$pkgdir"/usr/libexec/{ccc,c++}-analyzer "$pkgdir"/usr/lib/clang/
    rmdir "$pkgdir"/usr/libexec
    sed -i 's|libexec|lib/clang|' "$pkgdir"/usr/bin/scan-build

    # The runtime libraries go into llvm-libs
    mv -f "$pkgdir"/usr/lib/lib{LLVM,LTO}*.so* "$srcdir"
    mv -f "$pkgdir"/usr/lib/LLVMgold.so "$srcdir"

    # OCaml bindings go to a separate package
    rm -rf "$srcdir"/ocaml.{lib,doc}
    mv "$pkgdir"/usr/lib/ocaml "$srcdir"/ocaml.lib
    mv "$pkgdir"/usr/share/doc/llvm/ocaml-html "$srcdir"/ocaml.doc

    
    if [[ $CARCH == x86_64 ]]; then
        # Needed for multilib (https://bugs.archlinux.org/task/29951)
        # Header stub is taken from Fedora
        mv "$pkgdir"/usr/include/llvm/Config/llvm-config{,-64}.h
        cp "$srcdir"/llvm-config.h "$pkgdir"/usr/include/llvm/Config/llvm-config.h
    fi

    cd llvm-project
    # Install Python bindings and optimize them
    cp -a llvm/bindings/python/llvm  "$pkgdir"/usr/lib/python$_py/site-packages/
    cp -a clang/bindings/python/clang  "$pkgdir"/usr/lib/python$_py/site-packages/
    _python_optimize "$pkgdir"/usr/lib/python$_py/site-packages

    #optimize other python files except 2 problem cases
    _python_optimize "$pkgdir"/usr/share -x 'clang-include-fixer|run-find-all-symbols'

    install -Dm644 llvm/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/llvm-LICENSE
    install -Dm644 clang/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-LICENSE
    install -Dm644 clang-tools-extra/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-tools-extra-LICENSE
    install -Dm644 compiler-rt/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/compiler-rt-LICENSE
    install -Dm644 lld/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/lld-LICENSE
    install -Dm644 lldb/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/lldb-LICENSE
    install -Dm644 polly/LICENSE.txt "$pkgdir"/usr/share/licenses/$pkgname/polly-LICENSE
}

package_llvm-libs-git() {
    pkgdesc="runtime libraries for llvm-git"
    depends=('gcc-libs' 'zlib' 'libffi' 'libedit' 'ncurses' 'libxml2')
    provides=(aur-llvm-libs-git llvm-libs=$pkgver-$pkgrel)
    conflicts=('llvm-libs')

    install -d "$pkgdir"/usr/lib
    cp -P \
        "$srcdir"/lib{LLVM,LTO}*.so* \
        "$srcdir"/LLVMgold.so \
        "$pkgdir"/usr/lib/

    # Symlink LLVMgold.so from /usr/lib/bfd-plugins
    # https://bugs.archlinux.org/task/28479
    install -d "$pkgdir"/usr/lib/bfd-plugins
    ln -s ../LLVMgold.so "$pkgdir"/usr/lib/bfd-plugins/LLVMgold.so

    cd llvm-project/
    install -Dm644 llvm/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/llvm-LICENSE
    install -Dm644 clang/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-LICENSE
    install -Dm644 clang-tools-extra/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-tools-extra-LICENSE
    install -Dm644 compiler-rt/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/compiler-rt-LICENSE
    install -Dm644 lld/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/lld-LICENSE
    install -Dm644 lldb/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/lldb-LICENSE
    install -Dm644 polly/LICENSE.txt "$pkgdir"/usr/share/licenses/$pkgname/polly-LICENSE
}

package_llvm-ocaml-git() {
    pkgdesc="OCaml bindings for LLVM"
    depends=("llvm-git=$pkgver-$pkgrel" "ocaml=$(_ocamlver)" 'ocaml-ctypes')
    conflicts=('llvm-ocaml')
    provides=("llvm-ocaml=$pkgver-$pkgrel")
    
    install -d "$pkgdir"/{usr/lib,usr/share/doc/$pkgname}
    cp -a "$srcdir"/ocaml.lib "$pkgdir"/usr/lib/ocaml
    cp -a "$srcdir"/ocaml.doc "$pkgdir"/usr/share/doc/$pkgname/html

    install -Dm644 "$srcdir"/llvm-project/llvm/LICENSE.TXT  "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
}

package_lib32-llvm-git() {
depends=('lib32-llvm-libs-git' 'llvm-git')
provides=(aur-lib32-llvm-git lib32-llvm=$pkgver-$pkgrel lib32-clang=$pkgver-$pkgrel 'lib32-clang-git'
                'lib32-clang-svn'  'lib32-llvm-svn')
conflicts=('lib32-llvm' 'lib32-clang' 
                    'lib32-llvm-svn' 'lib32-clang-svn')

    cd _build32

    DESTDIR="$pkgdir" ninja $NINJAFLAGS install

    # The runtime library goes into lib32-llvm-libs
    mv "$pkgdir"/usr/lib32/lib{LLVM,LTO}*.so* "$srcdir"
    mv -f "$pkgdir"/usr/lib32/LLVMgold.so "$srcdir"

    
    mv "$pkgdir"/usr/bin/llvm-config "$pkgdir"/usr/lib32/llvm-config
    mv "$pkgdir"/usr/include/llvm/Config/llvm-config.h \
    "$pkgdir"/usr/lib32/llvm-config-32.h

    rm -rf "$pkgdir"/usr/{bin,include,libexec,share/{doc,man,llvm,opt-viewer,scan-build,scan-view,clang}}
      
    # Needed for multilib (https://bugs.archlinux.org/task/29951)
    # Header stub is taken from Fedora
    install -d "$pkgdir"/usr/include/llvm/Config
    mv "$pkgdir"/usr/lib32/llvm-config-32.h "$pkgdir"/usr/include/llvm/Config/

    install -d "$pkgdir"/usr/bin
    mv "$pkgdir"/usr/lib32/llvm-config "$pkgdir"/usr/bin/llvm-config32

    cd "$srcdir"/llvm-project/
    install -D -m 0644 llvm/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
    install -Dm644 clang/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-LICENSE
    install -Dm644 clang-tools-extra/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-tools-extra-LICENSE
    install -Dm644 compiler-rt/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/compiler-rt-LICENSE
}

package_lib32-llvm-libs-git() {
    depends=('lib32-gcc-libs' 'lib32-libffi' 'lib32-libxml2' 'lib32-ncurses' 'lib32-zlib')
provides=(aur-lib32-llvm-libs-git lib32-llvm-libs=$pkgver-$pkgrel 'lib32-llvm-libs-svn')
conflicts=('lib32-llvm-libs')
    
    install -d "$pkgdir/usr/lib32"

    cp -P \
        "$srcdir"/lib{LLVM,LTO}*.so* \
        "$srcdir"/LLVMgold.so \
        "$pkgdir/usr/lib32/"

    # Symlink LLVMgold.so from /usr/lib/bfd-plugins
    # https://bugs.archlinux.org/task/28479
    install -d "$pkgdir/usr/lib32/bfd-plugins"
    ln -s ../LLVMgold.so "$pkgdir/usr/lib32/bfd-plugins/LLVMgold.so"

    cd "$srcdir"/llvm-project/
    install -D -m 0644 llvm/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/LICENSE
    install -Dm644 clang/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-LICENSE
    install -Dm644 clang-tools-extra/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/clang-tools-extra-LICENSE
    install -Dm644 compiler-rt/LICENSE.TXT "$pkgdir"/usr/share/licenses/$pkgname/compiler-rt-LICENSE
}
