#!/usr/bin/env bash

set -e

TMP_DIR="/var/www/tmp"

display_help() {
	echo "NPM Installer script v1.1.0"
	echo "usage: bash $(basename $0) [install|update|update_with_ncu|move_tmp|move_current]"
	exit 0
}

if [ $# -ne 1 ]; then
	echo 'Error: Required One arguments'
	display_help
	exit 1
fi

if [ $1 == '--help' ]; then
	display_help
fi

CURRENT_DIR=$(pwd)
echo "current dir: ${CURRENT_DIR}"

if [ -z "$CURRENT_DIR" ]; then
	echo 'Error: current dir not found'
	exit 1
fi

echo "temp dir: ${TMP_DIR}"

if [ ! -d "${TMP_DIR}" ]; then
	echo 'Error: tmp dir not found'
	exit 1
fi

npm_install() {
	echo "[Info] npm install";
	npm install
	npm audit fix
}

npm_update() {
	echo "[Info] npm update";
	npm update
	npm audit fix
}

update_package_json_with_ncu() {
	echo "[Info] update package.json";
	ncu
	ncu -u
}

move_to_tmp_dir() {
	echo "[Info] Moving package.json, package-lock.json and node_modules to ${TMP_DIR}";

	if [ -f package.json ]; then
		mv package.json ${TMP_DIR}
	fi
	if [ -f package-lock.json ]; then
		mv package-lock.json ${TMP_DIR}
	fi
	if [ -d node_modules ]; then
		mv node_modules ${TMP_DIR}
	fi

	cd ${TMP_DIR}
	echo "[Info] move working dir to ${TMP_DIR}";
}

move_to_current_dir() {
	cd ${CURRENT_DIR}
	echo "[Info] move working dir to ${CURRENT_DIR}";
	echo "[Info] Moving package.json, package-lock.json and node_modules to current dir";

	if [ -f ${TMP_DIR}/package.json ]; then
		mv ${TMP_DIR}/package.json ./
	fi
	if [ -f ${TMP_DIR}/package-lock.json ]; then
		mv ${TMP_DIR}/package-lock.json ./
	fi
	if [ -d ${TMP_DIR}/node_modules ]; then
		mv ${TMP_DIR}/node_modules ./
	fi
}

if [ $1 = 'install' ]; then
	move_to_tmp_dir
	npm_install
	move_to_current_dir
elif [ $1 = 'update' ]; then
	move_to_tmp_dir
	npm_update
	move_to_current_dir
elif [ $1 = 'update_with_ncu' ]; then
	move_to_tmp_dir
	update_package_json_with_ncu
	npm_install
	move_to_current_dir
elif [ $1 = 'move_tmp' ]; then
	move_to_tmp_dir
elif [ $1 = 'move_current' ]; then
	move_to_current_dir
fi

exit 0
