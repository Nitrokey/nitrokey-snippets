#!/bin/bash

set -euxo pipefail

source includes.sh


hsm1-cmd-admin generate-key --type RSA --mechanism RSA_Signature_PSS_SHA256 --length 2048 --key-id FirstDummy
hsm1-cmd-admin generate-key --type RSA --mechanism RSA_Signature_PSS_SHA256 --length 4096 --key-id SecondDummy



