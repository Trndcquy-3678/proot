#!/bin/sh
# Test: Symlink resolution through bindings
. "$(dirname "$0")/../../helpers.sh"

skip_if [ ! -x "${PROOT}" ]
skip_if [ ! -x ${ROOTFS}/bin/readlink ]
skip_if [ ! -x ${ROOTFS}/bin/symlink ]
# Runtime check: helpers must be statically linked to work inside rootfs
${PROOT} -r ${ROOTFS} /bin/readlink /proc/self/exe >/dev/null 2>&1 || exit 125
require mcookie
require rm
require ln
require mkdir

LINK_NAME1=$(mcookie)
LINK_NAME2=$(mcookie)
trap 'rm -f /tmp/${LINK_NAME1} ${ROOTFS}/bin/${LINK_NAME1} /tmp/${LINK_NAME2}' EXIT

mkdir -p ${ROOTFS}/tmp
ln -sf /tmp/ced-host /tmp/${LINK_NAME1}
ln -sf /tmp/ced-guest ${ROOTFS}/tmp/${LINK_NAME1}

RESULT=$(${PROOT} -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-guest" "symlink points to guest path without bind"

RESULT=$(${PROOT} -b /tmp -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-host" "symlink points to host path with /tmp bind"

RESULT=$(${PROOT} -b /tmp:/foo -r ${ROOTFS} readlink /foo/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/foo/ced-host" "symlink resolved through renamed bind"

RESULT=$(${PROOT} -b /tmp:/foo -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-guest" "unbound path still resolves to guest"

RESULT=$(${PROOT} -b /:/host-rootfs -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-guest" "symlink with / bind resolves to guest"

RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp:/foo -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-guest" "deeper host bind not applied to unbound path"

RESULT=$(${PROOT} -b /:/host-rootfs -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-guest" "symlink resolves to guest with / bind"

RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp -r ${ROOTFS} readlink /tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-host" "deepest bind from host PoV wins"

RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp:/foo -r ${ROOTFS} readlink /foo/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/foo/ced-host" "renamed bind symlink resolved"

RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp -r ${ROOTFS} readlink /host-rootfs/tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/tmp/ced-host" "host-rootfs path resolves symlink"

RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp:/foo -r ${ROOTFS} readlink /host-rootfs/tmp/${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/foo/ced-host" "host-rootfs through renamed bind"

rm -f /tmp/${LINK_NAME1} ${ROOTFS}/tmp/${LINK_NAME1}

${PROOT} -b /:/host-rootfs -b /tmp -w /bin -r ${ROOTFS} symlink /bin/bar /bin/${LINK_NAME1} 2>/dev/null
RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp -w /bin -r ${ROOTFS} readlink ${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/bin/bar" "symlink creation and resolution within guest"
rm -f ${ROOTFS}/bin/${LINK_NAME1}

${PROOT} -b /:/host-rootfs -b /tmp -w /tmp -r ${ROOTFS} symlink /bin/bar /tmp/${LINK_NAME1} 2>/dev/null
RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp -w /tmp -r ${ROOTFS} readlink ${LINK_NAME1} 2>/dev/null)
is "$RESULT" "/bin/bar" "symlink in /tmp resolves correctly"
rm -f /tmp/${LINK_NAME1}

${PROOT} -b /:/host-rootfs -b /tmp:/foo -w /foo -r ${ROOTFS} symlink /foo/bar /foo/${LINK_NAME2} 2>/dev/null
RESULT=$(${PROOT} -b /:/host-rootfs -b /tmp:/foo -w /foo -r ${ROOTFS} readlink ${LINK_NAME2} 2>/dev/null)
is "$RESULT" "/foo/bar" "symlink in renamed bind resolves"
rm -f /tmp/${LINK_NAME2}

plan 13
