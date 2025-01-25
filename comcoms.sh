#!/bin/bash

# Commands to run
commands=(  "uname -a"
            "ip a" 
            "cat /etc/os-release"
            "cat /etc/crontab"
            "cat /etc/passwd"
            "sudo cat /etc/shadow"
            "ss -tunlp"
            "ps axjf"
            "systemctl list-units"
            "ss -aemTip" )

# Get output file from env var or set it to output.log
OUTPUT_FILE=${OUTPUT_FILE:-output.log}
echo "INFO: Saving to $OUTPUT_FILE"

# Check if file exists and if we should overwrite it
if [ -f $OUTPUT_FILE ]; then
    read -p "File $OUTPUT_FILE already exists. Continue(y/N)? " -r

    if [[ ! $REPLY =~ ^([Yy]|yes)$ ]]
    then
        exit 1
    fi

    read -p "Would you like to overwrite file(y/N)? " -r

    if [[ $REPLY =~ ^([Yy]|yes)$ ]]
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
        echo "WARNING: Failed to run $command"
    fi
    echo -e "----------$command----------\n$output\nexit: $ecode" >> $OUTPUT_FILE 
done

echo "INFO: Done!"