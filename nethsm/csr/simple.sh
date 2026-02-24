# This script generates a CA key, a self-signed CA cert and a EE key. It then
# creates a CSR for the EE key without specifying extensions. Then the CSR is
# processed with the CA key while adding more extensions.

set -e

rm *.pem

# Generate CA key
openssl ecparam -genkey -name prime256v1 -out cakey.pem -outform PEM
# Generate self-signed CA cert
openssl req -x509 -new -key cakey.pem -out cacert.pem -subj "/CN=Test CA"

# Generate EE key
openssl ecparam -genkey -name prime256v1 -out eekey.pem -outform PEM
# Generate CSR for EE key
openssl req -new -key eekey.pem -subj "/CN=EE" -out eecsr.pem -outform PEM

# Generate EE cert signed by CA
openssl x509 -req -in eecsr.pem -inform PEM -CA cacert.pem -CAkey cakey.pem -out eecert.pem -outform PEM \
  -extfile <(echo "1.2.3.4=ASN1:UTF8String:Some random data")
# Print generated EE cert
openssl x509 -in eecert.pem -inform PEM -text

# Verify EE cert against the CA cert
openssl verify -CAfile cacert.pem eecert.pem
# Verify EE cert against the EE key
diff \
  <(openssl x509 -in eecert.pem -inform PEM -noout -pubkey) \
  <(openssl ec -in eekey.pem -inform PEM -pubout)
echo "All checks passed"
