#!/bin/bash
set -e

. ./projects/scripts/ci/lib.sh

ENV_VARS="BUILD_TYPE DEFCONFIG ARCH CROSS_COMPILE DTS_FILES IMAGE"
ENV_VARS="$ENV_VARS TRAVIS_COMMIT TRAVIS_PULL_REQUEST CHECK_ALL_ADI_DRIVERS_HAVE_BEEN_BUILT"

if [ "$DO_NOT_DOCKERIZE" = "1" ] ; then
	. ./projects/scripts/ci/run-build.sh
else
	cat /dev/null > "${FULL_BUILD_DIR}/env"
	BUILD_TYPE=${BUILD_TYPE:-default}
	for env in $ENV_VARS ; do
		val="$(eval echo "\$${env}")"
		if [ -n "$val" ] ; then
			echo "export ${env}=${val}" >> "${FULL_BUILD_DIR}/env"
		fi
	done
	export OS_TYPE=ubuntu
	export OS_VERSION=latest
	prepare_docker_image
	run_docker_script run-build.sh
fi
