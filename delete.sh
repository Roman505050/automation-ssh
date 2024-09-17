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
echo "Deleting the SSH key pairs for the following users: $@"

# Defining the variables
SSH_DIR="/home/$1/.ssh"

# Loop through the users and delete the ssh key pair
for user in "$@"; do
    SSH_DIR="/home/$user/.ssh"
    if [ -f "$SSH_DIR/id_rsa" ]; then
        rm -f "$SSH_DIR/id_rsa" "$SSH_DIR/id_rsa.pub"
    fi
done

# End of the script
echo "SSH key pairs have been deleted successfully"
exit 0