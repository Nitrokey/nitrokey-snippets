# backup / synchronization example for NetHSM

To run:
```
# will pull containers and start them up
./setup.sh

# generate some dummy contents in hsm1 
./generate_dummy_data.sh

# actually sync to hsm2
./run_sync.sh
```

## Requirements

- docker
- [pynitrokey](https://github.com/Nitrokey/pynitrokey)
