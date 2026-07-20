#!/bin/sh
# Test: mknod with fake root (-0)
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
skip_if [ "$(id -u)" -eq 0 ] "running as root"
require mknod
require mcookie

TMP=${TMPDIR:-/tmp}/$(mcookie)
trap 'rm -f ${TMP}' EXIT

is_fail "mknod without -0 fails" "${PROOT} mknod ${TMP} b 1 1"

is_fail "mknod with -i fails" "${PROOT} -i 123:456 mknod ${TMP} b 1 1"

exit_code 0 "mknod with -0 succeeds" ${PROOT} -0 mknod ${TMP} b 1 1

plan 3
