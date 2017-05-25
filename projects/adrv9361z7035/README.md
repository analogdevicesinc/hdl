# ADRV1CRR SDR SOM 

This folder contains the ADRV1CRR SOM projects for each of the carrier boards.

## Board Design Files

| Directory/File              | Description                            |
|-----------------------------|----------------------------------------|
| common/adrv9361z7035_bd.tcl | ADRV1CRR SOM module board design file. |
| common/ccbob_bd.tcl         | carrier, break out board design file.  |
| common/ccfmc_bd.tcl         | carrier, fmc board design file.        |
| common/ccpci_bd.tcl         | carrier, pci-e board design file.      |
| common/ccusb_bd.tcl         | carrier, usb board design file.        |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Board Constraint Files

| Directory/File                       | Description                                   |
|--------------------------------------|-----------------------------------------------|
| common/adrv9361z7035_constr.xdc      | ADRV1CRR SOM base constraints file.           |
| common/adrv9361z7035_constr_cmos.xdc | ADRV1CRR SOM CMOS mode constraints file.      |
| common/adrv9361z7035_constr_lvds.xdc | ADRV1CRR SOM LVDS mode constraints file.      |
| common/ccbob_constr.xdc              | carrier, break out board constraints file.    |
| common/ccfmc_constr.xdc              | carrier, fmc board constraints file.          |
| common/ccpci_constr.xdc              | carrier, pci-e board constraints file.        |
| common/ccusb_constr.xdc              | carrier, usb board constraints file.          |

FMC & BRK carrier designs includes loopback daughtercards for connectivity testing.

## Building, Generating Bit Files

[adrv9361z7035] cd ccbob_cmos

[adrv9361z7035/ccbob_cmos] make

The make in each carrier directory builds the corresponding project. The above example builds ADRV1CRR-BOB hardware bit files in CMOS mode.

## Documentation

 * [HDL Design User Guide]
 * [IP User Guide]
 * [ADRV1CRR Wiki page]
 
[HDL Design User Guide]:http://wiki.analog.com/resources/fpga/docs/hdl
[IP User Guide]:http://wiki.analog.com/resources/fpga/docs/axi_ad9361 
[ADRV1CRR Wiki page]:https://wiki.analog.com/resources/eval/user-guides/picozed_sdr

