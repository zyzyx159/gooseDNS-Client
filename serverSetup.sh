#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# User and directory names
USERNAME="username"
HOMEDIR="/home/$USERNAME"
CHROOTDIR="$HOMEDIR"
USERHOMEDIR="$CHROOTDIR/home/$USERNAME"

# Create the user without a password and a restricted shell
adduser --disabled-password --shell /usr/sbin/nologin $USERNAME

# Create the necessary directories
mkdir -p $CHROOTDIR
chown root:root $CHROOTDIR
chmod 755 $CHROOTDIR

mkdir -p $USERHOMEDIR
chown $USERNAME:$USERNAME $USERHOMEDIR
chmod 700 $USERHOMEDIR

# Create the .ssh directory and authorized_keys file
mkdir -p $USERHOMEDIR/.ssh
chown $USERNAME:$USERNAME $USERHOMEDIR/.ssh
chmod 700 $USERHOMEDIR/.ssh

# Copy the public key to the authorized_keys file
# Replace /path/to/authorized_keys with the path to your public key file
touch $USERHOMEDIR/.ssh/authorized_keys
chown $USERNAME:$USERNAME $USERHOMEDIR/.ssh/authorized_keys
chmod 600 $USERHOMEDIR/.ssh/authorized_keys

# Configure SSH settings
cat <<EOL >> /etc/ssh/sshd_config
Match User $USERNAME
    ChrootDirectory $CHROOTDIR
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
    AllowAgentForwarding no
EOL

# Restart the SSH service
systemctl restart sshd

echo "User $USERNAME created and configured successfully."