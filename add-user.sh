#!/bin/sh

PROGNAME=$(basename $0)
VERSION="0.0.1"

usage_exit() {
        echo "Usage: $PROGNAME [OPTIONS] username"
        echo "  This script is create ssh user using github ssh keys."
        echo
        echo "Options:"
        echo "  -h"
        echo "  -v"
        echo "  -g [GIT_USERNAME]"
        echo
        exit 1
}

while getopts g: OPT
do
    case $OPT in
        "g" )
            GIT_USERNAME="$OPTARG"
            ;;
        "h")
            usage_exit
            ;;
        \?) usage_exit
            ;;
    esac
done

shift `expr "${OPTIND}" - 1`

if [ $# -lt 1 ]; then
    usage_exit
fi

USERNAME=$1

echo "create a user below?"
echo "user: ${USERNAME}"
if [ -n $GIT_USERNAME ]; then
    echo "github username: ${GIT_USERNAME}"
fi
echo -n "type (y/n):"
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
