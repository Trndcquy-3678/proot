#!/bin/sh
# Test: mkdir/rmdir with binding CWD
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
require mcookie
require mkdir
require rmdir

TMP=$(mcookie)
TMP_DIR=${TMPDIR:-/tmp}
cd "$TMP_DIR"

exit_code 0 "mkdir ./${TMP}" ${PROOT} mkdir "./${TMP}"
exit_code 0 "rmdir ./${TMP}" ${PROOT} rmdir "./${TMP}"

exit_code 0 "mkdir ${TMP}/" ${PROOT} mkdir "${TMP}/"
exit_code 0 "rmdir ${TMP}/" ${PROOT} rmdir "${TMP}/"

exit_code 0 "mkdir ./${TMP}/" ${PROOT} mkdir "./${TMP}/"
exit_code 0 "rmdir ./${TMP}/" ${PROOT} rmdir "./${TMP}/"

plan 6
