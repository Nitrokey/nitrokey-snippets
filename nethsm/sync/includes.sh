#!/bin/bash


export BACKUP_PASSPHRASE=ILikeBackupsVeryMuch

export HSM1_CMD="nitropy nethsm --no-verify-tls --host 127.0.0.1:18443"
export HSM1_UNLOCK_PW="1234unlock"
export HSM1_ADMIN_PW="12345admin"
export HSM1_OP_PW="12operator"
export HSM1_BACKUP_PW="1234backup"
export HSM1_PORT="18443"

export HSM2_CMD="nitropy nethsm --no-verify-tls --host 127.0.0.1:28443"
export HSM2_UNLOCK_PW="4321unlock"
export HSM2_ADMIN_PW="54321admin"
export HSM2_PORT="28443"

function hsm1-cmd 
{
  $HSM1_CMD "$@"
}

function hsm1-cmd-admin
{
  $HSM1_CMD -u admin -p $HSM1_ADMIN_PW "$@"
}

function hsm1-cmd-op
{
  $HSM1_CMD -u operator1 -p $HSM1_OP_PW "$@"
}

function hsm1-cmd-backup
{
  $HSM1_CMD -u backup1 -p $HSM1_BACKUP_PW "$@"
}

function hsm2-cmd 
{
  $HSM2_CMD "$@"
}

function hsm2-cmd-admin
{
  $HSM2_CMD -u admin -p $HSM2_ADMIN_PW "$@"
}




