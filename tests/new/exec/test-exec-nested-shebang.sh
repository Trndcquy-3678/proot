#!/bin/sh
# Test: Multi-level shebang execution
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
require mcookie
require rm
require chmod
require echo
require which

TMP1=${TMPDIR:-/tmp}/$(mcookie)
TMP2=${TMPDIR:-/tmp}/$(mcookie)
trap 'rm -f ${TMP1} ${TMP2}' EXIT

echo "#! ${TMP2} -a"       > ${TMP1}
echo "#! $(which echo) -b" > ${TMP2}
chmod +x ${TMP1} ${TMP2}

RESULT=$(${PROOT} ${TMP1} 2>/dev/null)
EXPECTED=$(${TMP1} 2>/dev/null)

is "$RESULT" "$EXPECTED" "nested shebang produces same result as native"

plan 1
