# This script generates a CA key and a self-signed CA cert. It then generates
# a key on the NetHSM and a corresponding CSR. Then the CSR is processed with
# the CA key while adding more extensions.

set -e

export NETHSM_HOST=localhost:8443

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
$nethsm csr --key-id $key_id --country "" --state-or-province "" --locality "" --organization "" --organizational-unit "" --email-address "" --common-name "EE" > eecsr.pem

# Generate EE cert signed by CA
openssl x509 -req -in eecsr.pem -inform PEM -CA cacert.pem -CAkey cakey.pem -out eecert.pem -outform PEM \
  -extfile <(echo "1.2.3.4=ASN1:UTF8String:Some random data")
# Print generated EE cert
openssl x509 -in eecert.pem -inform PEM -text

# Verify EE cert against the CA cert
openssl verify -CAfile cacert.pem eecert.pem
# Verify EE cert against the EE key
diff --ignore-blank-lines \
  <(openssl x509 -in eecert.pem -inform PEM -noout -pubkey) \
  <($nethsm get-key $key_id --public-key)
echo "All checks passed"
