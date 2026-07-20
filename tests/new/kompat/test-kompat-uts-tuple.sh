#!/bin/sh
# Test: uname/utsname tuple overrides (-k)
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
require uname
require grep
require domainname
require hostname
require env
require true

UTSNAME="\\\\sysname\\\\nodename\\\\$(uname -r)\\\\version\\\\machine\\\\domainname\\\\0\\\\"

RESULT=$(${PROOT} -k "${UTSNAME}" uname -s 2>/dev/null)
is "$RESULT" "sysname" "uname -s override"

RESULT=$(${PROOT} -k "${UTSNAME}" uname -n 2>/dev/null)
is "$RESULT" "nodename" "uname -n override"

RESULT=$(${PROOT} -k "${UTSNAME}" uname -v 2>/dev/null)
is "$RESULT" "version" "uname -v override"

RESULT=$(${PROOT} -k "${UTSNAME}" uname -m 2>/dev/null)
is "$RESULT" "machine" "uname -m override"

RESULT=$(${PROOT} -k "${UTSNAME}" domainname 2>/dev/null)
is "$RESULT" "domainname" "domainname override"

RESULT=$(${PROOT} -k "${UTSNAME}" env LD_SHOW_AUXV=1 true 2>/dev/null)
like "$RESULT" "^AT_HWCAP:[[:space:]]*0?$" "AT_HWCAP cleared with -k"

RESULT=$(${PROOT} -0 -k "${UTSNAME}" sh -c 'domainname domainname2; domainname' 2>/dev/null)
is "$RESULT" "domainname2" "domainname can be changed with -0"

RESULT=$(${PROOT} -0 -k "${UTSNAME}" sh -c 'hostname hostname2; hostname' 2>/dev/null)
is "$RESULT" "hostname2" "hostname can be changed with -0"

RESULT=$(${PROOT} -0 -k "${UTSNAME}" sh -c 'hostname hostname2; uname -n' 2>/dev/null)
is "$RESULT" "hostname2" "hostname change reflected in uname -n"

plan 9
