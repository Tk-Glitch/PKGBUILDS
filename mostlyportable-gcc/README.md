# A tool to create (mostly) portable GCC/MinGW builds

A simple distro-agnostic script to make portable x86_64 GCC/MinGW builds, handy to use custom or devel GCC. You can have as many as you want, unlike candy :frog: and move them wherever you see fit.

## Requirements:
You'll need basic development tools installed (`base-devel`, `build-essential` or similar for your distro as well as `texlive-core`, and optionally `schedtool` to speedup compilation) to use it.
**It is bound to the libc version of the host system, so cross-distro portability will only work with a corresponding libc version**

## Customization:
- Use `mostlyportable-gcc.cfg` or `mostlyportable-mingw.cfg` files (depending on the compiler you want to build) to define core options as needed;
- You can apply your own patches by putting them next to the script with a .gccpatch extension.
- You can reverse-apply your own patches by putting them next to the script with a .gccrevert extension.

## Building:
Simply run `./mostlyportable-gcc.sh` and select the compiler you want to build. If you want to customize your build, edit the corresponding .cfg.

## How to use the resulting build:
The most convenient way is to locally add bin/lib/include dirs of your build to PATH when building your project. That way your custom build will get priority for that process without altering your system.
Example: `customcc="/home/frog/PKGBUILDS/mostlyportable-gcc/gcc-mostlyportable-9.2.0" PATH=${customcc}/bin:${customcc}/lib:${customcc}/include:${PATH} make`

Depending on your needs, simply exporting gcc binary path as CC can be enough.
Example: `CC="/home/frog/PKGBUILDS/mostlyportable-gcc/gcc-mostlyportable-9.2.0/bin/gcc" make`
