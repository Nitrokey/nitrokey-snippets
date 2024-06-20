#!/bin/bash

set -euxo pipefail


# check for existing names, stop, remove 
docker stop -t 2 nethsm1 || true
docker stop -t 2 nethsm2 || true
docker rm nethsm1 || true
docker rm nethsm2 || true


# pull latest container
docker pull nitrokey/nethsm:testing

source includes.sh

# startup 2 nethsm instances 
docker run -d --name nethsm1 -p ${HSM1_PORT}:8443 nitrokey/nethsm:testing
docker run -d --name nethsm2 -p ${HSM2_PORT}:8443 nitrokey/nethsm:testing

# wait for working comms
while ! hsm1-cmd info; do echo "nethsm1 not ready - retrying"; sleep 1; done
while ! hsm2-cmd info; do echo "nethsm2 not ready - retrying"; sleep 1; done

# provision both instances
hsm1-cmd provision --unlock-passphrase $HSM1_UNLOCK_PW --admin-passphrase $HSM1_ADMIN_PW
hsm2-cmd provision --unlock-passphrase $HSM2_UNLOCK_PW --admin-passphrase $HSM2_ADMIN_PW

hsm1-cmd-admin add-user --real-name "Nitrokey Operator" --role Operator --user-id operator1 --passphrase $HSM1_OP_PW
hsm1-cmd-admin add-user --real-name "Nitrokey Backupper" --role Backup --user-id backup1 --passphrase $HSM1_BACKUP_PW

hsm1-cmd-admin set-backup-passphrase --new-passphrase $BACKUP_PASSPHRASE --force

