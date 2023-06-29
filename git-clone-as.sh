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
    set +x
    echo
    echo "Usage: ${0} <ssh_clone_uri> <email> <ssh_key_name>"
    echo
    echo "This script uses email for both git user.name and git user.email"
    echo "And assumes that ssh key is in ~/.ssh"
    echo
    exit 1
}

if [[ -z "$1" ]]; then
    usage
fi

DEST=$( echo $1 | awk -F'[/.]' '{print $(NF-1)}' )
NAME=$( echo $2 | awk -F'@' '{print $1}' )
EMAIL=$2
KEY=~/.ssh/$3

if [[ -d $DEST ]]; then
    set +x
    echo
    echo "Directory [$DEST] already exists; check it"
    echo
    usage
fi

if [[ ! -f $KEY ]]; then
    set +x
    echo
    echo "SSH Key [$KEY] does not exist or is not a file; check for presence of ~/.ssh/$KEY"
    echo
    usage
fi

mkdir "$DEST"
cd "$DEST"

git init
git config core.sshcommand "ssh -i $KEY -F /dev/null"
git config user.name "$NAME"
git config user.email "$EMAIL"
git config push.autosetupremotes true
git remote add origin "$1"
git pull origin master
git push --set-upstream origin master
