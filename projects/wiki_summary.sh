#!/bin/sh
##############################################################################
## Copyright (c) 2021 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Robin Getz <robin.getz@analog.com>
##
## Used to autogenerate wiki table, which goes : 
##   https://wiki.analog.com/resources/fpga/docs/hdl
###############################################################################

echo "^  Carrier  ^  Add on Board  ^  Source ^  Project Doc  ^  HDL Doc  ^  Linux Device Driver  ^"
for table in $(find ./ -mindepth 2 -maxdepth 2 -type d -print | grep -v "common" | grep -v "doc$" | awk -F'/' '{print $3"/"$2}' | sort)
do
	echo -n $(echo $table | awk -F'/' '{print "| " $1 " |"}' | \
		sed -e 's/zed/\[\[xilinx>products\/boards-and-kits\/1-8dyf-11.html|zed\]\]/' \
		    -e 's/zc702/\[\[xilinx>zc702\]\]/' \
		    -e 's/zc706/\[\[xilinx>zc706\]\]/' \
		    -e 's/vc707/\[\[xilinx>vc707\]\]/' \
		    -e 's/kc705/\[\[xilinx>kc705\]\]/' \
		    -e 's/kcu105/\[\[xilinx>kcu105\]\]/' \
		    -e 's/zcu102/\[\[xilinx>zcu102\]\]/' \
		    -e 's/vck190/\[\[xilinx>vck190\]\]/' \
		    -e 's/vcu118/\[\[xilinx>vcu118\]\]/' \
		    -e 's/adrv2crr_fmc /\[\[adi>adrv2crr-fmc|adrv2crr_fmc\]\] /' \
		    -e 's/adrv2crr_fmcomms8/\[\[adi>adrv2crr-fmc|adrv2crr_fmc\]\] + \[\[adi>eval-ad-fmcomms8-ebz|fmcomms8\]\]/' \
		    -e 's/ccbob_cmos/\[\[adi>ADRV1CRR-BOB|ccbob_cmos\]\]/' \
		    -e 's/ccbob_lvds/\[\[adi>ADRV1CRR-BOB|ccbob_lvds\]\]/' \
		    -e 's/ccfmc_lvds/\[\[adi>ADRV1CRR-FMC|ccfmc_lvds\]\]/' \
		    -e 's/ccpackrf_lvds/\[\[adi>cn0412|ccpackrf_lvds\]\]/' \
		    -e 's$a10gx$\[\[https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/kit-a10-gx-fpga.html|a10gx\]\]$' \
		    -e 's$a10soc$\[\[https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/arria-10-soc-development-kit.html|a10soc\]\]$' \
		    -e 's$s10soc$\[\[https://www.intel.com/content/www/us/en/programmable/products/boards_and_kits/dev-kits/altera/stratix-10-soc-development-kit.html|s10soc\]\]$' \
		    -e 's$c5soc$\[\[https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=819|c5soc\]\]$' \
		    -e 's$coraz7s$\[\[https://digilent.com/shop/cora-z7-zynq-7000-single-core-and-dual-core-options-for-arm-fpga-soc-development/|coraz7s\]\]$' \
		    -e 's$de10nano$\[\[https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=167&No=1046|de10nano\]\]$' \
		)

	PROJECT=$(echo $table | sed 's|^.*/||')
	README="./${PROJECT}/Readme.md"
	if [ ! -f ${README} ] ; then
		echo -n "  ${PROJECT} |"
		echo -n "  [[repo>hdl/tree/main/projects/${PROJECT}|Source]] |"
		echo -n " missing ${README} |||"
	else
		BOARD=$(grep -i "Board Product Page" ${README} | sed -e 's|^.*(||' -e 's|).*$||' -e 's|http.*\/\/www\.analog\.com\/|adi>|')
		PROJECT_DOC=$(grep -i "Project Doc" ${README}  | sed -e 's/^[^:]*://g' -e 's|).*$||' -e 's|http.*\/\/wiki\.analog\.com||g')
		LINUX_DOC=$(grep -i "Linux Drivers" ${README}  | sed -e 's/^[^:]*://g' -e 's|http.*://wiki.analog.com||g' -e 's|^[[:space:]]*||')
		HDL_DOC=$(grep -i "HDL Doc" ${README}          | sed -e 's/^[^:]*://g' -e 's|http.*://wiki.analog.com||g' -e 's|^[[:space:]]*||')

		if [ ! -z "${BOARD}" ] ; then
			i=0
			for link in $BOARD
			do
				if [ "${i}" -gt "0" ] ; then
					echo -n " \\\\\ "
				fi
				i=$((i+1))
				echo -n " [[${link}|${PROJECT}]] "
			done
			echo -n "|"
		else
			echo -n "  ${PROJECT} |"
		fi

		echo -n "  [[repo>hdl/tree/main/projects/${PROJECT}|Source]] |"

		if [ ! -z "${PROJECT_DOC}" ] ; then
			i=0
			for link in ${PROJECT_DOC}
			do
				if [ "${i}" -gt "0" ] ; then
					echo -n " \\\\\ "
				fi
				i=$((i+1))
				echo -n " [[${link}|Project Doc]] "
			done
			echo -n "|"
		else
			echo -n "  Missing  |"
		fi

		if [ ! -z "${HDL_DOC}" ] ; then
			i=0
			for link in ${HDL_DOC}
			do
				if [ "${i}" -gt "0" ] ; then
					echo -n " \\\\\ "
				fi
				i=$((i+1))
				echo -n " [[${link}|HDL Doc]] "
			done
			echo -n "|"
		else
			echo -n "  Missing  |"
		fi

		if [ ! -z "${LINUX_DOC}" ] ; then
			i=0
			for link in ${LINUX_DOC}
			do
				if [ "${i}" -gt "0" ] ; then
					echo -n " \\\\\ "
				fi
				i=$((i+1))
				echo -n " [[${link}|Linux Driver]] "
			done
			echo -n "|"
		else
			echo -n "  Missing  |"
		fi
	fi
	echo
done
