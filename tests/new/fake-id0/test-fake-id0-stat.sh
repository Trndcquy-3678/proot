#!/bin/sh
# Test: faked stat outputs with -0 and -i
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
require mcookie
require touch
require stat
require grep
require rm

TMP=${TMPDIR:-/tmp}/$(mcookie)
touch ${TMP}
trap 'rm -f ${TMP}' EXIT

RESULT=$(${PROOT} -0 stat -c %u:%g ${TMP} 2>/dev/null)
is "$RESULT" "0:0" "stat shows 0:0 with -0"

RESULT=$(${PROOT} -i 123:456 stat -c %u:%g ${TMP} 2>/dev/null)
is "$RESULT" "123:456" "stat shows 123:456 with -i 123:456"

plan 2
