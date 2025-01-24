#!/bin/sh

# Commands to run
commands=( "uname -a" "cat /etc/os-release" "ps axjf" "ss -tunlp" "cat /etc/passwd" "sudo cat /etc/shadow" "ss -aemTip" )

# Get output file from env var or set it to output.log
OUTPUT_FILE=${OUTPUT_FILE:-output.log}
echo "INFO: Saving to $OUTPUT_FILE"

# Check if file exists and if we should overwrite it
if [ -f $OUTPUT_FILE ]; then
    read -p "File $OUTPUT_FILE already exists. Continue(y/n)? " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi

    read -p "Would you like to overwrite file(y/n)? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        > $OUTPUT_FILE
    fi
fi

# Run commands
for i in ${!commands[@]}; do
    command=${commands[i]}
    echo "INFO: Running $command"
    output=$($command 2>&1)
    ecode=$?
    if ((ecode != 0)); then
        echo "WARNING: failed to run $command"
    fi
    echo -e "----------$command----------\n$output\nexit: $ecode" >> $OUTPUT_FILE 
done

echo "INFO: Done!"