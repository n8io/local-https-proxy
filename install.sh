#!/bin/bash
HOSTS_FILE="/private/etc/hosts"
HOSTNAME="www.fake-ssl.com"
LOCAL_IP=$(ipconfig getifaddr "${1:-en0}")

COLOR_RESET="$(tput sgr0)"
COLOR_GREEN="$(tput setaf 2)"
COLOR_YELLOW="$(tput setaf 3)"

function build_ssl() {
	echo -e -n "${COLOR_GREEN}Generating ssl cert${COLOR_RESET}..."
	if [ ! -d ./ssl ]; then
		mkdir -p ./ssl \
			&& cd "$_" || exit 1

		sudo openssl req -x509 -sha256 -newkey rsa:2048 -keyout cert.key -out cert.pem -days 1024 -nodes -subj '/CN=$(HOSTNAME)'
		echo -e "${COLOR_GREEN}done.${COLOR_RESET}"
	else
		echo "skipped. Certs already generated."
	fi
}

function add_hosts() {
	echo -e "${COLOR_GREEN}Adding host file entry...${COLOR_RESET}"
	sed -n "/${HOSTNAME}/!p" /private/etc/hosts > temp && sudo mv temp "${HOSTS_FILE}"
	CMD="echo -e \"${LOCAL_IP}\t${HOSTNAME}\" >> ${HOSTS_FILE}"
	sudo bash -c "${CMD}"
	echo -e "${COLOR_GREEN}done.${COLOR_RESET}"
}

function tear_down() {
	echo -e "${COLOR_GREEN}Cleaning up...${COLOR_RESET}"
	sed -n "/${HOSTNAME}/!p" "${HOSTS_FILE}" > temp && sudo mv temp "${HOSTS_FILE}"
	LOCAL_IP=${LOCAL_IP} docker-compose stop
	LOCAL_IP=${LOCAL_IP} docker-compose rm -f
	echo -e "${COLOR_GREEN}done.${COLOR_RESET}"
}

build_ssl
add_hosts

echo -e "${COLOR_YELLOW}Starting https proxy... Press Ctrl+C to shutdown.${COLOR_RESET}"
LOCAL_IP=${LOCAL_IP} docker-compose up
tear_down
echo -e "${COLOR_GREEN}Proxy shutdown successfully.${COLOR_RESET}"
