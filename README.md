# local-https
A quick script to start up an https proxy for your localhost. Complete with self-signed cert generation and teardown all built in.

## Getting started
1. Determine the network/IP you want to listen with `ifconfig`. Should be the the have a LAN ip and look like `en0` or `en1`.
2. Run `./install.sh en0`
2. Done.
