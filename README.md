# local-https
A quick script to start up an https proxy using Docker. Complete with self-signed cert generation and teardown all built in.

## What it does
Routes traffic for `https://www.fake-ssl.com` to your app running at `http://localhost:3000`. Does so through a docker container and hosts file entry.

## Requirements
1. Only tested on a MacOSX
2. An app running on port 3000 locally. (This can be tweaked in the `./install.sh` script)
3. Docker and docker-compose installed.

## Getting started
1. Run `ifconfig`
2. Determine which network adapter your are using. It should be the one that has a LAN ip. The entry we're looking for looks like `en0` or `en1`.
2. Run `./install.sh en0 # or en1 or other`
2. Done.

## Why is asking for my password?
Part of the proxy creation requires writing an entry to your `hosts` file. That requires `sudo` permissions to edit.


## Credits
	Credit for the process goes to Shane Stillwell and his blog post [Create a local HTTPS proxy server](https://www.shanestillwell.com/2016/10/03/create-a-local-https-proxy-server). All I did was bundle it up into a tidy shell script.
