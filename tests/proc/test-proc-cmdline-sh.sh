if [ -z `which mcookie` ] ||  [ -z `which cat` ] || [ -z `which tr` ] || [ -z `which grep` ] || [ -z `which grep` ] || [ -z `which chmod` ]; then
    exit 125;
fi

TMP=$(mcookie)

cat > ${TMP} <<EOF
#!/bin/sh

cat /proc/\$$/cmdline
EOF

chmod +x ${TMP}
(cd /tmp; ${PROOT} sh -c "./${TMP}") | tr '\000' ' ' | grep "^/bin/sh ./${TMP} $"

rm ${TMP}
