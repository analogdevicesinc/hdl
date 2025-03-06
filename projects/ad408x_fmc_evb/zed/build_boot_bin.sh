#!/bin/bash
set -ex

XSA_FILE=$1
UBOOT_FILE=$2
BUILD_DIR=build_boot_bin
OUTPUT_DIR=output_boot_bin

usage () {
	echo "usage: $0 system_top.xsa u-boot.elf [output-archive]"
	exit 1
}

depends () {
	echo Xilinx $1 must be installed and in your PATH
	echo try: source /opt/Xilinx/Vivado/202x.x/settings64.sh
	exit 1
}

### Check command line parameters
echo $XSA_FILE | grep -q ".xsa" || usage
echo $UBOOT_FILE | grep -q -e ".elf" -e "uboot" -e "u-boot"|| usage

if [ ! -f $XSA_FILE ]; then
	echo $XSA_FILE: File not found!
	usage
fi

if [ ! -f $UBOOT_FILE ]; then
	echo $UBOOT_FILE: File not found!
	usage
fi

### Check for required Xilinx tools (xcst is equivalent with 'xsdk -batch')
command -v xsct >/dev/null 2>&1 || depends xsct
command -v bootgen >/dev/null 2>&1 || depends bootgen

rm -Rf $BUILD_DIR $OUTPUT_DIR
mkdir -p $OUTPUT_DIR
mkdir -p $BUILD_DIR

cp $XSA_FILE $BUILD_DIR/
cp $UBOOT_FILE $OUTPUT_DIR/u-boot.elf
cp $XSA_FILE $OUTPUT_DIR/

### Create create_fsbl_project.tcl file used by xsct to create the fsbl.
echo "hsi open_hw_design `basename $XSA_FILE`" > $BUILD_DIR/create_fsbl_project.tcl
echo 'set cpu_name [lindex [hsi get_cells -filter {IP_TYPE==PROCESSOR}] 0]' >> $BUILD_DIR/create_fsbl_project.tcl
echo 'platform create -name hw0 -hw system_top.xsa -os standalone -out ./build/sdk -proc $cpu_name' >> $BUILD_DIR/create_fsbl_project.tcl
echo 'platform generate' >> $BUILD_DIR/create_fsbl_project.tcl

FSBL_PATH="$BUILD_DIR/build/sdk/hw0/export/hw0/sw/hw0/boot/fsbl.elf"
SYSTEM_TOP_BIT_PATH="$BUILD_DIR/build/sdk/hw0/hw/system_top.bit"

### Create zynq.bif file used by bootgen
echo 'the_ROM_image:' > $OUTPUT_DIR/zynq.bif
echo '{' >> $OUTPUT_DIR/zynq.bif
echo '[bootloader] fsbl.elf' >> $OUTPUT_DIR/zynq.bif
echo 'system_top.bit' >> $OUTPUT_DIR/zynq.bif
echo 'u-boot.elf' >> $OUTPUT_DIR/zynq.bif
echo '}' >> $OUTPUT_DIR/zynq.bif

### Build fsbl.elf
(
	cd $BUILD_DIR
	xsct create_fsbl_project.tcl
)

### Copy fsbl and system_top.bit into the output folder
cp $FSBL_PATH $OUTPUT_DIR/fsbl.elf
cp $SYSTEM_TOP_BIT_PATH $OUTPUT_DIR/system_top.bit

### Build BOOT.BIN
(
	cd $OUTPUT_DIR
	bootgen -arch zynq -image zynq.bif -o BOOT.BIN -w
)

### Optionally tar.gz the entire output folder with the name given in argument 3
if [ ${#3} -ne 0 ]; then
	tar czvf $3.tar.gz $OUTPUT_DIR
fi
