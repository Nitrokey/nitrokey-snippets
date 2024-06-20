#!/bin/bash

set -euxo pipefail

source includes.sh


hsm1-cmd-backup backup /tmp/nethsm.test-backup.bin

hsm2-cmd-admin restore --backup-passphrase $BACKUP_PASSPHRASE /tmp/nethsm.test-backup.bin 




