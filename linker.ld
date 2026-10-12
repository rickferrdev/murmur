/* SPDX-License-Identifier: Apache-2.0 */

OUTPUT_FORMAT(elf32-i386)
ENTRY(main)

SECTIONS
{
	. = 0x7c00;
	__program_start = .;

	.init :
	{
		KEEP(*(.init._start))
		KEEP(*(.init*))

		. = 0x7c00 + 510;
		SHORT(0xaa55)
	}

	.text :
	{
		*(.text*)
		*(.rodata*)
		*(.data*)
	}
	__program_end = .;

	.blob :
	{
		KEEP(*(.blob*))
	}
	__image_end = .;

	__blob_size = __image_end - __program_end;
	__image_sectors = (__image_end - __program_start + 511) / 512;

	.bss (NOLOAD) : ALIGN(16)
	{
		__bss_start = .;
		*(.bss*)
		*(COMMON)
		. = ALIGN(16);
	}
	__bss_size = SIZEOF(.bss);

	/DISCARD/ :
	{
		*(.comment)
		*(.note*)
		*(.eh_frame*)
	}
}
