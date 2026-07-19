/* -*- c-set-style: "K&R"; c-basic-offset: 8 -*-
 *
 * This file is part of PRoot.
 *
 * Copyright (C) 2015 STMicroelectronics
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301 USA.
 */

#include <string.h>
#include <talloc.h>

#include "path/cache.h"

/**
 * Hash a string into a 64-bit value using FNV-1a.
 */
static inline uint64_t hash_string(const char *s)
{
	uint64_t h = 0xcbf29ce484222325ULL;

	if (s == NULL)
		return h;

	for (; *s != '\0'; s++) {
		h ^= (uint8_t)*s;
		h *= 0x100000001b3ULL;
	}

	return h;
}

/**
 * Compute a combined hash of user_path, cwd, and dir_fd.
 */
static inline uint64_t hash_key(const char *path, const char *cwd, int dir_fd)
{
	uint64_t h = hash_string(path);
	h ^= hash_string(cwd) << 1;
	h ^= (uint64_t)(unsigned)dir_fd << 2;
	return h;
}

/**
 * Map a 64-bit hash to a cache index.
 */
static inline uint32_t cache_index(uint64_t hash)
{
	return (uint32_t)(hash % PATH_CACHE_SIZE);
}

/**
 * Allocate a new path translation cache.
 */
PathCache *path_cache_new(TALLOC_CTX *context)
{
	return talloc_zero(context, PathCache);
}

/**
 * Look up a cached path translation. Returns true on cache hit.
 */
bool path_cache_lookup(PathCache *cache, const char *user_path,
		const char *cwd, int dir_fd,
		char host_path[PATH_MAX], bool *read_only)
{
	uint64_t key;
	uint32_t idx;
	PathCacheEntry *entry;

	if (cache == NULL || user_path == NULL)
		return false;

	key = hash_key(user_path, cwd, dir_fd);
	idx = cache_index(key);
	entry = &cache->entries[idx];

	if (entry->valid
	    && entry->path_hash == key
	    && entry->dir_fd == dir_fd) {
		strcpy(host_path, entry->host_path);
		if (read_only != NULL)
			*read_only = entry->read_only;
		return true;
	}

	return false;
}

/**
 * Store a path translation in the cache.
 */
void path_cache_store(PathCache *cache, const char *user_path,
		const char *cwd, int dir_fd,
		const char *host_path, bool read_only)
{
	uint64_t key;
	uint32_t idx;
	PathCacheEntry *entry;

	if (cache == NULL || user_path == NULL || host_path == NULL)
		return;

	key = hash_key(user_path, cwd, dir_fd);
	idx = cache_index(key);
	entry = &cache->entries[idx];

	entry->path_hash = key;
	entry->dir_fd = dir_fd;
	entry->read_only = read_only;
	entry->valid = true;
	strncpy(entry->host_path, host_path, PATH_MAX - 1);
	entry->host_path[PATH_MAX - 1] = '\0';
}

/**
 * Invalidate all cached entries. Called on mutating syscalls.
 */
void path_cache_invalidate(PathCache *cache)
{
	if (cache != NULL)
		memset(cache, 0, sizeof(PathCache));
}
