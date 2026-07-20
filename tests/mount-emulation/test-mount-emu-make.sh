if [ -z `which make` ]; then
    exit 125;
fi

${PROOT} make -f ${PWD}/test-mount-emu-make.mk
