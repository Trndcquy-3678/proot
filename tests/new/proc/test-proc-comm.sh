#!/bin/sh
# Test: /proc/self/comm
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
require mcookie
require cat
require grep
require chmod
require cut
require rm
require ln

TMP=$(mcookie)
TMP2=$(echo ${TMP} | cut -b 1-15)
TMP3=$(mcookie)
TMP4=$(echo ${TMP3} | cut -b 1-15)
trap 'rm -f ${TMP} ${TMP3}' EXIT

RESULT=$(${PROOT} cat /proc/self/comm 2>/dev/null)
like "$RESULT" "cat" "comm shows 'cat'"

RESULT=$(${PROOT} $(which cat) /proc/self/comm 2>/dev/null)
like "$RESULT" "cat" "comm shows 'cat' via absolute path"

echo '#!/bin/sh' > ${TMP}
chmod +x ${TMP}
echo 'cat /proc/$$/comm' >> ${TMP}

RESULT=$(${PROOT} ${TMP} 2>/dev/null)
like "$RESULT" "^${TMP2}$" "comm matches script name (truncated to 15)"

ln -s ${TMP} ${TMP3}
RESULT=$(${PROOT} ${TMP3} /proc/self/comm 2>/dev/null)
like "$RESULT" "^${TMP4}$" "comm matches symlink name (truncated to 15)"

plan 4
