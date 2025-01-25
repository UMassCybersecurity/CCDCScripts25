#!/bin/bash

# NOTE: these updates will only affect new users!
PARAMS=("PASS_MAX_DAYS=30"
        "PASS_MIN_DAYS=1"
        "PASS_WARN_AGE=5"
        "LOGIN_RETRIES=3"
        "LOGIN_TIMEOUT=30"
        "PASS_MIN_LEN=16")

TARGET=/etc/login.defs
echo -e "\n\n----------PROGRAM ADDED----------\n" >> $TARGET

for param in ${PARAMS[@]}; do
    KEY=${param%%=*}
    sed -i -E "s/(^ *$KEY=.*$)/#\1/" $TARGET
    echo "$param" >> $TARGET
done