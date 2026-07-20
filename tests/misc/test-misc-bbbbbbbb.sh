if [ -z `which mcookie` ] || [ -z `which rm` ] || [ -z `which ln` ]; then
    exit 125;
fi

DONT_EXIST=$(mcookie)
TMP1=$(mcookie)
TMP2=$(mcookie)

rm -f ${DONT_EXIST}
${PROOT} ln -sf /${DONT_EXIST} /tmp/
${PROOT} ln -sf /${DONT_EXIST} /tmp/

rm -f ${DONT_EXIST}
  ${PROOT} ln -sf /etc/fstab/${DONT_EXIST} /tmp/
! ${PROOT} ln -sf /etc/fstab/${DONT_EXIST} /tmp/

rm -f ${DONT_EXIST}
rm -f ${TMP1} ${TMP2}
touch ${TMP2}
ln -sf ${DONT_EXIST} ${TMP1}
! ${PROOT} ln ${TMP2} ${TMP1}

rm -f ${TMP1} ${TMP2}
rm -f ${DONT_EXIST}
