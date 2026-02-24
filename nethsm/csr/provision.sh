export NETHSM_HOST=localhost:8443

nitropy nethsm --no-verify-tls provision --unlock-passphrase unlockunlock --admin-passphrase adminadmin
nitropy nethsm --no-verify-tls --username admin --password adminadmin add-user --real-name Operator --user-id operator --passphrase operatoroperator --role Operator
