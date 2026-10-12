# SPDX-License-Identifier: Apache-2.0

.equ REGISTRY_BASE, 0x0500

.section .init, "ax", @progbits
.code16

.global _create_registry
# Creates a registry entry using an address derived from its key.
# The first, second, and last characters determine the entry address.
# The buffer size is stored before the buffer data.
#
# Input:
# DS:SI = Registry key
# CX = Key length
# EAX = Buffer size
#
# Output:
# EAX = Registry entry pointer
_create_registry:
	# Calculate the entry address
	movw	%cx, %bx
	movzbw	-1(%bx,%si), %bx

	movzbw	(%si), %dx
	addw	%dx, %bx
	movzbw	1(%si), %dx
	addw	%dx, %bx
	shlw	$5, %bx
	addw	$REGISTRY_BASE, %bx

	# Store the buffer size
	movl	%eax, (%bx)
	movzwl	%bx, %eax
	ret