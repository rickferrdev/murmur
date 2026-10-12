# Murmur

A lightweight x86 BIOS-based bootloader focused on VBE graphics and small operating systems.

## Build

```sh
xmake
````

### Install

```sh
sudo xmake install -o /usr/local
```

Installs the static library, public headers, and linker script.

### Usage

Include the public header:

```c
#include <murmur/murmur.h>
```

Link against `libmurmur.a`.

The provided `linker.ld` is required when building a boot image that relies on Murmur's memory layout, entry point, and linker-defined symbols.

### License

Apache-2.0.