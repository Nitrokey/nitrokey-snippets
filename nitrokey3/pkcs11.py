# RSA 2048 key generation on the Nitrokey 3 using OpenSC and pkcs11
# Note that this uses the first connected token and the default PINs.

from PyKCS11 import *

# Make sure that the PYKCS11LIB env variable is set
pkcs11 = PyKCS11Lib()
pkcs11.load()

slot = pkcs11.getSlotList(tokenPresent=True)[0]

session = pkcs11.openSession(slot, CKF_SERIAL_SESSION | CKF_RW_SESSION)
session.login("12345678", CKU_SO)

pubTemplate = [
    (CKA_CLASS, CKO_PUBLIC_KEY),
    (CKA_TOKEN, CK_TRUE),
    (CKA_MODULUS_BITS, 2048),
    (CKA_PUBLIC_EXPONENT, (0x01, 0x00, 0x01)),
    (CKA_ENCRYPT, CK_TRUE),
    (CKA_VERIFY, CK_TRUE),
    (CKA_KEY_TYPE, CKK_RSA),
]

privTemplate = [
    (CKA_CLASS, CKO_PRIVATE_KEY),
    (CKA_TOKEN, CK_TRUE),
    (CKA_PRIVATE, CK_TRUE),
    (CKA_SENSITIVE, CK_TRUE),
    (CKA_DECRYPT, CK_TRUE),
    (CKA_SIGN, CK_TRUE),
    (CKA_KEY_TYPE, CKK_RSA),
]

(pubKey, privKey) = session.generateKeyPair(pubTemplate, privTemplate)

session.logout()
session.closeSession()

print("keypair generated")
