#!/usr/bin/env bash
##############################################################
# DESCRIPTION:  Do rsync backup to a dest
#
#   TO DO
#   * mkdir if dir matching source doesn't exist inside backup
#     dir on dest
#   * Check disk space before running ?
##############################################################
set -x
set -e

function usage(){
    set +e
    set +x
    if [[ -n "${1}" ]]; then
        echo
        echo "ERROR: ${*}"
    fi
    echo
    echo "Before running this script:"
    echo "  1. make sure SSH KEY AUTH TO DEST HOST is configured"
    echo "  2. make sure DEST DIR EXISTS and has enough space"
    echo
    echo "Usage:"
    echo
    echo "$0 SOURCE_DIR DEST_HOST DEST_DIR"
    echo
    exit 1
}

SOURCE_DIR="${1:-FALSE}"
DEST_HOST="${2:-FALSE}"
DEST_DIR="${3:-FALSE}"

BACKUP_LOG="${HOME}/$( echo "${SOURCE_DIR}" | sed 's/^[^a-zA-Z0-9]//g; s/[^a-zA-Z0-9]/-/g; s/-$//g' )-rsync-backup.log"

if [[ "${SOURCE_DIR}" == "FALSE" ]]; then
    usage
fi

if ! ssh ${DEST_HOST} "ls -d '${DEST_DIR}' 2>/dev/null " ; then
    usage "Destination dir [${DEST_DIR}] does not exist on server"
fi

# this isn't ideal
if ! rsync --version >/dev/null 2>&1;  then
    sudo apt-get update
    sudo apt-get install -y rsync
fi


#this also isn't ideal
rsync -av \
    ${SOURCE_DIR}/ \
    ${DEST_HOST}:${DEST_DIR}/${SOURCE_DIR}/ \
    | tee  -a "${BACKUP_LOG}"

