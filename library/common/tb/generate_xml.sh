#!/bin/bash

##############################################################################
## Copyright (C) 2014-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: BSD-1-Clause
##############################################################################

# Depending on simulator, search for errors or 'SUCCESS' keyword in specific log
if [[ "$SIMULATOR" == "modelsim" ]]; then
	ERRS=`grep -i -e '# Error ' -e '# Fatal' -e '# Failed' -C 10 ${NAME}_modelsim.log`
	SUCCESS=`grep 'SUCCESS' ${NAME}_${SIMULATOR}.log`
elif [[ "$SIMULATOR" == "xsim" ]]; then
	ERRS=`grep -v ^# ${NAME}_xvlog.log | grep -w -i -e error -e fatal -e fatal_error -e failed -C 10`
	ERRS=$ERRS`grep -v ^# ${NAME}_xelab.log | grep -w -i -e error -e fatal -e fatal_error -e failed -C 10`
	ERRS=$ERRS`grep -v ^# ${NAME}_xsim.log | grep -w -i -e error -e fatal -e fatal_error -e failed -C 10`
	SUCCESS=`grep 'SUCCESS' ${NAME}_xsim.log`
else
	echo "XML file is generated only for 'modelsim' and 'xsim' simulators."
	echo "Check that variable SIMULATOR is exported and is set to one of those."
fi

# If DURATION is not defined, try to extract it from log file. If it's not found, just use 0
if [[ -z ${DURATION+x} ]]; then
	DURATION=$(grep -i 'elapsed' ${NAME}_${SIMULATOR}.log | cut -d ' ' -f '10')
	if [[ -z "$DURATION" ]]; then DURATION="0";fi
fi

#Generate xml file
xmlFile="${NAME}.xml"
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>" > $xmlFile
echo -e "<testsuite>" >> $xmlFile
echo -e "\t<testcase name=\"${NAME}\" time=\"${DURATION}\" classname=\"component_tb\">" >> $xmlFile
if [[ "$ERRS" ]]; then
	#replace < with &lt; and > with &gt; in ERRS to not broke created xml
	ERRS=$(echo $ERRS | sed 's/</&lt;/g' | sed 's/>/&gt;/g')
	echo -e "\t\t<failure>\n\"$ERRS\"\n\t\t</failure>" >> $xmlFile
elif [[ "$SUCCESS" ]]; then
	echo -e "\t\t<passed/>" >> $xmlFile
else	#There is no error or 'SUCCESS' keyword in log file - set result to 'Skipped'
	echo -e "<skipped>" >> $xmlFile
	echo -e "\tThe log file does not contain any errors or 'SUCCESS' keyword." >> $xmlFile
	echo -e "\tLog file was not created properly or the testbench is not automated" >> $xmlFile
	echo -e "</skipped>" >> $xmlFile
fi
echo -e "\t</testcase>" >> $xmlFile
echo "</testsuite>" >> $xmlFile
