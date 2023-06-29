#!/usr/bin/env bash
##############################################################
# Script to clone repositories from my personal github account
# Modified from this: https://atornblad.se/use-a-different-user-account-for-each-git-repo
# 
# USAGE:
# ./clone.sh DIRNAME SSH-GITHUB-URL
# 
# EXAMPLE:
# ./clone.sh some-repo git@github.com:atornblad/some-repo.git
##############################################################
set -x
set -e

function usage(){
    echo "Usage: ${0} <ssh_clone_uri> <email> <ssh_key_name>"
    echo
    echo "This script uses email for both git user.name and git user.email"
    echo "And assumes that ssh key is in ~/.ssh"
    echo
    exit 1
}

DEST=$( echo $1 | awk -F'[/.]' '{print $(NF-1)}' )
NAME=$2
EMAIL=$2
KEY=$3

if [[ -d $DEST ]]; then
    set +x
    echo
    echo "Directory [$DEST] already exists; check it"
    echo
    exit 1
fi

if [[ ! -f $KEY ]]; then
    set +x
    echo
    echo "SSH Key [$KEY] does not exist; check for presence of ~/.ssh/$KEY"
    echo
    exit 1
fi

mkdir "$DEST"
cd "$DEST"

git init
git config --local core.sshcommand "ssh -i ~/.ssh/$KEY -F /dev/null"
git config --local user.name "$NAME"
git config --local user.email "$EMAIL"
git config --local push.autosetupremotes true
git remote add origin "$1"
git pull origin master
