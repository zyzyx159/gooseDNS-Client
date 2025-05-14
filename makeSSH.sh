#!/bin/sh

# Define the path to the SSH key
SSH_KEY_PATH="/home/clean/.ssh/id_rsa"

# Check if the SSH key already exists
if [ ! -f "$SSH_KEY_PATH" ]; then
    # Generate the SSH key
    ssh-keygen -t rsa -b 4096 -f "$SSH_KEY_PATH" -N ""
    SSH_KEY_PATH="${SSH_KEY_PATH}.pub"
    #echo $SSH_KEY_PATH
    echo "$(cat $SSH_KEY_PATH)"
else
    echo "SSH key already exists at $SSH_KEY_PATH"
fi

# Run the original command
exec "$@"