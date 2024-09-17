#!/bin/bash

# Checking if the users has provided the required arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 user1 [user2 ... userN]"
    exit 1
fi

# Check if user is exist
for user in "$@"; do
    if ! id "$user" &>/dev/null; then
        echo "User $user does not exist"
        exit 1
    fi
done

# Start of the script
echo "Creating SSH key pairs for the following users: $@"

# Defining the variables
SSH_DIR="/home/$1/.ssh"

# Loop through the users and create the .ssh directory
for user in "$@"; do
    SSH_DIR="/home/$user/.ssh"
    if [ ! -d "$SSH_DIR" ]; then
        mkdir -p "$SSH_DIR"
        chown -R "$user:$user" "$SSH_DIR"
        chmod 700 "$SSH_DIR"
    fi
done

# Loop through the users and create the ssh key pair
for user in "$@"; do
    SSH_DIR="/home/$user/.ssh"
    if [ ! -f "$SSH_DIR/id_rsa" ]; then
        ssh-keygen -t rsa -b 4096 -C "$user@$(hostname)" -f "$SSH_DIR/id_rsa" -N ""
        chown "$user:$user" "$SSH_DIR/id_rsa" "$SSH_DIR/id_rsa.pub"
        chmod 600 "$SSH_DIR/id_rsa"
        chmod 644 "$SSH_DIR/id_rsa.pub"
    fi
done

# End of the script
echo "SSH key pairs have been created successfully"
exit 0