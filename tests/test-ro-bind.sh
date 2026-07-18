if [ -z `which mcookie` ] || [ -z `which touch` ] || [ -z `which mkdir` ] || [ -z `which cat` ] || [ -z `which rm` ] || [ -z `which chmod` ] || [ -z `which stat` ]; then
    exit 125;
fi

TMP=${TMPDIR:-/tmp}/$(mcookie)
mkdir -p ${TMP}
echo "content" > ${TMP}/existing_file

# Test 1: Read-only bind blocks writes (touch/create)
! ${PROOT} -b ${TMP}:/mnt,ro touch /mnt/new_file

# Test 2: Read-only bind blocks writes (echo redirection)
! ${PROOT} -b ${TMP}:/mnt,ro sh -c "echo data > /mnt/new_file"

# Test 3: Read-only bind blocks unlink
! ${PROOT} -b ${TMP}:/mnt,ro rm /mnt/existing_file

# Test 4: Read-only bind blocks mkdir
! ${PROOT} -b ${TMP}:/mnt,ro mkdir /mnt/new_dir

# Test 5: Read-only bind blocks rmdir
mkdir -p ${TMP}/empty_dir
! ${PROOT} -b ${TMP}:/mnt,ro rmdir /mnt/empty_dir

# Test 6: Read-only bind blocks chmod
! ${PROOT} -b ${TMP}:/mnt,ro chmod 0777 /mnt/existing_file

# Test 7: Read-only bind allows reads (cat)
${PROOT} -b ${TMP}:/mnt,ro cat /mnt/existing_file | grep -q "content"

# Test 8: Read-only bind allows stat
${PROOT} -b ${TMP}:/mnt,ro stat /mnt/existing_file >/dev/null 2>&1

# Test 9: Read-only bind allows ls
${PROOT} -b ${TMP}:/mnt,ro ls /mnt/ >/dev/null 2>&1

# Test 10: Writable bind still works (no ,ro)
${PROOT} -b ${TMP}:/mnt touch /mnt/writable_file
[ -f ${TMP}/writable_file ]

# Cleanup
rm -rf ${TMP}
