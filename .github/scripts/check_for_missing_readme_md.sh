#!/bin/sh

##############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
#
# The purpose of this script:
## Ensure there are README.md (case insensitive name) files in all the project directories
##############################################################################

set -e
#set -x

fail=0

check_string() {
	needle=$1
	if [ "$(grep "${needle}" $file | wc -l)" -eq "0" ] ; then
		echo In $file: missing \"${needle}\"
		fail=1
	else
		if [ "$(grep "${needle}" $file | sed -e "s/${needle}//g" -e "s/ //g" | wc -c)" -lt "8" ] ; then
			 echo In $file: missing link for \"${needle}\"
			 fail=1
		fi
	fi
}

MISSING=$(find projects/ -mindepth 1 -maxdepth 1 \( -path projects/common -o -path projects/scripts \) -prune -o -type d '!' -exec test -e "{}/README.md" ';' -print)
if [ "$(echo ${MISSING} | wc -c)" -gt "1" ] ; then
	echo "Missing README.md files in ${MISSING}"
	fail=1
fi

for file in $(find projects/ -mindepth 2 -maxdepth 2 -iname README.md)
do
	check_string "Board Product Page"
	check_string "* Parts"
	check_string "* Project Doc"
	check_string "* HDL Doc"
	check_string "* Linux Drivers"

	if [ "$(grep "([[:space:]]*)" $file | wc -l)" -gt "0" ] ; then
		echo "In $file: missing link; found ()"
		fail=1
	fi
	if [ "$(grep https://wiki.analog.com/resources/tools-software/linux-drivers-all $file | wc -l)" -gt "0" ] ; then
		echo "In $file: do not link to https://wiki.analog.com/resources/tools-software/linux-drivers-all"
		fail=1
	fi
	if [ "$(grep https://wiki.analog.com/linux $file | wc -l)" -gt "0" ] ; then
		echo "In $file: do not link to https://wiki.analog.com/linux"
		fail=1
	fi
done

if [ "${fail}" -eq "1" ] ; then
	exit 1
fi
