#!/bin/bash

# Root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Get users with valid shell (not nologin or false)
users=($(cat /etc/passwd | grep -v -e "/nologin$" -e "/false$" | cut -d: -f1))
users_len=${#users[@]} 

num_re='^[0-9]+$'

function print_user_list {
    echo Users:
    for i in ${!users[@]}; do
        echo $i: ${users[i]}
    done
}

function validate_users {
    print_user_list
    read -p "Select user to remove or continue (0-$((users_len-1)),C): " -r

    if [[ $REPLY =~ ^[Cc]$ || -z $REPLY ]]
    then
        return
    fi

    if [[ ! $REPLY =~ $num_re ]]
    then
        echo Invalid input $REPLY
    else
        num=$(($REPLY))
        if [[ $num -ge $users_len ]]
        then
            echo $num is out of range
        else
            unset users[$num]
            users=( ${users[@]} ) # fix weird bash indexing
            users_len=$((users_len-1))
        fi
    fi

    validate_users
}

validate_users

read -p "Are you sure you want to change these passwords(y/N)? " -r
if [[ ! $REPLY =~ ^([Yy]|yes)$ ]]
then
    exit 1
fi

for user in ${users[@]}; do
    password=$(tr -dc 'A-Za-z0-9!?%=' < /dev/urandom | head -c 10)
    echo -e "$password\n$password" | passwd $user 1>/dev/null
    if (($? == 0)); then
        echo "New password for $user: $password"
    else
        echo "WARNING: Failed to set password for $user"
    fi
done