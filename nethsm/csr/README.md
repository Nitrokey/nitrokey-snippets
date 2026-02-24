# NetHSM CSR Generation

The scripts in this directory demonstrate how to generate and customize CSRs for keys on the NetHSM.

- `simple.sh` shows the base case of generating and processing a CSR without the NetHSM.
- `simple-nethsm.sh` shows how to generate a CSR on the NetHSM and process it locally, adding x509v3 extensions to the certificates.
- `pkcs11.sh` shows how to generate a CSR via pkcs11 for a key on the NetHSM and specifying x509v3 extensions already in the CSR.

For all scripts except `simple.sh`, you have to first run `start-container.sh` to start the local docker container for testing and then `provision.sh` to setup the container.

For `pkcs11.sh`, you need to update the `dynamic_path` and `MODULE_PATH` settings in `openssl.conf`.

More information on:
- [NetHSM test container](https://docs.nitrokey.com/nethsm/container/test-image)
- [NetHSM PKCS11 module](https://docs.nitrokey.com/nethsm/pkcs11-setup)
- [OpenSSL integration](https://docs.nitrokey.com/nethsm/openssl)

Requirements:
- bash
- pynitrokey
- openssl
- [nethsm-pkcs11](https://github.com/nitrokey/nethsm-pkcs11)
- the pkcs11 engine for openssl provided by [libp11](https://github.com/OpenSC/libp11), e. g. `libp11` on Arch Linux and NixOS or `libengine-pkcs11-openssl` on Debian

Tested with:
- bash 5.3.3
- pynitrokey 0.11.2
- openssl 3.6.1
- nethsm-pkcs11 v2.1.0-rc.2
- libp11 0.4.13
