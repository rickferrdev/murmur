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

### Registry API

Before calling `main`, the bootloader stores boot information in a registry at physical address `0x500`. Each entry starts with a 32-bit size field, followed by its value.

Assembly code can create an entry with the `registry_create` macro and write its value immediately after the size field:

```asm
registry_create "MY_KEY", 4
movl $my_value, 4(%eax)
```

In C, look up an entry with `murmur_get_registry_key`:

```c
struct murmur_registry_entry *entry =
    murmur_get_registry_key("VBE_INFO");

if (entry) {
    /* entry->size bytes are available in entry->value */
}
```

The bootloader currently provides these entries:

| Key | Value |
| --- | --- |
| `VBE_INFO` | 256-byte VBE mode information block |
| `BLOB_DATA` | 32-bit address of the blob data |
| `BLOB_SIZE` | 32-bit size of the blob data |

### License

Apache-2.0.