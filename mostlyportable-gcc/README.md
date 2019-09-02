# A tool to create (mostly) portable GCC builds

A simple script to make portable x86_64 GCC builds, handy to use custom or devel GCC. You can have as many as you want, unlike candy :frog: and move them wherever you see fit.

## Requirements:
You'll need basic development tools installed (base-devel, build-essential or similar for your distro as well as schedtool) to use it.
**It is bound to the libc/binutils version of the host system, so cross-distro portability will only work for a given libc/binutils version combo**

## Customization:
- Use mostlyportable-gcc.cfg file to define core options as needed;
- You can apply your own patches by putting them next to the script with a .gccpatch extension.
- You can reverse-apply your own patches by putting them next to the script with a .gccrevert extension.
