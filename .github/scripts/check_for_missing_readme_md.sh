#!/bin/sh
#
# Ensure there are Readme.md files in all the project directories
#
set -e
#set -x

fail=0

check_string(){
	needle=$1
	if [ "$(grep "${needle}" $file | wc -l)" -eq "0" ] ; then
		echo missing \"${needle}\" in $file
		fail=1
	else
		if [ "$(grep "${needle}" $file | sed -e "s/${needle}//g" -e "s/ //g" | wc -c)" -lt "8" ] ; then
			 echo missing link for \"${needle}\" in $file
			 fail=1
		fi
	fi
}

MISSING=$(find projects/ -mindepth 1 -maxdepth 1 \( -path projects/common -o -path projects/scripts \) -prune -o -type d '!' -exec test -e "{}/Readme.md" ';' -print)
if [ "$(echo ${MISSING} | wc -c)" -gt "1" ] ; then
	echo Missing Readme.md files in the ${MISSING}
	fail=1
fi

for file in $(find projects/ -mindepth 2 -maxdepth 2 -name Readme.md)
#for file in projects/ad5766_sdz/Readme.md
do
	check_string "Board Product Page"
	check_string "* Parts"
	check_string "* Project Doc"
	check_string "* HDL Doc"
	check_string "* Linux Drivers"
	if [ "$(grep "([[:space:]]*)" $file | wc -l)" -gt "0" ] ; then
		echo "missing link [found ()] in $file"
		fail=1
	fi
	if [ "$(grep https://wiki.analog.com/resources/tools-software/linux-drivers-all $file | wc -l)" -gt "0" ] ; then
		echo "Do not link to https://wiki.analog.com/resources/tools-software/linux-drivers-all in $file"
		fail=1
	fi
	if [ "$(grep https://wiki.analog.com/linux $file | wc -l)" -gt "0" ] ; then
		echo "Do not link to https://wiki.analog.com/linux in $file"
		fail=1
	fi
done

if [ "${fail}" -eq "1" ] ; then
	exit 1
fi
