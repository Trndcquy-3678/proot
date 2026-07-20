#!/bin/sh
# Test: argv[0] value
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ] "proot not built"
skip_if [ ! -x "${ROOTFS_BIN}/argv0" ] "argv0 helper not built"

# Skip if argv0 can't execute inside rootfs (e.g. dynamically linked)
${PROOT} -r ${ROOTFS} /bin/argv0 >/dev/null 2>&1 || exit 125

# Test 1: argv0 executed by relative name
RESULT=$(${PROOT} -r ${ROOTFS} argv0 2>/dev/null)
like "$RESULT" "^argv0$" "argv[0] is 'argv0'"

# Test 2: argv0 executed by full path
RESULT=$(${PROOT} -r ${ROOTFS} /bin/argv0 2>/dev/null)
like "$RESULT" "^/bin/argv0$" "argv[0] is '/bin/argv0'"
plan 2