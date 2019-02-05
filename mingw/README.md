# Mingw on Arch automator

Automate the (annoying) installation of mingw on Arch and Arch-based distros.

You'll find two switches in the script to enable dwarf2 exceptions and/or disable fortran.

Using dwarf2 exceptions instead of sjlj exceptions provides a large performance boost to 32-bit DXVK and is enabled by default.

**Packages that will be installed :**
- cloog or cloog-git
- mingw-w64-binutils
- mingw-w64-headers
- mingw-w64-headers-bootstrap (also removed in the process)
- mingw-w64-gcc-base (also removed in the process)
- mingw-w64-crt
- mingw-w64-winpthreads
- mingw-w64-gcc

If you set _sdlandco to "true", you'll also get the following (disabled by default) :
- mingw-w64-pkg-config
- mingw-w64-configure
- mingw-w64-sdl2
