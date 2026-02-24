# This script generates a CA key and a self-signed CA cert. It then generates
# a key on the NetHSM. Then a CSR is created using openssl and pkcs11 and
# processed with the CA key.

set -e

export NETHSM_HOST=localhost:8443
export P11NETHSM_CONFIG_FILE=./p11nethsm.conf

key_id=eekey
nethsm="nitropy nethsm --no-verify-tls --username admin --password adminadmin"

rm *.pem
$nethsm delete-key $key_id || true

# Generate CA key
openssl ecparam -genkey -name prime256v1 -out cakey.pem -outform PEM
# Generate self-signed CA cert
openssl req -x509 -new -key cakey.pem -out cacert.pem -subj "/CN=Test CA"

# Generate EE key
$nethsm generate-key --type ec_p256 --mechanism ecdsa_signature --length 128 --key-id $key_id
# Generate CSR for EE key
OPENSSL_CONF=./openssl.conf openssl req -engine pkcs11 -new -keyform ENGINE -key "pkcs11:object=$key_id" -subj "/CN=EE" -out eecsr.pem -outform PEM

# Generate EE cert signed by CA
openssl x509 -req -in eecsr.pem -inform PEM -CA cacert.pem -CAkey cakey.pem -copy_extensions copy -out eecert.pem -outform PEM
# Print generated EE cert
openssl x509 -in eecert.pem -inform PEM -text

# Verify EE cert against the CA cert
openssl verify -CAfile cacert.pem eecert.pem
# Verify EE cert against the EE key
diff --ignore-blank-lines \
  <(openssl x509 -in eecert.pem -inform PEM -noout -pubkey) \
  <($nethsm get-key $key_id --public-key)
echo "All checks passed"
