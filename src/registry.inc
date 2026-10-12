# SPDX-License-Identifier: Apache-2.0

.equ REGISTRY_BASE, 0x0500

.macro registry_create key, size
	.pushsection .init.rodata, "a", @progbits
.Lregistry_key_\@:
	.ascii	"\key"
.Lregistry_key_end_\@:
	.popsection

	movw	$(.Lregistry_key_end_\@ - .Lregistry_key_\@), %cx
	movw	$.Lregistry_key_\@, %si
	movl	$\size, %eax
	call	_create_registry
.endm