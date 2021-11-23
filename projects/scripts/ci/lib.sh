#!/bin/sh -e

TRAVIS_BUILD_DIR=${TRAVIS_BUILD_DIR:-'./'}

command_exists() {
	local cmd=$1
	[ -n "$cmd" ] || return 1
	type "$cmd" >/dev/null 2>&1
}

ensure_command_exists() {
	local cmd="$1"
	local package="$2"
	[ -n "$cmd" ] || return 1
	[ -n "$package" ] || package="$cmd"
	! command_exists "$cmd" || return 0
	# go through known package managers
	for pacman in apt-get brew yum ; do
		command_exists $pacman || continue
		$pacman install -y $package || {
			# Try an update if install doesn't work the first time
			$pacman -y update && \
				$pacman install -y $package
		}
		return $?
	done
	return 1
}

ensure_command_exists wget
ensure_command_exists sudo

LOCAL_BUILD_DIR="patches-build"
FULL_BUILD_DIR="${TRAVIS_BUILD_DIR}/${LOCAL_BUILD_DIR}"

# Get the common stuff from libiio
[ -f "${FULL_BUILD_DIR}/lib.sh" ] || {
	mkdir -p "${FULL_BUILD_DIR}"
	wget https://raw.githubusercontent.com/analogdevicesinc/libiio/master/CI/travis/lib.sh \
		-O "${FULL_BUILD_DIR}/lib.sh"
}

. "${FULL_BUILD_DIR}/lib.sh"
