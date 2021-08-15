#!/bin/sh

PROGNAME=$(basename $0)
VERSION="0.0.2"

echo -n "type linux username: "
read USERNAME
if [ -z $USERNAME ]; then
    echo "user doesn't created(username is empty)"
    exit 1
fi

echo -n "type github username: "
read GIT_USERNAME
if [ -z $GIT_USERNAME ]; then
    echo "user doesn't created(github username is empty)"
    exit 1
fi

echo "create a user below?"
echo "user: ${USERNAME}"
if [ -n $GIT_USERNAME ]; then
    echo "github username: ${GIT_USERNAME}"
fi
echo -n "(y/n):"
read str
if [ $str != "y" ]; then
    echo "user doesn't created"
    exit 0
fi

adduser ${USERNAME}
gpasswd -a ${USERNAME} sudo

mkdir -p /home/${USERNAME}/.ssh

if [ -n $GIT_USERNAME ] ; then
    curl https://github.com/${GIT_USERNAME}.keys > /home/${USERNAME}/.ssh/authorized_keys
    chmod 600 /home/${USERNAME}/.ssh/authorized_keys
    chown ${USERNAME} /home/${USERNAME}/.ssh/authorized_keys
fi
