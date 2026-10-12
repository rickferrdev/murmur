// SPDX-License-Identifier: Apache-2.0

#pragma once

#include <stdint.h>
#include <stddef.h>

#define MURMUR_REGISTRY_BASE 0x500

struct murmur_registry_entry
{
	uint32_t size;
	uint8_t value[];
};

static inline struct murmur_registry_entry *murmur_get_registry_key(const char *register_key)
{
	size_t len = 0;

	while (register_key[len])
		len++;

	if (len < 2)
		return NULL;

	uintptr_t address = MURMUR_REGISTRY_BASE
		+ (((uint8_t)register_key[0]
		+ (uint8_t)register_key[1]
		+ (uint8_t)register_key[len - 1]) << 5);;

	struct murmur_registry_entry *entry = (struct murmur_registry_entry *)address;

	return entry->size ? entry : NULL;
}