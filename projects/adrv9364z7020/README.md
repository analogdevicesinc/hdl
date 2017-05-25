# PicoZed SDR SOM (PZSDR2)

This folder contains the PZSDR2 SOM projects for each of the carrier boards.

## Board Design Files

| Directory/File       | Description                            |
|----------------------|----------------------------------------|
| common/pzsdr2_bd.tcl | pzsdr2 SOM module board design file.   |
| common/ccbrk_bd.tcl  | carrier, break out board design file.  |
| common/ccfmc_bd.tcl  | carrier, fmc board design file.        |
| common/ccpci_bd.tcl  | carrier, pci-e board design file.      |
| common/ccusb_bd.tcl  | carrier, usb board design file.        |

FMC & BRK carrier designs includes loopback daughtercards for connectivity testing.

## Board Constraint Files

| Directory/File                | Description                                   |
|-------------------------------|-----------------------------------------------|
| common/pzsdr2_constr.xdc      | pzsdr2 SOM base constraints file.             |
| common/pzsdr2_constr_cmos.xdc | pzsdr2 SOM CMOS mode constraints file.        |
| common/pzsdr2_constr_lvds.xdc | pzsdr2 SOM LVDS mode constraints file.        |
| common/ccbrk_constr.xdc       | carrier, break out board constraints file.    |
| common/ccfmc_constr.xdc       | carrier, fmc board constraints file.          |
| common/ccpci_constr.xdc       | carrier, pci-e board constraints file.        |
| common/ccusb_constr.xdc       | carrier, usb board constraints file.          |

FMC & BRK carrier designs includes loopback daughtercards for connectivity testing.

## Building, Generating Bit Files

[pzsdr2] cd ccbrk_cmos

[pzsdr2/ccbrk_cmos] make

The make in each carrier directory builds the corresponding project. The above example builds PZSDR2-CCBRK hardware bit files in CMOS mode.

## Documentation

 * [HDL Design User Guide]
 * [IP User Guide]
 * [PZSDR2 Wiki page]
 
[HDL Design User Guide]:http://wiki.analog.com/resources/fpga/docs/hdl
[IP User Guide]:http://wiki.analog.com/resources/fpga/docs/axi_ad9361 
[PZSDR2 Wiki page]:https://wiki.analog.com/resources/eval/user-guides/picozed_sdr

