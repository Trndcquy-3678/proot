#!/bin/sh
# Test: /proc/self/fd resolution through bindings
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
skip_if [ ! -e /proc/self/fd/0 ]

require readlink
require grep
require sh
require echo
require mcookie

TMP=${TMPDIR:-/tmp}/$(mcookie)
trap 'rm -f ${TMP}' EXIT

RESULT=$(${PROOT} readlink /proc/self 2>/dev/null)
like "$RESULT" "^[[:digit:]]\+$" "/proc/self resolves to PID"

RESULT=$(${PROOT} readlink /proc/self/../self 2>/dev/null)
like "$RESULT" "^[[:digit:]]\+$" "/proc/self/../self resolves to PID"

RESULT=$(${PROOT} sh -c 'echo "OK" | readlink /proc/self/fd/0' 2>/dev/null)
like "$RESULT" "^pipe:\[[[:digit:]]\+\]$" "/proc/self/fd/0 resolves to pipe"

is_fail "readlink /proc/self/fd/0/ fails" "${PROOT} sh -c 'echo OK | readlink /proc/self/fd/0/'"

is_fail "readlink /proc/self/fd/0/.. fails" "${PROOT} sh -c 'echo OK | readlink /proc/self/fd/0/..'"

is_fail "readlink /proc/self/fd/0/../0 fails" "${PROOT} sh -c 'echo OK | readlink /proc/self/fd/0/../0'"

RESULT=$(${PROOT} sh -c 'echo "echo OK" | sh /proc/self/fd/0' 2>/dev/null)
like "$RESULT" "^OK$" "execute script via /proc/self/fd/0"

${PROOT} sh -c "exec 6<>${TMP}; readlink /proc/self/fd/6" 2>/dev/null | grep -q "^${TMP}$"
is_ok "readlink /proc/self/fd/6 resolves" "..."

plan 9
