cerberus --cpp='cc -E -nostdinc -undef -D__cerb__ -I $CERB_PATH/include/c/libc -I $CERB_PATH/include/c/posix -DCSMITH_MINIMAL -I ../runtime' --sequentialise --exec $@
