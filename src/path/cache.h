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

#ifndef PATH_CACHE_H
#define PATH_CACHE_H

#include <limits.h>
#include <stdbool.h>
#include <stdint.h>

#include "tracee/tracee.h"

#define PATH_CACHE_SIZE 128

typedef struct path_cache_entry {
	uint64_t path_hash;
	uint64_t cwd_hash;
	int dir_fd;
	char host_path[PATH_MAX];
	bool read_only;
	bool valid;
} PathCacheEntry;

typedef struct path_cache {
	PathCacheEntry entries[PATH_CACHE_SIZE];
} PathCache;

extern PathCache *path_cache_new(TALLOC_CTX *context);
extern bool path_cache_lookup(PathCache *cache, const char *user_path,
			const char *cwd, int dir_fd,
			char host_path[PATH_MAX], bool *read_only);
extern void path_cache_store(PathCache *cache, const char *user_path,
			const char *cwd, int dir_fd,
			const char *host_path, bool read_only);
extern void path_cache_invalidate(PathCache *cache);

#endif /* PATH_CACHE_H */
