<!--
Copyright (C) Nitrokey GmbH
SPDX-License-Identifier: Unlicense
-->

# Using the Nitrokey 3 with libfido2

This example shows how to use the Nitrokey 3 with [libfido2][].
It contains two parts:
- `list-devices.c` lists all connected FIDO2 devices.
- `list-credentials.c` lists the discoverable credentials on a single FIDO2 device.

[libfido2]: https://github.com/yubico/libfido2

## Requirements

- [libfido2][]

## Example

```
$ make
gcc     list-credentials.c  -lfido2 -o list-credentials
gcc     list-devices.c  -lfido2 -o list-devices

$ ./list-devices
1 FIDO2 device connected:
- /dev/hidraw0: Nitrokey Nitrokey 3 (20a0:42b2)

$ ./list-credentials /dev/hidraw0 123456
existing credentials:  3
remaining credentials: 7
- webauthn.io
  - id: a30582b874b57825fe8bf3af78f48c164bfc189ac5bb1d874d855a04adbb7117c3343ca54104e5dec882537dbc7f14c124a333207e63424f28ae76250bc6ff7ee92bfed4b4e79c41b28cfa3b
    user: robin
  - id: a30582b47b910b8af9553c06449298e1b75c5dfe68dd693ecfb84774658cc4fee09a19b2d3a58149f68dd961714c5196af79e4f1ddcea6da882503d9dc73325c1adc76848cbd7b45e432
    user: robin2
  - id: a30582e3b57e99e2b47c698e8451851dc3fb1687c27b5d6ee1c60df706b4fe2ad7c8351ca31625b22422857bd78a221514cf55461826991f3b4b714fe250f1802537457c4863c6fa7cfa48f83
    user: robin2
```
