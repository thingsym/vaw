#!/usr/bin/env bash

set -e

TMP_DIR="/var/www/tmp"

if [ $1 == '--help' ]; then
  echo "NPM Installer script v1.0.0"
  echo "usage: bash bin/npm-installer.sh [install|update|move_tmp|move_current]"
  exit 0
fi

if [ $# -ne 1 ]; then
  echo 'Error: Required One arguments'
  exit 1
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

update_package_json() {
	echo "[Info] update package.json";
	ncu
	ncu -u
}

move_to_tmp_dir() {
	echo "[Info] Moving package.json, package-lock.json and node_modules to ${TMP_DIR}";
	mv package.json ${TMP_DIR}
	mv package-lock.json ${TMP_DIR}
	mv node_modules ${TMP_DIR}
	cd ${TMP_DIR}
	echo "[Info] move working dir to ${TMP_DIR}";
}

move_to_current_dir() {
	cd ${CURRENT_DIR}
	echo "[Info] move working dir to ${CURRENT_DIR}";
	echo "[Info] Moving package.json, package-lock.json and node_modules to current dir";
	mv ${TMP_DIR}/package.json ./
	mv ${TMP_DIR}/package-lock.json ./
	mv ${TMP_DIR}/node_modules ./
}

if [ $1 = 'install' ]; then
	move_to_tmp_dir
	npm_install
	move_to_current_dir
elif [ $1 = 'update' ]; then
	move_to_tmp_dir
	update_package_json
	npm_install
	move_to_current_dir
elif [ $1 = 'move_tmp' ]; then
	move_to_tmp_dir
elif [ $1 = 'move_current' ]; then
	move_to_current_dir
fi

exit 0
