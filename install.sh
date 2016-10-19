#!/bin/bash
HOSTS_FILE="/private/etc/hosts"
HOSTNAME="www.fake-ssl.com"
LOCAL_IP=$(ipconfig getifaddr "${1:-en0}")

function build_ssl() {
	echo -n "Generating ssl cert"
	if [ ! -d ./ssl ]; then
		echo "..."
		mkdir -p ./ssl \
			&& cd "$_" || exit 1

		sudo openssl req -x509 -sha256 -newkey rsa:2048 -keyout cert.key -out cert.pem -days 1024 -nodes -subj '/CN=$(HOSTNAME)'
		echo "done."
	else
		echo "...skipped. Certs already generated."
	fi
}

function add_hosts() {
	echo -n "Adding host file entry"
	if ! grep -q "$HOSTNAME" "$HOSTS_FILE"; then
		echo "..."
		CMD="echo -e \"${LOCAL_IP}\t${HOSTNAME}\n\" >> ${HOSTS_FILE}"
		sudo bash -c "${CMD}"
		echo "done."
	else
		echo "...skipped. Already exists."
	fi
}

build_ssl
add_hosts

LOCAL_IP=${LOCAL_IP} docker-compose stop \
	&& LOCAL_IP=${LOCAL_IP} docker-compose rm -f \
	&& LOCAL_IP=${LOCAL_IP} docker-compose up -d
