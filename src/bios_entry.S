# SPDX-License-Identifier: Apache-2.0

#include "registry.inc"

.section .init._start, "ax", @progbits
.code16
bios_entry:
	cli
	cld

	xorw	%ax, %ax
	movw	%ax, %ds
	movw	%ax, %es
	movw	%ax, %ss
	movw	$bios_entry, %sp

	pushw	%dx

set_vbe_mode:
	subw	$512, %sp
	movw	%sp, %bp
	movw	%sp, %di

	movw	$0x4f00, %ax
	int	$0x10

	cmpw	$0x004f, %ax
	jne	.Lvbe_done

	movw	%es:0x0e(%bp), %si
	movw	%es:0x10(%bp), %ds

	subw	$256, %sp

	xorw	%bp, %bp
	xorl	%ebx, %ebx
.Lvbe_find_mode:
	lodsw
	cmpw	$0xffff, %ax
	je	.Lvbe_mode_found

	pushw	%ax
	pushw	%si
	pushw	%ds
	pushl	%ebx
	pushw	%bp

	movw	%ax, %cx
	movw	%sp, %di
	addw	$12, %di

	movw	$0x4f01, %ax
	int	$0x10

	xorw	%dx, %dx
	movw	%dx, %es

	popw	%bp
	popl	%ebx
	popw	%ds
	popw	%si
	popw	%cx

	movw	%sp, %di

	cmpw	$0x004f, %ax
	jne	.Lvbe_find_mode

	movb	%es:0x00(%di), %dl
	andb	$0x91, %dl
	cmpb	$0x91, %dl
	jne	.Lvbe_find_mode

	movb	%es:0x19(%di), %al
	cmpb	$24, %al
	je	.Lvbe_check_resolution
	cmpb	$32, %al
	jne	.Lvbe_find_mode
.Lvbe_check_resolution:
	movzwl	%es:0x12(%di), %eax
	movzwl	%es:0x14(%di), %edx
	imull	%edx, %eax

	cmpl	%ebx, %eax
	jbe	.Lvbe_find_mode

	movl	%eax, %ebx
	movw	%cx, %bp
	jmp	.Lvbe_find_mode
.Lvbe_mode_found:
	testw	%bp, %bp
	jz	.Lvbe_done

	xorw	%ax, %ax
	movw	%ax, %ds

	movw	%bp, %bx
	orw	$0x4000, %bx
	movw	$0x4f02, %ax
	int	$0x10

	cmpw	$0x004f, %ax
	jne	.Lvbe_done

	pushw	%bp
	registry_create "VBE_INFO", 256
	movw	%ax, %di
	addw	$4, %di
	popw	%cx

	xorw	%ax, %ax
	movw	%ax, %es
	movw	$0x4f01, %ax
	int	$0x10
.Lvbe_done:
	movw	$(bios_entry - 2), %sp

	xorw	%ax, %ax
	movw	%ax, %ds
	movw	%ax, %es

load_kernel_image:
	movw	$image_dap, %si
	movb	$0x42, %ah
	popw	%dx
	int	$0x13

	registry_create "BLOB_DATA", 4
	movl	$__program_end, 4(%eax)

	registry_create "BLOB_SIZE", 4
	movl	$__blob_size, 4(%eax)

prepare_c_handoff:
	cli

	inb	$0x92, %al
	orb	$0x02, %al
	andb	$0xfe, %al
	outb	%al, $0x92

	lgdt	_gdtr

	movl	%cr0, %eax
	orb	$0x01, %al
	movl	%eax, %cr0

	ljmpl	$0x08, $protected_mode_entry

.code32
.align 4
protected_mode_entry:
	movl	$0x10, %eax
	movl	%eax, %ds
	movl	%eax, %es
	movl	%eax, %fs
	movl	%eax, %gs
	movl	%eax, %ss

	xorl	%eax, %eax
	movl	$__bss_start, %edi
	movl	$__bss_size, %ecx
	shrl	$2, %ecx
	rep	stosl

	call	main

.section .init.rodata, "a", @progbits
.balign 4
image_dap:
	.byte	0x10, 0
	.word	__image_sectors
	.word	0x7e00
	.word	0x0000
	.quad	1

.balign 8
_gdt:
	.quad	0x0000000000000000
	.quad	0x00cf9a000000ffff
	.quad	0x00cf92000000ffff
_gdt_end:

_gdtr:
	.word	_gdt_end - _gdt - 1
	.long	_gdt